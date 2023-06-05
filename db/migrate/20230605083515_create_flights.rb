class CreateFlights < ActiveRecord::Migration[6.1]
  def change
    create_table :flights do |t|
     t.string :flight_number 
     t.string :departure_airpot 
     t.string :arrival_airport 
     t.datetime :departure_time
     t.decimal :price
     t.string :image_url
    end
  end
end
