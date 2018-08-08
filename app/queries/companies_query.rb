class CompaniesQuery
  attr_reader :relation

  def initialize(relation: Company.all)
    @relation = relation
  end

  def with_stats
    relation.joins(flights: :bookings)
            .group('companies.id')
            .select('companies.*, companies.id AS company_id')
            .select('coalesce(sum(bookings.no_of_seats *
                          bookings.seat_price),0) AS total_revenue')
            .select('coalesce(sum(bookings.no_of_seats),0)
                          AS total_no_of_booked_seats')
            .order('company_id')
  end
end
