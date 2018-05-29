class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :name
      t.references :user, null: false, index: true
      t.timestamps
    end
  end
end
