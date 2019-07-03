class Reservation < ApplicationRecord
  belongs_to :listing

  validate :end_date_after_start_date

  # with validates_overlap gem
  validates :start_date, :end_date, presence: true, overlap: { scope: "listing_id", exclude_edges: ["start_date", "end_date"] }

  # with custom validator
  # validates :start_date, :end_date, presence: true, reservability: true

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date <= start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
