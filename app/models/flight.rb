class Flight < ApplicationRecord
  belongs_to :company
  has_many :bookings, dependent: :destroy

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
  validate :total_booked_seats

  def flys_at_before_lands_at
    return if flys_at && lands_at && (flys_at < lands_at)
    errors.add(:lands_at, 'take off time can not be after landing time')
  end

  def total_booked_seats
    return if bookings.size > no_of_seats
    errors.add(:no_of_seats, 'no more available seats')
  end

  def self.active
    where('flys_at > ?', Time.zone.now)
      .order(:flys_at, :name, :created_at).all
  end

  def self.by_company(company_ids)
    ids = company_ids.split(',')
    joins(:flight).where('flys_at > ? AND company.id IN ?', Time.zone.now, ids)
                  .order(:flys_at, :name, :created_at).all
  end
end
