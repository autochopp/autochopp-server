class Chopp < ApplicationRecord
  belongs_to :order

  # Format params[:chopps]  > {chopps: [
  # {amount: 8.00, quantity: 1, size: 1000, chopp_type: "tradicional", collar: 2},
  # {amount: 5.00, quantity: 1, size: 500, chopp_type: "vinho", collar: 0}]}

  def self.create_chopps(chopps, order)
    chopps.each do |t|
      Chopp.create(order: order, price: t['amount'], size: t['size'],
                   chopp_type: t['chopp_type'], collar: t['collar'])
    end                           
  end
  
end