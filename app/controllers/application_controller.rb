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
  
    puts "User ID: #{user_id}"
  
    bookings = Booking.joins(:flight, :hotel).where(user_id: user_id)
  
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
  
    puts "Bookings Data: #{bookings_data}"
  
    bookings_data.to_json
  end
  
  post '/bookings' do
    puts "Request Payload: #{params}"
  
    # Check if the user is authenticated and retrieve the currently logged-in user
    user_id = params[:user_id].to_i
    flight_number = params[:flight_number]
    hotel_name = params[:hotel_name]
  
    # Find the flight and hotel records based on the flight number and hotel name
    flight = Flight.find_by(flight_number: flight_number)
    hotel = Hotel.find_by(name: hotel_name)
  
    if flight && hotel
      # Create the booking record
      booking = Booking.new(
        user_id: user_id,
        flight_id: flight.id,
        hotel_id: hotel.id,
        status: params["status"],
        check_in_date: params["check_in_date"],
        check_out_date: params["check_out_date"]
      )
  
      if booking.valid?
        user = User.find_by(id: user_id)
        if user
          booking.save
          puts "Booking created successfully: #{booking.to_json}"
          status 201
          booking.to_json
        else
          puts 'Unauthorized'
          status 401
          { error: 'Unauthorized' }.to_json
        end
      else
        puts "Failed to create booking: #{booking.errors}"
        status 400
        { error: 'Failed to create booking' }.to_json
      end
    else
      puts 'Flight or hotel not found'
      status 404
      { error: 'Flight or hotel not found' }.to_json
    end
  end
  
  
  
  
  
  
  
  delete '/bookings/:id' do
    booking = Booking.find_by(id: params[:id])
  
    if booking
      booking.destroy
      status 204 # No content
    else
      status 404 # Not found
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
      session[:user_id] = user.id # Set the user ID in the session
      puts "#{session[:user_id]}"
      status 200
      { user_id: user.id, name: user.name }.to_json
    else
      status 401
      { error: 'Invalid credentials' }.to_json
    end
  end
  


end
