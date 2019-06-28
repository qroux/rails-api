class ReservabilityValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    # take all the bookings for a given Listing/appartement
    bookings = Booking.where(["listing_id =?", record.listing_id])
    bookings_date_ranges = bookings.map { |b| b.start_date..b.end_date }

    # take all the existing reservations for this Listing/appartement
    reservations = Reservation.where(["listing_id =?", record.listing_id])
    current_reservation = (record.start_date..record.end_date)

    # record.id.nil? check if it's on create or on update to ignore the current reservation in reservability
    if record.id.nil?
      reservations_date_ranges = reservations.map { |r| r.start_date..r.end_date }
    else
      reservations_date_ranges = reservations.map { |r| r.id != record.id ? r.start_date..r.end_date : nil }
      reservations_date_ranges.compact!
    end

    # 2 conditions to create a reservation:
    # current reservation range must be included in the booking range
    bookings_date_ranges.each do |range|
      unless record.start_date.between?(range.first, range.last)
        record.errors.add(attribute, "booking not available for this start_date")
      end
      unless record.end_date.between?(range.first, range.last)
        record.errors.add(attribute, "booking not available for this end_date")
      end
    end

    # there is no previous reservation for the same range
    # interscetion case
    reservations_date_ranges.each do |range|
      if record.start_date.between?(range.first, range.last)
        record.errors.add(attribute, "already reserved for this start_date")
      end
      if record.end_date.between?(range.first, range.last)
        record.errors.add(attribute, "already reserved for this end_date")
      end
    end

    # inclusion case
    reservations_date_ranges.each do |range|
      if current_reservation.include? range
        record.errors.add(attribute, "a reservation already exist within this range")
      end
    end
  end
end
