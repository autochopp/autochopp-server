class ChoppsController < ApplicationController
  skip_before_action :authenticate_request , only: [:validate_qrcode]

  def validate_qrcode
    chopp = Chopp.find_by(qrcode: params[:qrcode])
    if chopp && chopp.qrcode_validate
      chopp_attr = {:size => chopp.size, :chopp_type => chopp.chopp_type, :collar => chopp.collar}
      chopps_combinations = Chopp.create_chopps_combinations

      chopps_combinations.each_with_index do |value, position|
        if value == chopp_attr
          chopp.qrcode_validate = false
          chopp.save

          render json: {code: position, status: :ok}
        end 
      end
    else
      render json: {errors: "QRCode Invalido", status: :bad_request}          
    end
  end

  def index
    orders = Order.where(user: @current_user)
    
    chopps = []

    orders.each do |order|
      order.chopps.each do |chopp|
        if chopp.qrcode_validate != false
          chopps << chopp
        end
      end
    end

    render json: chopps, status: :ok
  end

end