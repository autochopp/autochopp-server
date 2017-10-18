class CreateChopps < ActiveRecord::Migration[5.0]
  def change
    create_table :chopps do |t|
      t.integer :size
      t.string :chopp_type
      t.integer :collar
      t.float :price
      t.string :qrcode
      t.boolean :qrcode_validate
      t.belongs_to :order

      t.timestamps
    end
  end
end
