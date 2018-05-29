class ProductRate < ApplicationRecord
  belongs_to :product
  
  validates :rate, presence: true, numericality: {
    greater_than_or_equal_to: 0,
  }
end
