require 'rails_helper'

RSpec.describe Mission, type: :model do
  it "CREATE: booking_missions must create first_checkin + checkout_checkin when Booking is created" do
    Listing.create(num_rooms: 10)
    Booking.create(
      listing_id: Listing.last.id,
      start_date: Date.today,
      end_date: Date.tomorrow
    )
    expect(Mission.count).to eq(2)
  end

  it "UPDATE: booking_missions must update first_checkin when Booking is updated" do
    Listing.create(num_rooms: 10)
    Booking.create(
      listing_id: Listing.last.id,
      start_date: Date.today,
      end_date: (Date.today + 5)
    )

    book = Booking.last

    first_checkin = Mission.where(
      date: book.start_date,
      listing_id: book.listing.id,
      mission_type: 'first_checkin'
    )
    last_checkout = Mission.where(
      date: book.end_date,
      listing_id: book.listing.id,
      mission_type: 'last_checkout'
    )

    expect(first_checkin.count).to eq(1)
    expect(last_checkout.count).to eq(1)

    book.update(start_date: (Date.today + 2))
    new_first = Mission.find_by(
      date: book.start_date,
      listing_id: book.listing.id,
      mission_type: 'first_checkin'
    )

    expect(new_first.date).to eq(Date.today + 2)
  end

  it "UPDATE: booking_missions must update last_checkout when Booking is updated" do
    Listing.create(num_rooms: 10)
    Booking.create(
      listing_id: Listing.last.id,
      start_date: Date.today,
      end_date: (Date.today + 5)
    )

    book = Booking.last

    book.update(end_date: (Date.today + 10))
    last_checkout = Mission.find_by(
      date: book.end_date,
      listing_id: book.listing.id,
      mission_type: 'last_checkout'
    )

    expect(book.end_date).to eq(last_checkout.date)
  end

  it "UPDATE: booking_missions must update first_checkin && last_checkout when Booking is updated" do
    Listing.create(num_rooms: 10)
    Booking.create(
      listing_id: Listing.last.id,
      start_date: Date.today,
      end_date: (Date.today + 5)
    )

    book = Booking.last

    book.update(start_date: (Date.today + 2), end_date: (Date.today + 7))
    first_checkin = Mission.find_by(
      date: book.start_date,
      listing_id: book.listing.id,
      mission_type: 'first_checkin'
    )
    last_checkout = Mission.find_by(
      date: book.end_date,
      listing_id: book.listing.id,
      mission_type: 'last_checkout'
    )

    expect(first_checkin.date).to eq(Date.today + 2)
    expect(last_checkout.date).to eq(Date.today + 7)
  end

  it "DESTROY + association: first_checkin + last_checkout should be destroyed when Booking is destroyed" do
    Listing.create(num_rooms: 10)
    Booking.create(
      listing_id: Listing.last.id,
      start_date: Date.today,
      end_date: Date.tomorrow
    )

    expect(Mission.count).to eq(2)

    Booking.last.destroy

    expect(Mission.count).to eq(0)
  end

  it "CREATE: reservation_missions must create checkin_checkout when Reservation is created" do
    Listing.create(num_rooms: 10)
    Booking.create(
      listing_id: Listing.last.id,
      start_date: Date.today,
      end_date: (Date.today + 7)
    )
    expect(Mission.count).to eq(2)

    Reservation.create(
      listing_id: Listing.last.id,
      start_date: Date.today,
      end_date: (Date.today + 7)
    )
    expect(Mission.count).to eq(3)
  end

  it "XXXXXCREATE: reservation_missions should not create extra checkin_checkout when last_checkout already exists" do
    Listing.create(num_rooms: 10)
    Booking.create(
      listing_id: Listing.last.id,
      start_date: Date.today,
      end_date: (Date.today + 7)
    )
    expect(Mission.count).to eq(2)

    Reservation.create(
      listing_id: Listing.last.id,
      start_date: Date.today,
      end_date: (Date.today + 7)
    )
    expect(Mission.count).to eq(16)
  end
end
