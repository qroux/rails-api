class Reservation < ApplicationRecord
  belongs_to :listing
  after_create :new_mission
  before_update :update_mission
  before_destroy :remove_mission

  validate :end_date_after_start_date

  # with validates_overlap gem
  validates :start_date, :end_date,
            presence: true,
            overlap: {
              scope: 'listing_id',
              exclude_edges: ['start_date', 'end_date']
            }
  # with custom validator (include_edges)
  # validates :start_date, :end_date, presence: true, reservability: true

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    errors.add(:end_date, 'must be after the start_date') if end_date <= start_date
  end

  def new_mission
    # does last_checkout already exist for self.end_date?
    last_checkout = Mission.find_by(
      date: end_date,
      listing_id: listing.id,
      mission_type: 'last_checkout'
    )

    # if last_checkout doesn't exist, then create a new checkout_checkin mission
    if last_checkout.nil?
      Mission.create!(
        listing_id: listing.id,
        mission_type: 'checkout_checkin',
        price: (5 * listing.num_rooms),
        date: end_date
      )
    end
  end

  def update_mission
    # sql request to find mission.date == Reservation.start/end_date before update
    my_reservation = Reservation.find_by(id: id)

    checkout_checkin = Mission.find_by(
      date: my_reservation.end_date,
      listing_id: listing.id,
      mission_type: 'checkout_checkin'
    )

    # if booking exists,it provides booking.end_date and implies an
    # already existing last_checkout for this date
    booking = Booking.find_by(
      end_date: end_date,
      listing_id: listing.id
    )

    # last_checkout overlap case
    if !checkout_checkin.nil? && !booking.nil?
      checkout_checkin.destroy
    end
    # update
    if !checkout_checkin.nil? && booking.nil?
      checkout_checkin.update(date: end_date)
    end
    # create
    if checkout_checkin.nil? && booking.nil?
      Mission.create!(
        listing_id: listing.id,
        mission_type: 'checkout_checkin',
        price: (5 * listing.num_rooms),
        date: end_date
      )
    end
  end

  def remove_mission
    reservation_mission = Mission.find_by(
      date: end_date,
      listing_id: listing.id,
      mission_type: 'checkout_checkin'
    )

    # unless the case where reservation.create doesn't create a checkout_checkin
    unless reservation_mission.nil?
      reservation_mission.destroy
    end
  end
end
