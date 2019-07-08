class Booking < ApplicationRecord
  belongs_to :listing
  after_create :initial_missions
  before_update :update_missions
  before_destroy :remove_missions

  validate :end_date_after_start_date

  # with validates_overlap gem
  validates :start_date, :end_date,
            presence: true,
            overlap: {
              scope: 'listing_id',
              exclude_edges: ['start_date', 'end_date']
            }
  # with custom validator
  # validates :start_date, :end_date, presence: true, availability: true

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    errors.add(:end_date, 'must be after the start_date') if end_date <= start_date
  end

  def initial_missions
    Mission.create!(
      listing_id: listing_id,
      mission_type: 'first_checkin',
      price: (10 * listing.num_rooms),
      date: start_date
    )
    Mission.create!(
      listing_id: listing_id,
      mission_type: 'last_checkout',
      price: (10 * listing.num_rooms),
      date: end_date
    )
  end

  def update_missions
    # sql request to find mission.date == Booking.start/end_date before update
    my_booking = Booking.find_by(id: id)

    first_checkin = Mission.find_by(
      date: my_booking.start_date,
      listing_id: listing.id,
      mission_type: 'first_checkin'
    )
    last_checkout = Mission.find_by(
      date: my_booking.end_date,
      listing_id: listing.id,
      mission_type: 'last_checkout'
    )

    # actual update with self.start/end_date
    first_checkin.update(date: start_date)
    last_checkout.update(date: end_date)
  end

  def remove_missions
    # remove first_checkin
    Mission.where(
      date: start_date,
      listing_id: listing.id,
      mission_type: 'first_checkin'
    ).destroy_all

    # remove last_checkout
    Mission.where(
      date: end_date,
      listing_id: listing.id,
      mission_type: 'last_checkout'
    ).destroy_all
  end
end
