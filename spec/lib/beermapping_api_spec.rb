require 'rails_helper'

describe "BeermappingApi" do
  describe "in case of cache miss" do

    before :each do
      Rails.cache.clear
    end

    it "When HTTP GET returns one entry, it is parsed and returned" do

      canned_answer = <<-END_OF_STRING
      <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>12411</id><name>Gallows Bird</name><status>Brewery</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=12411</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12411&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12411&amp;d=1&amp;type=norm</blogmap><street>Merituulentie 30</street><city>Espoo</city><state></state><zip>02200</zip><country>Finland</country><phone>+358 9 412 3253</phone><overall>91.66665</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*espoo/).to_return(body: canned_answer, headers: {'Content-Type' => "text/xml"})

      places = BeermappingApi.places_in("espoo")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Gallows Bird")
      expect(place.street).to eq("Merituulentie 30")
    end

    it "when HTTP GET returns zero entry, returns empty array" do
      canned_answer = <<-END_OF_STRING
     <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id/><name/><status/><reviewlink/><proxylink/><blogmap/><street/><city/><state/><zip/><country/><phone/><overall/><imagecount/></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*kouvola/).to_return(body: canned_answer, headers: {'Content-Type' => "text/xml"})
      places = BeermappingApi.places_in("kouvola")

      expect(places.size).to eq(0)
    end

    it "when HTTP GET returns several entries, they are parsed and returned" do
      canned_answer = <<-END_OF_STRING
        <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>6742</id><name>Pullman Bar</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/6742</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=6742&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=6742&amp;d=1&amp;type=norm</blogmap><street>Kaivokatu 1</street><city>Helsinki</city><state></state><zip>00100</zip><country>Finland</country><phone>+358 9 0307 22</phone><overall>72.500025</overall><imagecount>0</imagecount></location><location><id>6743</id><name>Belge</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/6743</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=6743&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=6743&amp;d=1&amp;type=norm</blogmap><street>Kluuvikatu 5</street><city>Helsinki</city><state></state><zip>00100</zip><country>Finland</country><phone>+358 10 766 35</phone><overall>67.499925</overall><imagecount>1</imagecount></location><location><id>6919</id><name>Suomenlinnan Panimo</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/6919</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=6919&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=6919&amp;d=1&amp;type=norm</blogmap><street>Rantakasarmi</street><city>Helsinki</city><state></state><zip>00190</zip><country>Finland</country><phone>+358 9 228 5030</phone><overall>69.166625</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*helsinki/).to_return(body: canned_answer, headers: {'Content-Type' => "text/xml"})

      places = BeermappingApi.places_in("helsinki")

      expect(places.size).to eq(3)
      place = places.first
      expect(place.name).to eq("Pullman Bar")
      expect(place.street).to eq("Kaivokatu 1")

      place = places[1]
      expect(place.name).to eq("Belge")
      expect(place.street).to eq("Kluuvikatu 5")

      place = places[2]
      expect(place.name).to eq("Suomenlinnan Panimo")
      expect(place.street).to eq("Rantakasarmi")
    end
  end

  describe "in case of cache hit" do
    it "When one entry in cache, it is returned" do
      canned_answer = <<-END_OF_STRING
        <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>13307</id><name>O'Connell's Irish Bar</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=13307</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=13307&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=13307&amp;d=1&amp;type=norm</blogmap><street>Rautatienkatu 24</street><city>Tampere</city><state></state><zip>33100</zip><country>Finland</country><phone>35832227032</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*espoo/).to_return(body: canned_answer, headers: {'Content-Type' => "text/xml"})

      # ensure that data found in cache
      BeermappingApi.places_in("espoo")

      places = BeermappingApi.places_in("espoo")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("O'Connell's Irish Bar")
      expect(place.street).to eq("Rautatienkatu 24")
    end

    it "when several entries in cache, they are returned" do
      canned_answer = <<-END_OF_STRING
        <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>6742</id><name>Pullman Bar</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/6742</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=6742&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=6742&amp;d=1&amp;type=norm</blogmap><street>Kaivokatu 1</street><city>Helsinki</city><state></state><zip>00100</zip><country>Finland</country><phone>+358 9 0307 22</phone><overall>72.500025</overall><imagecount>0</imagecount></location><location><id>6743</id><name>Belge</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/6743</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=6743&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=6743&amp;d=1&amp;type=norm</blogmap><street>Kluuvikatu 5</street><city>Helsinki</city><state></state><zip>00100</zip><country>Finland</country><phone>+358 10 766 35</phone><overall>67.499925</overall><imagecount>1</imagecount></location><location><id>6919</id><name>Suomenlinnan Panimo</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/6919</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=6919&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=6919&amp;d=1&amp;type=norm</blogmap><street>Rantakasarmi</street><city>Helsinki</city><state></state><zip>00190</zip><country>Finland</country><phone>+358 9 228 5030</phone><overall>69.166625</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*helsinki/).to_return(body: canned_answer, headers: {'Content-Type' => "text/xml"})

      BeermappingApi.places_in("helsinki")
      places = BeermappingApi.places_in("helsinki")

      expect(places.size).to eq(3)
      place = places.first
      expect(place.name).to eq("Pullman Bar")
      expect(place.street).to eq("Kaivokatu 1")

      place = places[1]
      expect(place.name).to eq("Belge")
      expect(place.street).to eq("Kluuvikatu 5")

      place = places[2]
      expect(place.name).to eq("Suomenlinnan Panimo")
      expect(place.street).to eq("Rantakasarmi")
    end
  end

end