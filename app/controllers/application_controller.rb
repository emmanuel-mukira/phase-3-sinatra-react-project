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
  get '/flights/:id' do
    flight = Flight.find(params[:id])
    flight.to_json
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

  get '/hotels/:id' do
    hotel = Hotel.find(params[:id])
    hotel.to_json
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

  get '/bookings' do
    user_id = params[:user_id]
  
    # Perform the database query to fetch the bookings for the specified user_id
    # Replace `your-query` with the actual query to retrieve bookings for a specific user
    bookings = Booking.includes(flight: :bookings, hotel: :bookings).where(user_id: user_id).all
  
    bookings_data = bookings.map do |booking|
      {
        id: booking.id,
        flight_name: booking.flight&.flight_number,
        hotel_name: booking.hotel&.name,
        status: booking.status,
        check_in_date: booking.check_in_date,
        check_out_date: booking.check_out_date
      }
    end
  
    bookings_data.to_json
  end
  
  
  

  post '/bookings' do
    # Check if the user is authenticated and retrieve the currently logged-in user
    user = User.find_by(id: session[:user_id])
  
    if user
      # User is authenticated, proceed with creating the booking
  
      # Retrieve the selected flight and hotel IDs from the request parameters
      flight_id = params[:flight_id]
      hotel_id = params[:hotel_id]
  
      # Create the booking record
      booking = Booking.new(
        user_id: user.id,
        flight_id: flight_id,
        hotel_id: hotel_id,
        status: params[:status],
        check_in_date: params[:check_in_date],
        check_out_date: params[:check_out_date]
      )
  
      if booking.save
        status 201
        booking.to_json
      else
        status 400
        { error: 'Failed to create booking' }.to_json
      end
    else
      # User is not authenticated, return an error response
      status 401
      { error: 'Unauthorized' }.to_json
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

  post '/signUp' do
    user = User.create(
      name: params[:name],
      email: params[:email],
      password: params[:password]
    )
  
    if user.valid?
      status 201
      user.to_json
    else
      status 400
      { error: 'Failed to create user' }.to_json
    end
  end

  post '/signIn' do
    user = User.authenticate(params[:email], params[:password])
    
    if user
      { user_id: user.id, name: user.name }.to_json
    else
      status 401
      { error: 'Invalid credentials' }.to_json
    end
  end
  


end
