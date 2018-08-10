class Company < ApplicationRecord
  has_many :flights, dependent: :destroy

  scope :active_flights,
        -> { joins(:flights).group(:id).where('flys_at > ?', Time.zone.now) }

  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false }
end
