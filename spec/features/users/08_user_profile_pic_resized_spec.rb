require "rails_helper"

feature "profile photo resizing" do
  scenario "user uploads a large profile photo", js: true do
    visit root_path
    click_link "Sign Up"

    fill_in 'First Name', with: 'firstname'
    fill_in 'Last Name', with: 'lastname'
    fill_in "Email", with: "ash@s-mart.com"
    fill_in "Password", with: "boomstick!3vilisd3ad"
    fill_in "Password Confirmation", with: "boomstick!3vilisd3ad"
    attach_file 'user[profile_photo]',
      "#{Rails.root}/spec/support/images/photo.png"
    click_button "Sign Up"

    expect(page).to have_content("Welcome to the club!")
    img_height = page.evaluate_script("$('nav ul.right img')[0].clientHeight")
    img_width = page.evaluate_script("$('nav ul.right img')[0].clientWidth")

    expect(img_height).to eq(100)
    expect(img_width).to eq(100)
  end
end
