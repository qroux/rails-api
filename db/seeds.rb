require 'json'

file = Rails.root.join('backend', 'backend_test.rb')
data = JSON.parse(File.read(file))

data['listings'].each do |listing|
  Listing.create!(num_rooms: listing['num_rooms'])
  puts "listing created"
end

data['bookings'].each do |booking|
  Booking.create!(
    listing_id: booking['listing_id'],
    start_date: booking['start_date'],
    end_date: booking['end_date']
  )
  puts "booking created"
end

data['reservations'].each do |reservation|
  Reservation.create!(
    listing_id: reservation['listing_id'],
    start_date: reservation['start_date'],
    end_date: reservation['end_date']
  )
  puts "reservation created"
end

# callbacks must generate 8 missions(6 from bookings, 2 from reservations)
