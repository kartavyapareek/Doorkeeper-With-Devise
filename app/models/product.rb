class Product < ApplicationRecord
  has_one :product_rate, dependent: :destroy
  validates :name, presence: true, uniqueness: true

  accepts_nested_attributes_for :product_rate
end
