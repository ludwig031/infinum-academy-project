class User < ApplicationRecord
  has_secure_password
  has_secure_token

  has_many :bookings, dependent: :destroy
  has_many :flights, through: :bookings

  scope :with_query, lambda { |query|
    where('UPPER(email) ILIKE :query OR
           UPPER(first_name) ILIKE :query OR
           UPPER(last_name) ILIKE :query',
          query: "%#{query}%")
  }

  validates :first_name,
            presence: true,
            length: { minimum: 2 }
  validates :last_name,
            presence: true,
            length: { minimum: 2 }
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates :password,
            presence: true,
            on: :create
end
