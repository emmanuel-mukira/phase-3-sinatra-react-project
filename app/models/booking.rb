class Booking < ActiveRecord::Base
    belongs_to :user
    belongs_to :flight
    belongs_to :hotel
end