require 'rails_helper'

RSpec.describe Booking, type: :model do
  it "CRUD: Booking creation work" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.today, end_date: Date.tomorrow)
    expect(Booking.count).to eq(1)
  end

  it "validation: Booking without listing_id should fail" do
    Booking.create(start_date: Date.today, end_date: Date.tomorrow)
    expect(Booking.count).to eq(0)
  end

  it "validation: Booking without date should fail" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id)
    expect(Booking.count).to eq(0)
  end

  it "validation: Booking with star_date >= end_date should fail" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.tomorrow, end_date: Date.today)
    expect(Booking.count).to eq(0)
  end
end
