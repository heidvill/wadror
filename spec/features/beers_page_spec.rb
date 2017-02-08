require 'rails_helper'

describe "Beer" do
  before :each do
    FactoryGirl.create :brewery
  end

  it "when filled with acceptable name, is added to the system" do
    visit new_beer_path
    fill_in('beer_name', with: 'Karhu')
    select('Lager', from: 'beer[style]')
    select('anonymous', from: 'beer[brewery_id]')

    expect {
      click_button "Create Beer"
    }.to change { Beer.count }.from(0).to(1)
  end

  it "when filled with wrong name, is not saved" do
    visit new_beer_path
    fill_in('beer_name', with: '')
    select('Lager', from: 'beer[style]')
    select('anonymous', from: 'beer[brewery_id]')

    click_button "Create Beer"

    expect(Beer.count).to eq(0)
    expect(page).to have_content 'Name is too short (minimum is 1 character)'
  end

end