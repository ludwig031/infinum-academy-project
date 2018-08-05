class Flight < ApplicationRecord
  belongs_to :company
  has_many :bookings, dependent: :destroy

  scope :by_company, lambda { |query|
    joins(:company)
      .where('flys_at > ? AND company.id IN (?)', Time.zone.now, query)
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

  def not_overlaps
    return if company_id.nil?
    if Flight.where('id <> ? AND company_id = ? AND
                     (flys_at, lands_at) OVERLAPS (?, ?)',
                    id || 0, company_id, flys_at, lands_at).count.positive?
      errors.add(:base, 'Selected flight overlaps with another flight')
    end
  end

  def current_price
    difference = 15 - (flys_at.to_date - Date.current)
    difference = difference.negative? ? 0 : difference
    difference = difference > 15 ? 15 : difference
    (base_price * (1 + difference / 15)).round
  end
end
