require 'rails_helper'
# if Date.today == Date.tommorrow, application.rb add config.time_zone = 'Paris'

RSpec.describe Booking, type: :model do
  it "CREATE: Booking creation work" do
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

  it "validation: Booking with start_date >= end_date should fail" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.tomorrow, end_date: Date.today)
    expect(Booking.count).to eq(0)
  end

  it "availability: Booking should work if already booked for another period" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.today, end_date: Date.tomorrow)
    Booking.create(listing_id: Listing.last.id, start_date: Date.new(2020,7,25), end_date: Date.new(2020,7,30))
    expect(Booking.count).to eq(2)
  end

  it "availability: Booking should fail if already booked for the exact same period" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,1), end_date: Date.new(2019,8,5))
    Booking.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,1), end_date: Date.new(2019,8,5))
    expect(Booking.count).to eq(1)
  end

  it "availability: Booking should fail if booking already exist(intersection)" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,1), end_date: Date.new(2019,8,5))
    Booking.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,3), end_date: Date.new(2019,8,8))
    expect(Booking.count).to eq(1)
  end

  it "availability: Booking should fail if already booked(inclusion smaller -> greater)" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.tomorrow, end_date: (Date.today + 5))
    Booking.create(listing_id: Listing.last.id, start_date: Date.today, end_date: (Date.today + 7))
    expect(Booking.count).to eq(1)
  end

  it "availability: Booking should fail if already booked(inclusion greater -> smaller)" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.today, end_date: (Date.today + 7))
    Booking.create(listing_id: Listing.last.id, start_date: Date.tomorrow, end_date: (Date.today + 5))
    expect(Booking.count).to eq(1)
  end

  it "UPDATE + availability: Booking update should fail if already booked(intersection)" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,1), end_date: Date.new(2019,8,5))
    Booking.create(listing_id: Listing.last.id, start_date: Date.new(2019,7,25), end_date: Date.new(2019,7,30))
    Booking.last.update(end_date: Date.new(2019,8,2))
    expect(Booking.last.end_date).to eq(Date.new(2019,7,30))
  end

  it "UPDATE + availability: Booking update should fail if already booked(inclusion)" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,1), end_date: Date.new(2019,8,5))
    Booking.create(listing_id: Listing.last.id, start_date: Date.new(2019,7,25), end_date: Date.new(2019,7,30))
    Booking.last.update(end_date: Date.new(2019,8,8))
    expect(Booking.last.end_date).to eq(Date.new(2019,7,30))
  end
end
