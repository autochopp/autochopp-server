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

  
  # Post for create a pagseguro transaction and persist data in database
  def create

    # Register order in database
    order = Order.create(user: @current_user, status: "Em análise")
    
    # Register chopps in database
    Chopp.create_chopps(params[:chopps], order)
    
    payment = create_payment_request(order)

    # Assigning the total amount of the payment to the order
    order.total_price = payment.gross_amount.to_f
    order.save

    debug_payment(payment)

    if payment.errors.any?
      Order.last.destroy
      render json: payment.errors
    else
      render json: order, status: :created
    end

  end

  def create_pagseguro_items(order)
    items = []

    order.chopps.each do |chopp|
      items << PagSeguro::Item.new(id: chopp.id, description: "Chopp", amount: chopp.price,
                                   quantity: 1)
    end

    return items
  end

  # Creating payment pagseguro request
  def create_payment_request(order)
    
    payment = PagSeguro::CreditCardTransactionRequest.new

    payment.payment_mode = "gateway"
    payment.notification_url = "https://fast-retreat-18030.herokuapp.com/notification"
    payment.reference = order.id


    items = create_pagseguro_items(order)
    items.each do |item|
      payment.items << item
    end

    payment.sender = {
      hash: params[:sender_hash],
      name: params[:name],
      email: "teste@sandbox.pagseguro.com.br" # Email must be with this domain because it is in the test environment
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
    
  end


  def debug_payment(payment)
    if payment.errors.any?		
      puts "=> ERRORS"		
      puts payment.errors.join("\n")		
     else		
      puts "=> Transaction"		
      puts "  code: #{payment.code}"		
      puts "  reference: #{payment.reference}"		
      puts "  type: #{payment.type_id}"		
      puts "  payment link: #{payment.payment_link}"		
      puts "  status: #{payment.status}"		
      puts "  payment method type: #{payment.payment_method}"		
      puts "  created at: #{payment.created_at}"		
      puts "  updated at: #{payment.updated_at}"		
      puts "  gross amount: #{payment.gross_amount.to_f}"		
      puts "  discount amount: #{payment.discount_amount.to_f}"		
      puts "  net amount: #{payment.net_amount.to_f}"		
      puts "  extra amount: #{payment.extra_amount.to_f}"		
      puts "  installment count: #{payment.installment_count}"		
    
      puts "    => Items"		
      puts "      items count: #{payment.items.size}"		
      payment.items.each do |item|		
        puts "      item id: #{item.id}"		
        puts "      description: #{item.description}"		
        puts "      quantity: #{item.quantity}"		
        puts "      amount: #{item.amount.to_f}"		
      end		
    
      puts "    => Sender"		
      puts "      name: #{payment.sender.name}"		
      puts "      email: #{payment.sender.email}"		
      puts "      phone: (#{payment.sender.phone.area_code}) #{payment.sender.phone.number}"		
      puts "      document: #{payment.sender.document}: #{payment.sender.document}"		
     end
  end
end
