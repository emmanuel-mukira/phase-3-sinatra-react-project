class CreateHotels < ActiveRecord::Migration[6.1]
  def change
    create_table :hotels do |t|
      t.string :name
      t.string :location
      t.text :amenities
      t.decimal :price
      t.string :image_url 
    end
  end
end
