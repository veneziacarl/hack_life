require "rails_helper"

feature "profile photo" do
  scenario "user uploads a profile photo" do
    visit root_path
    click_link "Sign Up"

    fill_in 'First Name', with: 'firstname'
    fill_in 'Last Name', with: 'lastname'
    fill_in "Email", with: "ash@s-mart.com"
    fill_in "Password", with: "boomstick!3vilisd3ad"
    fill_in "Password Confirmation", with: "boomstick!3vilisd3ad"
    attach_file 'user[profile_photo]', "#{Rails.root}/spec/support/images/photo.png"
    click_button "Sign Up"

    expect(page).to have_content("Welcome to the club!")
    expect(page).to have_css("img[src*='photo.png']")
    save_and_open_page
  end
end
