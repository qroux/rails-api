class Mission < ApplicationRecord
  belongs_to :listing

  validates :mission_type, :date, presence: true
  validates :price, numericality: { only_integer: true, greater_than: 0 }
end
