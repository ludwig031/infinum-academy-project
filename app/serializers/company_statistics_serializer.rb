class CompanyStatisticsSerializer < ActiveModel::Serializer
  attribute :company_id
  attribute :total_revenue
  attribute :total_no_of_booked_seats
  attribute :average_price_of_seats

  def company_id
    object.id
  end

  def average_price_of_seats
    if object.total_no_of_booked_seats.zero?
      0
    else
      object.total_revenue.to_f / object.total_no_of_booked_seats.to_f
    end
  end
end
