class RentalStatus < ActiveRecord::Base
  has_many :loe_cases
  validates :name, presence: true, uniqueness: true
end
