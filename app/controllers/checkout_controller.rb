class CheckoutController < ApplicationController

  # Generate session token for payment
  def generate_session_token
    @session = PagSeguro::Session.create

    if @session.id
      render json: @session.id.to_json
    else
      render json: @session.errors.to_json
    end
  end

  # Send payment data for pagseguro
  def create

    # Create order in database
    order = Order.create(user: @current_user, status: "Em análise")

    chopps = [] # Array with pagseguro items

    # Format params[:chopps] -> {chopps: [
    # {amount: 8.00, quantity: 1, size: 1000, chopp_type: "tradicional", collar: 2},
    # {amount: 5.00, quantity: 1, size: 500, chopp_type: "vinho", collar: 0}]}
    chopps_params = params[:chopps]
    chopps_params.each do |t|
      # Creating a chopps in database
      chopp = Chopp.create(order: order, price: t['amount'], size: t['size'],
                           chopp_type: t['chopp_type'], collar: t['collar'])
      # Creating pagseguro items
      chopps << PagSeguro::Item.new(id: chopp.id, description: "Chopp",
                                    amount: chopp.price ,  quantity: t['quantity'])
    end

    # Creating payment pagseguro request
    payment = PagSeguro::CreditCardTransactionRequest.new

    payment.payment_mode = "gateway"
    payment.notification_url = "https://fast-retreat-18030.herokuapp.com/notification"
    payment.reference = order.id


    chopps.each do |chopp|
      payment.items << chopp
    end

    payment.sender = {
      hash: params[:sender_hash],
      name: params[:name],
      email: "c18315567957132943379@sandbox.pagseguro.com.br" # Email must be with this domain because it is in the test environment
    }

    payment.credit_card_token = params[:card_token]

    payment.holder = {
     name: params[:card_name],
     birth_date: params[:birthday],
     document: {
       type: "CPF",
       value: params[:cpf]
     },
     phone: {
       area_code: params[:phone_code],
       number: params[:phone_number]
     }
    }

    payment.installment = {
      quantity: 1
    }

    payment.create

    # Assigning the total amount of the payment to the order
    order.total_price = payment.gross_amount.to_f
    order.save

    if payment.errors.any?
      render json: payment.errors
    else
      render json: order, status: :created
    end

  end
end
