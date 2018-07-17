class User < ApplicationRecord
  has_many :bookings, dependent: :destroy
  has_many :flights, through: :bookings

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates :first_name,
            presence: true,
            length: { minimum: 2 }
end