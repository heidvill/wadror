require 'rails_helper'

include Helpers

describe "Beer" do
  let!(:user) { FactoryGirl.create :user }

  before :each do
    FactoryGirl.create :brewery
    FactoryGirl.create :style
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "when filled with acceptable name, is added to the system" do
    visit new_beer_path
    fill_in('beer_name', with: 'Karhu')
    select('Lager', from: 'beer[style_id]')
    select('anonymous', from: 'beer[brewery_id]')

    expect {
      click_button "Create Beer"
    }.to change { Beer.count }.from(0).to(1)
  end

  it "when filled with wrong name, is not saved" do
    visit new_beer_path
    fill_in('beer_name', with: '')
    select('Lager', from: 'beer[style_id]')
    select('anonymous', from: 'beer[brewery_id]')

    click_button "Create Beer"

    expect(Beer.count).to eq(0)
    expect(page).to have_content 'Name is too short (minimum is 1 character)'
  end

end