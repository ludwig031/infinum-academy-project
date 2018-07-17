class Flight < ApplicationRecord
  belongs_to :company

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

  def flys_at_before_lands_at
    return if flys_at && lands_at && (flys_at < lands_at)
    errors.add(:end_date, 'take off time can not be after landing time')
  end
end