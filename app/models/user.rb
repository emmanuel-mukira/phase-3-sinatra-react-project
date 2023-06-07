class User < ActiveRecord::Base
    has_many :bookings
  
    def self.authenticate(email, password)
      user = find_by(email: email)
    
      if user && user.password == password
        user
      else
        nil
      end
    end
  end
  