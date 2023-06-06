class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'
  
  # Add your routes here
  get "/" do
    { message: "Good luck with your project!" }.to_json
  end

  get '/flights' do
    flights = Flight.all
    flights.to_json
  end

  post '/flights' do
    flight = Flight.new(params)
    if flight.save
      status 201
      flight.to_json
    else
      status 400
      { error: 'Failed to create flight' }.to_json
    end
  end

  delete '/flights/:id' do
    flight = Flight.find(params[:id])
    if flight.destroy
      status 204
    else
      status 400
      { error: 'Failed to delete flight' }.to_json
    end
  end

  get '/hotels' do
    hotels = Hotel.all
    hotels.to_json
  end

  post '/flights' do
    flight = Flight.create(
      flight_number: params[:flight_number],
      departure_airport: params[:departure_airport],
      arrival_airport: params[:arrival_airport],
      arrival_country: params[:arrival_country],
      departure_time: params[:departure_time],
      price: params[:price],
      image_url: params[:image_url]
    )
  
    if flight.valid?
      status 201
      flight.to_json
    else
      status 400
      { error: 'Failed to create flight' }.to_json
    end
  end

  post '/hotels' do
    hotel = Hotel.create(
      name: params[:name],
      location: params[:location],
      address: params[:address],
      country: params[:country],
      star_rating: params[:star_rating],
      price: params[:price],
      image_url: params[:image_url]
    )
  
    if hotel.valid?
      status 201
      hotel.to_json
    else
      status 400
      { error: 'Failed to create hotel' }.to_json
    end
  end

  delete '/hotels/:id' do
    hotel = Hotel.find(params[:id])
    if hotel.destroy
      status 204
    else
      status 400
      { error: 'Failed to delete hotel' }.to_json
    end
  end

  post '/bookings' do
    # Retrieve the currently logged-in user ID
    user_id = current_user.id
  
    # Extract the selected flight and hotel IDs from the request parameters
    flight_id = params[:flight_id]
    hotel_id = params[:hotel_id]
  
    # Create the booking record
    booking = Booking.create(
      user_id: user_id,
      flight_id: flight_id,
      hotel_id: hotel_id,
      status: params[:status],
      check_in_date: params[:check_in_date],
      check_out_date: params[:check_out_date]
    )
  
    if booking.valid?
      status 201
      booking.to_json
    else
      status 400
      { error: 'Failed to create booking' }.to_json
    end
  end
  delete '/bookings/:id' do
    # Find the booking by ID
    booking = Booking.find(params[:id])
  
    if booking
      # Delete the booking
      booking.destroy
      booking.to_json
      status 204
    else
      status 404
      { error: 'Booking not found' }.to_json
    end
  end


end
