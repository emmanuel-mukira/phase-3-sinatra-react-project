class Flight < ActiveRecord::Base
  has_many :bookings

  def fetch_flight_image
    api_key = ENV['UNSPLASH_API_KEY']
    url = "https://api.unsplash.com/search/photos?query=#{CGI.escape(arrival_country)}&per_page=1&client_id=#{api_key}"
    image_url = fetch_image_url(url)
    update(image_url: image_url) if image_url
  end

  private

  def fetch_image_url(url)
    response = Net::HTTP.get_response(URI(url))
    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      return data['results'][0]['urls']['regular'] if data['results'].any?
    end
    nil
  end
end
