require 'faker'
puts "🌱 Seeding spices..."

# Seed your database here
# seeds.rb



# Generate users
10.times do
  User.create(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: Faker::Internet.password
  )
end

# Generate flights
# Generate flights
flight_destinations = [
  "Paris, France",
  "Rome, Italy",
  "Barcelona, Spain",
  "New York City, USA",
  "Tokyo, Japan",
  "London, England",
  "Sydney, Australia",
  "Rio de Janeiro, Brazil",
  "Cape Town, South Africa",
  "Bali, Indonesia"
].shuffle

10.times do |i|
  Flight.create(
    flight_number: Faker::Alphanumeric.alpha(number: 6).upcase,
    departure_airpot: Faker::Address.city,
    arrival_airport: Faker::Address.city,
    arrival_country: flight_destinations[i % flight_destinations.length],
    departure_time: Faker::Time.forward(days: 30, period: :evening),
    price: Faker::Number.decimal(l_digits: 4, r_digits: 2)
  )
end

# Generate hotels
hotel_locations = [
  "Paris, France",
  "New York City, USA",
  "Tokyo, Japan",
  "London, UK",
  "Rome, Italy",
  "Barcelona, Spain",
  "Dubai, UAE",
  "Sydney, Australia",
  "Rio de Janeiro, Brazil",
  "Cape Town, South Africa",
  "Bangkok, Thailand",
  "Amsterdam, Netherlands",
  "Istanbul, Turkey",
  "Los Angeles, USA",
  "Las Vegas, USA",
  "San Francisco, USA",
  "Berlin, Germany",
  "Prague, Czech Republic",
  "Moscow, Russia",
  "Toronto, Canada"
].shuffle

10.times do |i|
  Hotel.create(
    name: Faker::Company.name,
    location: hotel_locations[i % hotel_locations.length],
    address: Faker::Address.full_address,
    country: Faker::Address.country,
    star_rating: Faker::Number.between(from: 1, to: 5),
    price: Faker::Number.decimal(l_digits: 4, r_digits: 2)
  )
end

# Generate bookings
users = User.all
flights = Flight.all
hotels = Hotel.all

10.times do
  Booking.create(
    user: users.sample,
    flight: flights.sample,
    hotel: hotels.sample,
    status: ['Pending', 'Confirmed', 'Cancelled'].sample,
    check_in_date: Faker::Date.forward(days: 7),
    check_out_date: Faker::Date.forward(days: 14)
  )
end
Flight.all.each do |flight|
  flight.fetch_flight_image
end

Hotel.all.each do |hotel|
  hotel.fetch_hotel_image
end


puts "✅ Done seeding!"
