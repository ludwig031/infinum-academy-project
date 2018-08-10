class CompanyStatisticsSerializer < ActiveModel::Serializer
  attribute :company_id
  attribute :total_revenue
  attribute :total_no_of_booked_seats
  attribute :average_price_of_seats

  def average_price_of_seats
    return 0 if object.total_no_of_booked_seats.zero?
    object.total_revenue.to_f / object.total_no_of_booked_seats
  end
end
