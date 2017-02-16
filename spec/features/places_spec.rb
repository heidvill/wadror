require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
        [Place.new(name: "Oljenkorsi", id: 1)]
    )
    allow(WeatherApi).to receive(:weather_in).with("kumpula").and_return(
        Weather.new(temp_c:1, condition:{"icon"=>"//cdn.apixu.com/weather/64x64/day/116.png"}, wind_kph: 2, wind_dir: "S")
    )

    visit places_path

    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if several are returned by the API, they are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("arabia").and_return(
        [Place.new(name: "Baari1", id: 1),
         Place.new(name: "Kuppila2", id: 2)]
    )
    allow(WeatherApi).to receive(:weather_in).with("arabia").and_return(
        Weather.new(temp_c:1, condition:{"icon"=>"//cdn.apixu.com/weather/64x64/day/116.png"}, wind_kph: 2, wind_dir: "S")
    )

    visit places_path

    fill_in('city', with: 'arabia')
    click_button "Search"

    expect(page).to have_content "Baari1"
    expect(page).to have_content "Kuppila2"
  end

  it "if not found, no place is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("vallila").and_return([])
    allow(WeatherApi).to receive(:weather_in).with("vallila").and_return(
        Weather.new(temp_c:1, condition:{"icon"=>"//cdn.apixu.com/weather/64x64/day/116.png"}, wind_kph: 2, wind_dir: "S")
    )

    visit places_path

    fill_in('city', with: 'vallila')
    click_button "Search"

    expect(page).to have_content "No locations in searched city"
  end
end