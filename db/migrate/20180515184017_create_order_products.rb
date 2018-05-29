class CreateOrderProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :order_products do |t|
      t.references :order, null: false, index: true
      t.references :product, null: false, index: true
      t.references :user, null:false, index: true
      
      t.timestamps
    end
  end
end
