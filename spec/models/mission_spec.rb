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

  it "UPDATE: booking.update must update first_checkin" do
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

  it "UPDATE: booking.update must update last_checkout" do
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

  it "UPDATE: booking.update must update first_checkin && last_checkout" do
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

  it "DESTROY + association: first_checkin + last_checkout should be destroyed when Listing is destroyed" do
    Listing.create(num_rooms: 10)
    Booking.create(
      listing_id: Listing.last.id,
      start_date: Date.today,
      end_date: Date.tomorrow
    )

    expect(Mission.count).to eq(2)

    Listing.last.destroy

    expect(Listing.count).to eq(0)
    expect(Booking.count).to eq(0)
    expect(Mission.count).to eq(0)
  end

  it "CREATE: reservation.create must create checkout_checkin" do
    Listing.create(num_rooms: 10)
    Booking.create(
      listing_id: Listing.last.id,
      start_date: Date.today,
      end_date: (Date.today + 7)
    )
    expect(Mission.count).to eq(2)
    expect(Mission.first.mission_type).to eq('first_checkin')
    expect(Mission.last.mission_type).to eq('last_checkout')

    Reservation.create(
      listing_id: Listing.last.id,
      start_date: Date.today,
      end_date: (Date.today + 5)
    )
    expect(Mission.count).to eq(3)
    expect(Mission.last.date).to eq(Reservation.last.end_date)
    expect(Mission.last.mission_type).to eq('checkout_checkin')
  end

  it "CREATE: reservation.create should not create extra checkout_checkin when last_checkout already exists" do
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
    expect(Mission.count).to eq(2)
  end
end
