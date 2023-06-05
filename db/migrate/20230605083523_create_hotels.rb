class CreateHotels < ActiveRecord::Migration[6.1]
  def change
    create_table :hotels do |t|
      t.string :name
      t.string :location
      t.string :address 
      t.string :country
      t.integer :star_rating
      t.decimal :price
      t.string :image_url 
    end
  end
end
