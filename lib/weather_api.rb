class WeatherApi
  def self.weather_in(city)
    url = "http://api.apixu.com/v1/current.xml?key=#{key}&q=#{ERB::Util.url_encode(city)}"
    response = HTTParty.get "#{url}"
    data = response.parsed_response["root"]["current"]

    Weather.new(data)
  end

  def self.key
    raise "WEATHERKEY env variable not defined" if ENV['WEATHERKEY'].nil?
    ENV['WEATHERKEY']
  end
end