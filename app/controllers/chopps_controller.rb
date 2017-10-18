class ChoppsController < ApplicationController
  skip_before_action :authenticate_request

  def validate_qrcode
    chopp = Chopp.find_by(qrcode: params[:qrcode])
    if chopp && chopp.qrcode_validate
      chopp_attr = {:size => chopp.size, :chopp_type => chopp.chopp_type, :collar => chopp.collar}
      chopps_combinations = Chopp.create_chopps_combinations

      chopps_combinations.each_with_index do |value, position|
        if value == chopp_attr
          render json: {code: position}
        end 
      end
    else
      render json: {error: "QRCode Invalido"}          
    end
  end

end