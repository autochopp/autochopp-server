class NotificationController < ApplicationController
  
  def create
    transaction = PagSeguro::Transaction.find_by_notification_code(params[:notificationCode])
    status = ['Aguardando Pagamento', 'Em análise', 'Paga', 'Disponível', 'Em disputa', 'Devolvida', 'Cancelada']

    if transaction.errors.empty?
      order = Order.where(reference: transaction.reference).last
      order.status = status[transaction.status.id.to_i - 1]
      order.save

      order.chopps.each do |chopp|
        chopp.qrcode = chopp.id.to_s + SecureRandom.hex(8)
        chopp.qrcode_validate = true
        chopp.save
      end

  end

end
