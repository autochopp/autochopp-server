class Chopp < ApplicationRecord
  belongs_to :order

  # Format params[:chopps]  > {chopps: [
  # {amount: 8.00, quantity: 1, size: 1000, chopp_type: "tradicional", collar: 2},
  # {amount: 5.00, quantity: 1, size: 500, chopp_type: "vinho", collar: 0}]}

  def self.create_chopps(chopps, order)
    chopps.each do |chopp|
      chopp_quantity = chopp['quantity'].to_i
      (1..chopp_quantity).each do
        Chopp.create(order: order, price: chopp['amount'], size: chopp['size'],
                   chopp_type: chopp['chopp_type'], collar: chopp['collar'])
      end
    end
  end

  def self.create_chopps_combinations
    chopps_attr = { :size => [ 500, 1000],
                    :chopp_type  => ["tradicional", "vinho"],
                    :collar => [0, 1, 2] }

    ary = chopps_attr.map {|k,v| [k].product v}
    chopps_combinations = ary.shift.product(*ary).map {|a| Hash[a]}

    return chopps_combinations
  end
  
end
