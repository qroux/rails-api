class Listing < ApplicationRecord
  validates :num_rooms, numericality: { only_integer: true, greater_than: 0 }
end
