require 'rails_helper'

describe "beerlist page" do

  before :all do
    WebMock.disable_net_connect!(allow_localhost:true)
  end

  before :each do

    @brewery1 = FactoryGirl.create(:brewery, name: "Koff")
    @brewery2 = FactoryGirl.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryGirl.create(:brewery, name: "Ayinger")
    @style1 = Style.create name: "Lager"
    @style2 = Style.create name: "Rauchbier"
    @style3 = Style.create name: "Weizen"
    @beer1 = FactoryGirl.create(:beer, name: "Nikolai", brewery: @brewery1, style: @style1)
    @beer2 = FactoryGirl.create(:beer, name: "Fastenbier", brewery: @brewery2, style: @style2)
    @beer3 = FactoryGirl.create(:beer, name: "Lechte Weisse", brewery: @brewery3, style: @style3)
  end

  it "shows one known beer", js: true do
    visit beerlist_path
    expect(page).to have_content "Nikolai"
  end

  it "shows beers alphabetically by default", js: true do
    visit beerlist_path

    expect(find('table').find('tr:nth-child(2)')).to have_content "Fastenbier"
    expect(find('table').find('tr:nth-child(3)')).to have_content "Lechte Weisse"
    expect(find('table').find('tr:nth-child(4)')).to have_content "Nikolai"
  end

  it "shows beers by style when clicked style" do
    visit beerlist_path
    click_link "Style"
    find('table').find('tr:nth-child(2)')

    expect(page).to have_content "Nikolai"
    expect(find('table').find('tr:nth-child(3)')).to have_content "Fastenbier"
    expect(find('table').find('tr:nth-child(4)')).to have_content "Lechte Weisse"

  end

  it "shows beers by brewery when clicked brewery" do
    visit beerlist_path
    click_link "Brewery"

    expect(find('table').find('tr:nth-child(2)')).to have_content "Lechte Weisse"
    expect(find('table').find('tr:nth-child(3)')).to have_content "Nikolai"
    expect(find('table').find('tr:nth-child(4)')).to have_content "Fastenbier"
  end
end