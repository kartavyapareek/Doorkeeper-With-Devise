class CreateUserProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :user_profiles do |t|
      t.references :user, null: false, unique: true, index: true
      t.string :name
      t.string :phone
      
      t.timestamps
    end
  end
end
