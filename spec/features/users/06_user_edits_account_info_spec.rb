require "rails_helper"

feature "edit account details" do

  let (:user) { FactoryGirl.create(:user) }

  scenario "user updates name" do
    user_sign_in(user)

    expect(page).to have_content("Logged In As: #{user.first_name}")

    click_link 'Profile Photo Here'
    fill_in 'First name', with: 'bob'
    fill_in 'Password', with: user.password
    click_button 'commit'

    expect(page).to have_content("Logged In As: bob")
  end
end
