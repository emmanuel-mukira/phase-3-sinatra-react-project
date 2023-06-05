class CreateBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :bookings do |t|
      t.integer :user_id
      t.integer :flight_id
      t.integer :hotel_id
      t.string :status
      t.date :check_in_date
      t.date :check_out_date
    end
  end
end
