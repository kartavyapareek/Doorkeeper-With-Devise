class CreateProductRates < ActiveRecord::Migration[5.1]
  def change
    create_table :product_rates do |t|
      t.integer :rate, null: false
      t.references :product, null: false, index: true

      t.timestamps
    end
  end
end
