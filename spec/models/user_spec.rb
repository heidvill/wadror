require 'rails_helper'

include Helpers

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    # user.username.should == "Pekka"
    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    # expect(user.valid?).to be(false)
    # expect(User.count).to eq(0)
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with too short password" do
    user = User.create username: "pekka", password: "Se1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with password with only small letters" do
    user = User.create username: "pekka", password: "abcde"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) { FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user) { FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      best = create_beer_with_rating(user, 10)

      expect(user.favorite_beer).to eq(best)
    end

    it "is the one with highest rating if several rated" do
      create_ratings(user, 10, 20, 15, 7, 9)
      best = create_beer_with_rating(user, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:brewery) { FactoryGirl.create(:brewery, name: "Koff", year: 1500) }
    let!(:style) {FactoryGirl.create(:style2)}
    let(:beer) { FactoryGirl.create(:beer2, style: style, brewery: brewery) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      create_beer_with_rating(user, 10)

      expect(user.favorite_style).to eq("Lager")
    end

    it "is the one with highest rating average if several rated" do
      create_ratings(user, 10, 5) # lager ka = (10 + 5) / 2 = 7.5

      FactoryGirl.create(:rating, score: 10, beer: beer, user: user) # Ipa ka = 10

      expect(user.favorite_style).to eq("Ipa")

    end
  end

  describe "favorite brewery" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:brewery) { FactoryGirl.create(:brewery, name: "Koff", year: 1500) }
    let(:beer) { FactoryGirl.create(:beer2, brewery: brewery) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated if only one rating" do
      create_beer_with_rating(user, 10)

      expect(user.favorite_brewery).to eq("anonymous")
    end

    it "is the one with highest rating average if several rated" do
      create_ratings(user, 10, 5) # anonymous ka = (10 + 5) / 2 = 7.5

      FactoryGirl.create(:rating, score: 10, beer: beer, user: user) # Koff ka = 10

      expect(user.favorite_brewery).to eq("Koff")
    end
  end
end
