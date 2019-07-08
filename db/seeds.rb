Listing.create(num_rooms: 2)
Booking.create(listing_id: Listing.last.id, start_date: Date.new(2016,10,10), end_date: Date.new(2016,10,15))
Booking.create(listing_id: Listing.last.id, start_date: Date.new(2016,10,16), end_date: Date.new(2016,10,20))
Reservation.create(listing_id: Listing.last.id, start_date: Date.new(2016,10,11), end_date: Date.new(2016,10,13))
Reservation.create(listing_id: Listing.last.id, start_date: Date.new(2016,10,13), end_date: Date.new(2016,10,15))
Reservation.create(listing_id: Listing.last.id, start_date: Date.new(2016,10,16), end_date: Date.new(2016,10,20))

Listing.create(num_rooms: 1)
Booking.create(listing_id: Listing.last.id, start_date: Date.new(2016,10,15), end_date: Date.new(2016,10,20))
Reservation.create(listing_id: Listing.last.id, start_date: Date.new(2016,10,15), end_date: Date.new(2016,10,18))

Listing.create(num_rooms: 3)
# Reservation.create(listing_id: Listing.last.id, start_date: Date.new(2019,8,1), end_date: Date.new(2019,8,10))

# Listing.create(num_rooms: 5)
# Booking.create(listing_id: Listing.last.id, start_date: Date.new(2019,9,1), end_date: Date.new(2019,9,30))
# # Booking.last.update(start_date: Date.new(2019,9,2), end_date: Date.new(2019,10,1))

# {
#   "listings": [
#     { "id": 1, "num_rooms": 2 },
#     { "id": 2, "num_rooms": 1 },
#     { "id": 3, "num_rooms": 3 }
#   ],
#   "bookings": [
#     { "id": 1, "listing_id": 1, "start_date": "2016-10-10", "end_date": "2016-10-15" },
#     { "id": 2, "listing_id": 1, "start_date": "2016-10-16", "end_date": "2016-10-20" },
#     { "id": 3, "listing_id": 2, "start_date": "2016-10-15", "end_date": "2016-10-20" }
#   ],
#   "reservations": [
#     { "id": 1, "listing_id": 1, "start_date": "2016-10-11", "end_date": "2016-10-13" },
#     { "id": 2, "listing_id": 1, "start_date": "2016-10-13", "end_date": "2016-10-15" },
#     { "id": 3, "listing_id": 1, "start_date": "2016-10-16", "end_date": "2016-10-20" },
#     { "id": 4, "listing_id": 2, "start_date": "2016-10-15", "end_date": "2016-10-18" }
#   ]
# }
