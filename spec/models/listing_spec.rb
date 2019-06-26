require 'rails_helper'

RSpec.describe Listing, type: :model do
  it "CRUD: Listing creation works" do
    Listing.create(num_rooms: 2)
    expect(Listing.count).to eq(1)
  end

  it "CRUD: Listing update works" do
    Listing.create(num_rooms: 2)
    Listing.last.update(num_rooms: 12)
    expect(Listing.last.num_rooms).to eq(12)
  end

  it "CRUD: Listing destruction works" do
    Listing.create(num_rooms: 2)
    Listing.last.destroy
    expect(Listing.count).to eq(0)
  end

  it "association: Listing destruction works with booking associated" do
    Listing.create(num_rooms: 2)
    Booking.create(listing_id: Listing.last.id, start_date: Date.today, end_date: Date.tomorrow)
    Listing.last.destroy
    expect(Listing.count).to eq(0)
  end

  it "validation: Listing without num_rooms should fail" do
    Listing.create
    expect(Listing.count).to eq(0)
  end

  it "validation: Listing with negative num_rooms should fail" do
    Listing.create(num_rooms: -5)
    expect(Listing.count).to eq(0)
  end
end
