class Place < OpenStruct
  def self.rendered_fields
    [:id, :name, :status, :street, :city, :zip, :country, :overall]
  end

  def map
    var_street = ERB::Util.url_encode(street)
    var_city = ERB::Util.url_encode(city)
    "https://www.google.com/maps/embed/v1/place?q=#{var_street}%20#{zip}%20#{var_city}&key=#{google_key}"
  end

  private
  def google_key
    raise "GOOGLEKEY env variable not defined" if ENV['GOOGLEKEY'].nil?
    ENV['GOOGLEKEY']
  end
end