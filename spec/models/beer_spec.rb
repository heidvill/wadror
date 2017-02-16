require 'rails_helper'

include Helpers

RSpec.describe Beer, type: :model do
  it "with a proper name is saved" do
    beer = Beer.create name: "Karhu"

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved without a name" do
    beer = Beer.create name: ""

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
