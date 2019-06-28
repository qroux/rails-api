require 'rails_helper'

RSpec.describe Reservation, type: :model do
  it "CREATE: Reservation creation work (with listing_id + start + end date)" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,1), end_date: Date.new(2019,8,5))
    Reservation.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,2), end_date: Date.new(2019,8,4))
    expect(Reservation.count).to eq(1)
  end

  it "validation: Reservation should fail if start_date > end_date" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,1), end_date: Date.new(2019,8,5))
    Reservation.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,4), end_date: Date.new(2019,8,2))
    expect(Reservation.count).to eq(0)
  end

  it "reservability: Reservation should fail if already reserved(intersection)" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,1), end_date: Date.new(2019,8,10))
    Reservation.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,2), end_date: Date.new(2019,8,5))
    Reservation.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,3), end_date: Date.new(2019,8,9))
    expect(Reservation.count).to eq(1)
  end

  it "reservability: Reservation should fail if already reserved(inclusion smaller -> greater)" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,1), end_date: Date.new(2019,8,10))
    Reservation.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,4), end_date: Date.new(2019,8,6))
    Reservation.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,3), end_date: Date.new(2019,8,9))
    expect(Reservation.count).to eq(1)
  end

  it "reservability: Reservation should fail if already reserved(inclusion greater -> smaller)" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,1), end_date: Date.new(2019,8,10))
    Reservation.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,3), end_date: Date.new(2019,8,9))
    Reservation.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,4), end_date: Date.new(2019,8,6))
    expect(Reservation.count).to eq(1)
  end

  it "UPDATE : Reservation update should work" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,1), end_date: Date.new(2019,8,10))
    Reservation.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,2), end_date: Date.new(2019,8,5))
    Reservation.last.update(end_date: Date.new(2019,8,9))
    expect(Reservation.last.end_date).to eq(Date.new(2019,8,9))
  end

  it "UPDATE : Reservation update should work if already reserved at another date(no inclusion nor intersection)" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,1), end_date: Date.new(2019,8,31))
    Reservation.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,15), end_date: Date.new(2019,8,20))
    Reservation.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,2), end_date: Date.new(2019,8,10))
    Reservation.last.update(end_date: Date.new(2019,8,13))
    expect(Reservation.last.end_date).to eq(Date.new(2019,8,13))
  end

  it "UPDATE + reservability: Reservation update should fail if already reserved(intersection)" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,1), end_date: Date.new(2019,8,15))
    Reservation.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,6), end_date: Date.new(2019,8,9))
    Reservation.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,2), end_date: Date.new(2019,8,5))
    Reservation.last.update(end_date: Date.new(2019,8,8))
    expect(Reservation.last.end_date).to eq(Date.new(2019,8,5))
  end

  it "UPDATE + reservability: Reservation update should fail if already reserved(inclusion)" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,1), end_date: Date.new(2019,8,15))
    Reservation.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,11), end_date: Date.new(2019,8,14))
    Reservation.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,2), end_date: Date.new(2019,8,10))
    Reservation.last.update(end_date: Date.new(2019,8,13))
    expect(Reservation.last.end_date).to eq(Date.new(2019,8,10))
  end

  it "DESTROY + association: Listing destruction also destroy reservation associated" do
    Listing.create(num_rooms: 2)
    Booking.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,1), end_date: Date.new(2019,8,8))
    Reservation.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,4), end_date: Date.new(2019,8,5))
    Listing.last.destroy
    expect(Reservation.count).to eq(0)
  end
end
