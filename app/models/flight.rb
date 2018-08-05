class Flight < ApplicationRecord
  belongs_to :company
  has_many :bookings, dependent: :destroy

  scope :by_company, lambda { |query|
    where('flys_at > ? AND company.id IN ?', Time.zone.now, query)
  }

  scope :active, -> { where('flys_at > ?', Time.zone.now) }

  scope :ordered, -> { order(:flys_at, :name, :created_at) }

  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false, scope: :company_id }
  validates :flys_at, presence: true
  validates :lands_at, presence: true
  validates :base_price,
            presence: true,
            numericality: { greater_than: 0 }
  validates :no_of_seats,
            presence: true,
            numericality: { greater_than: 0 }
  validate :flys_at_before_lands_at
  validate :not_overlaps

  def flys_at_before_lands_at
    return if flys_at && lands_at && (flys_at < lands_at)
    errors.add(:lands_at, 'take off time can not be after landing time')
  end

  def overlapping_flight
    Flight.where("company_id = ? AND (flys_at, lands_at)
                  OVERLAPS (?, ?)",
                 company_id, flys_at, lands_at)
  end

  def not_overlaps
    overlapping_flight if overlapping_flight.exists?
  end
end
