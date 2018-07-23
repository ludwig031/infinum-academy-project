class CreateBookings < ActiveRecord::Migration[5.2]
  def change
    create_table :bookings do |t|
      t.integer :no_of_seats
      t.integer :seat_price
      t.references :user, index: true, foreign_key: true
      t.references :flight, index: true, foreign_key: true
    end
  end
end
