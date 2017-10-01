class CheckoutController < ApplicationController
  
  def create_payment_session
    @session = PagSeguro::Session.create

    if @session.id
      render json: @session.id.to_json
    else
      render json: @session.errors.to_json
    end
  end
end
