class Company < ApplicationRecord
  has_many :flights, dependent: :destroy

  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false }

  def self.active_flights
    joins(:flights).group(:id).where('flys_at > ?', Time.zone.now).all
  end
end
