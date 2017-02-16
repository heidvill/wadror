class Weather < OpenStruct
  def self.rendered_fields
    [:temp_c, :condition, :wind_kph, :wind_dir]
  end

  def wind
    wind_kph.to_f/3.6
  end

  def temp
    temp_c.to_f
  end

  def icon
    condition["icon"]
  end
end