require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "with a proper name and style is saved" do
    beer = Beer.create name: "Koff", style: "Lager"

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved without a name" do
    beer = Beer.create name: "", style: "Lager"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
    beer = Beer.create name: "Koff", style: ""

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

end
