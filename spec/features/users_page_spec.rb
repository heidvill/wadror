require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'Secret55')
    fill_in('user_password_confirmation', with: 'Secret55')

    expect {
      click_button('Create User')
    }.to change { User.count }.by(1)
  end
end

describe "User page" do
  let!(:user) { FactoryGirl.create :user }
  let!(:user2) { FactoryGirl.create :user2 }

  it "should not have any ratings before been created" do
    visit user_path(user)

    expect(page).to have_content %q[You don't have any ratings]
  end

  it "shows average and lists ratings correctly" do
    create_ratings(user, 5, 10)
    create_ratings(user2, 15)

    visit user_path(user)

    expect(page).to have_content 'has made 2 ratings, average 7.5'
    expect(page).to have_content 'anonymous: 5'
    expect(page).to have_content 'anonymous: 10'
    expect(page).not_to have_content 'anonymous: 15'
  end

  it "deletes user's rating from db" do
    create_ratings(user, 5, 10)
    sign_in(username: "Pekka", password: "Foobar1")

    visit user_path(user)

    page.find('li', :text => '10').click_link('delete')

    expect(page).to have_content 'has made 1 rating, average 5'
    expect(page).to have_content 'anonymous: 5'
    expect(page).not_to have_content 'anonymous: 10'
  end
end