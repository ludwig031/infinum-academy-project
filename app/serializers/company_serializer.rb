class CompanySerializer < ActiveModel::Serializer
  attribute :id
  attribute :name
  has_many :flights
  attribute :no_of_active_flights

  def no_of_active_flights
    object.flights.where('flys_at > ?', Time.zone.now).all.count
  end
end
