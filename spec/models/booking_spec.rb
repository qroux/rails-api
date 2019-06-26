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

  it "validation: Booking should fail if already booked for the same period" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.today, end_date: Date.tomorrow)
    Booking.create(listing_id: Listing.last.id, start_date: Date.today, end_date: Date.tomorrow)
    expect(Booking.count).to eq(1)
  end

  it "validation: Booking should work if already booked for another period" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.today, end_date: Date.tomorrow)
    Booking.create(listing_id: Listing.last.id, start_date: Date.new(2020,7,25), end_date: Date.new(2020,7,30))
    expect(Booking.count).to eq(2)
  end

  it "CRUD + validation: Booking update should fail if already booked for the same period" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,1), end_date: Date.new(2019,8,5))
    Booking.create(listing_id: Listing.last.id, start_date: Date.new(2019,7,25), end_date: Date.new(2019,7,30))
    Booking.last.update(end_date: Date.new(2019,8,2))
    expect(Booking.last.end_date).to eq(Date.new(2019,7,30))
  end
end
