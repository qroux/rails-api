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
      if record.start_date.between?(range.first, range.last)
        record.errors.add(attribute, "Booking already exists for this start_date")
      end
      if record.end_date.between?(range.first, range.last)
        record.errors.add(attribute, "Booking already exists for this end_date")
      end
    end

    # inclusion case
    bookings_date_ranges.each do |range|
      if current_booking.include? range
        record.errors.add(attribute, "not available")
      end
    end
  end
end

    # on create: the booking doesn't exist yet, so record.id == nil
    #       date_ranges = array with all the ranges
    #       if the new booking range is included in the already existing range = error: not available
    # on update: the booking already exist, so record.id != nil
    #       date_ranges = array with all the ranges, EXCEPT THE CURRENT ONE, in order to modify it


    # other syntax but doesn't work when current_booking range > existing_booking range
    # (current not included because greater range == include? => false)
    # in that case, must find a method that also check intersection rather than just inclusion
    #
    #
    # date_ranges.each do |range|
    #   if range.include? value
    #     record.errors.add(attribute, "not available")
    #   end
    # end
