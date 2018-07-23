ActiveAdmin.register Booking do
  permit_params :flight_id,
                :user_id,
                :no_of_seats,
                :seat_price
end
