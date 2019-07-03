class AvailabilityValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    # bookings = take all the bookings for this appartement/listing
    bookings = Booking.where(["listing_id =?", record.listing_id])
    current_booking = record.start_date..record.end_date

    if record.id.nil?
      bookings_date_ranges = bookings.map { |b| b.start_date..b.end_date }
    else
      bookings_date_ranges = bookings.map { |b| b.id != record.id ? b.start_date..b.end_date : nil }
      bookings_date_ranges.compact!
    end

    # intersection case
    bookings_date_ranges.each do |range|
      if record.start_date.between?(range.first, range.last) || record.end_date.between?(range.first, range.last)
        record.errors.add(attribute, "Booking already exists for this start_date/end_date")
      end
    end

    # inclusion case
    bookings_date_ranges.each do |range|
      if current_booking.include? range
        record.errors.add(attribute, "Booking already exists for the same period")
      end
    end
  end
end

