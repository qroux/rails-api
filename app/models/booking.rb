class Booking < ApplicationRecord
  belongs_to :listing
  after_create :initial_missions
  after_update :update_missions
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

    if end_date <= start_date
      errors.add(:end_date, 'must be after the start_date')
    end
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
      mission_type: 'checkout_checkin',
      price: (10 * listing.num_rooms),
      date: end_date
    )
  end

  def update_missions
    # need to keep track of end and start date in other booking columns to make sql request
    # since self.start/end_date are modified and wont match any results
    first_checkin = Mission.where(
      date: previous_start_date,
      listing_id: listing.id,
      mission_type: 'first_checkin'
    ).first
    checkout_checkin = Mission.where(
      date: previous_end_date,
      listing_id: listing.id,
      mission_type: 'checkout_checkin'
    ).first

    # set date == previous_start/end_date after performing sql request for future update
    if start_date != first_checkin.date
      first_checkin.update(date: start_date)
      self.update(previous_start_date: start_date)
    end
    if end_date != checkout_checkin.date
      checkout_checkin.update(date: end_date)
      self.update(previous_end_date: end_date)
    end
  end

  def remove_missions
    Mission.where(
      date: start_date,
      listing_id: listing.id,
      mission_type: 'first_checkin'
    ).destroy_all
    Mission.where(
      date: end_date,
      listing_id: listing.id,
      mission_type: 'checkout_checkin'
    ).destroy_all
  end
end
