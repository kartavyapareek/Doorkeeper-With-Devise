class UserProfile < ApplicationRecord
  validates :phone, presence: true, uniqueness: true
  belongs_to :user
end
