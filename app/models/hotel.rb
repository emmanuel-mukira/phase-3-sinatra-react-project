class Hotel < ActiveRecord::Base
    has_many :bookings
end
  