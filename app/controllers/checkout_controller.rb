class CheckoutController < ApplicationController
  skip_before_action :authenticate_request    
  
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

    current_user = User.find_by(email: params[:email])

    # Create order in database
    order = Order.create(user: current_user, status: "Em análise")

 
    chopps = [] # Array with pagseguro items

    # Format params[:chopps] -> {chopps:[{amount: 8.00, quantity: 1, size: 1000, chopp_type: "tradicional", collar: 2},{amount: 5.00, quantity: 1, size: 500, chopp_type: "vinho", collar: 0}]}
    chopps_params = params[:chopps]
    chopps_params.each do |t|
        
      # Creating a chopps in database
      chopp = Chopp.create(order: order, price: t['amount'], size: t['size'], chopp_type: t['chopp_type'], collar: t['collar'])
      # Creating pagseguro items
      chopps << PagSeguro::Item.new(id: chopp.id, description: "Chopp", amount: chopp.price ,  quantity: t['quantity'])
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

    order.total_price = payment.gross_amount.to_f # Assigning the total amount of the payment to the order    
    order.save


    if payment.errors.any?
      render json: payment.errors
    else
      render json: order, status: :created      
    end

    # Code below only for debug

    # if payment.errors.any?
    #   puts "=> ERRORS"
    #   puts payment.errors.join("\n")
    #  else
    #   puts "=> Transaction"
    #   puts "  code: #{payment.code}"
    #   puts "  reference: #{payment.reference}"
    #   puts "  type: #{payment.type_id}"
    #   puts "  payment link: #{payment.payment_link}"
    #   puts "  status: #{payment.status}"
    #   puts "  payment method type: #{payment.payment_method}"
    #   puts "  created at: #{payment.created_at}"
    #   puts "  updated at: #{payment.updated_at}"
    #   puts "  gross amount: #{payment.gross_amount.to_f}"
    #   puts "  discount amount: #{payment.discount_amount.to_f}"
    #   puts "  net amount: #{payment.net_amount.to_f}"
    #   puts "  extra amount: #{payment.extra_amount.to_f}"
    #   puts "  installment count: #{payment.installment_count}"
 
    #   puts "    => Items"
    #   puts "      items count: #{payment.items.size}"
    #   payment.items.each do |item|
    #     puts "      item id: #{item.id}"
    #     puts "      description: #{item.description}"
    #     puts "      quantity: #{item.quantity}"
    #     puts "      amount: #{item.amount.to_f}"
    #   end
 
    #   puts "    => Sender"
    #   puts "      name: #{payment.sender.name}"
    #   puts "      email: #{payment.sender.email}"
    #   puts "      phone: (#{payment.sender.phone.area_code}) #{payment.sender.phone.number}"
    #   puts "      document: #{payment.sender.document}: #{payment.sender.document}"
    #  end

  end
end
