class Listing < ApplicationRecord
  has_many :bookings, dependent: :destroy

  validates :num_rooms, numericality: { only_integer: true, greater_than: 0 }
end
