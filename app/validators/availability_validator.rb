class AvailabilityValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    bookings = Booking.where(["listing_id =?", record.listing_id])

    if record.id.nil?
      date_ranges = bookings.map { |b| b.start_date..b.end_date }
    else
      date_ranges = bookings.map { |b|  b.id != record.id ? b.start_date..b.end_date : nil }
      date_ranges.compact!
    end

    date_ranges.each do |range|
      if range.include? value
        record.errors.add(attribute, "not available")
      end
    end
  end
end

# bookings = take all the bookings for this appartement/listing
# on create: the booking doesn't exist yet, so record.id == nil
#       date_ranges = array with all the ranges
#       if the new booking range is included in the already existing range = error: not available
# on update: the booking already exist, so record.id != nil
#       date_ranges = array with all the ranges, EXCEPT THE CURRENT ONE, in order to modify it
