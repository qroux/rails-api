require 'rails_helper'

RSpec.describe Mission, type: :model do
  it "CREATE: booking_missions must create first_checkin + checkout_checkin when Booking is created" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.today, end_date: Date.tomorrow)
    expect(Mission.count).to eq(2)
  end

  it "à mettre dans test de Booking#controller  UPDATE: booking_missions must update first_checkin when Booking is updated" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.today, end_date: (Date.tomorrow + 1))

    book = Booking.last

    first_checkin = Mission.where(date: book.start_date, listing_id: book.listing.id, mission_type: 'first_checkin')
    checkout_checkin = Mission.where(date: book.end_date, listing_id: book.listing.id, mission_type: 'checkout_checkin')
    expect(first_checkin.count).to eq(1)
    expect(checkout_checkin.count).to eq(1)


    Booking.last.update(start_date: (Date.today + 1))
    expect(Mission.first.date).to eq(Date.today + 1)
  end

  it "à mettre dans test de Booking#controller UPDATE: booking_missions must update checkout_checkin when Booking is updated" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.today, end_date: (Date.tomorrow + 1))
    Booking.last.update(end_date: (Date.tomorrow + 2))
    expect(Mission.last.date).to eq(Date.tomorrow + 2)
  end

  it "à mettre dans test de Booking#controller UPDATE: booking_missions must update first_checkin && checkout_checkin when Booking is updated" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.today, end_date: (Date.tomorrow + 1))
    Booking.last.update(start_date: (Date.today + 1), end_date: (Date.tomorrow + 2))
    expect(Mission.first.date).to eq(Date.today + 1)
    expect(Mission.last.date).to eq(Date.tomorrow + 2)
  end

  it "DESTROY + association: first_checkin + checkout_checkin should be destroyed when Booking is destroyed" do
    Listing.create(num_rooms: 10)
    Booking.create(listing_id: Listing.last.id, start_date: Date.today, end_date: Date.tomorrow)
    expect(Mission.count).to eq(2)
    Booking.last.destroy
    expect(Mission.count).to eq(0)
  end
end
