class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :status
      t.float :total_price
      t.belongs_to :user

      t.timestamps
    end
  end
end
