# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Listing.create(num_rooms: 2)
Booking.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,1), end_date: Date.new(2019,8,31))
# Reservation.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,1), end_date: Date.new(2019,8,10))
# Mission.create(listing_id: Listing.last.id, mission_type: "checkin", price: 10, date: Date.new(2019,8,1))
# Mission.create(listing_id: Listing.last.id, mission_type: "intermediate", price: 5, date: Date.new(2019,8,1))
# Mission.create(listing_id: Listing.last.id, mission_type: "checkout", price: 10, date: Date.new(2019,8,1))


Listing.create(num_rooms: 5)
Booking.create(listing_id: Listing.last.id, start_date: Date.new(2019,9,1), end_date: Date.new(2019,9,30))
# Booking.last.update(start_date: Date.new(2019,9,2), end_date: Date.new(2019,10,1))
