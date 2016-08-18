class CaseStatus < ActiveRecord::Base
  has_many :loe_cases
  validates :name, presence: true, uniqueness: true

  scope :open, -> { where(name: 'Open').first }
  scope :closed, -> { where(name: 'Closed').first }
end
