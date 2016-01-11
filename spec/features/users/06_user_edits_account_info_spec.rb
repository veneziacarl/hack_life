require "rails_helper"

# Acceptance Criteria:
# [x] user can see current account details page
# [x] user can navigate to edit account page
# [x] user can update name
# [x] user can update email
# [ ] user can update profile picture
# [x] user can update password
# [x] user must enter current password for update to persist

feature "edit account details" do

  let (:user) { FactoryGirl.create(:user) }
  let! (:lifehack) { FactoryGirl.create(:lifehack, creator: user) }
  let! (:review) do
    FactoryGirl.create(:review, creator: user, lifehack: lifehack)
  end

  scenario "user sees current account details" do
    user_sign_in(user)
    click_link "Logged In As: #{user.first_name}"

    expect(page).to have_content("User Details")
    expect(page).to have_content("Name: #{user.full_name}")
    expect(page).to have_content("Email: #{user.email}")
    expect(page).to have_content(lifehack.title)
    expect(page).to have_content(review.lifehack.title)
  end

  scenario 'user navigates to edit account page' do
    user_sign_in(user)
    click_link "Logged In As: #{user.first_name}"
    click_link "Update Account Information"
  end

  scenario "user must enter current password for profile update" do
    user_sign_in(user)
    visit edit_user_registration_path
    fill_in 'First name', with: 'bob'
    fill_in 'Current password', with: "notcorrectPW"
    click_button 'Update'

    expect(page).to have_content("error")

    click_link "Logged In As: #{user.first_name}"
    expect(page).to_not have_content("bob")
  end

  scenario "user updates name" do
    user_sign_in(user)
    visit edit_user_registration_path
    fill_in 'First name', with: 'bob'
    fill_in 'Last name', with: 'smith'
    fill_in 'Current password', with: user.password
    click_button 'Update'

    click_link("Logged In As: bob")
    expect(page).to have_content("Name: bob smith")
  end

  scenario "user updates email" do
    user_sign_in(user)
    visit edit_user_registration_path
    fill_in 'Email', with: "test@email.com"
    fill_in 'Current password', with: user.password
    click_button 'Update'
    click_link "Logged In As: #{user.first_name}"

    expect(page).to have_content("Email: test@email.com")
  end

  scenario "user updates password" do
    user_sign_in(user)
    visit edit_user_registration_path
    fill_in 'Password', with: "newpassword"
    fill_in 'Password confirmation', with: "newpassword"
    fill_in 'Current password', with: user.password
    click_button 'Update'
    click_on 'Sign Out'
    click_on 'Sign In'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: "newpassword"
    click_button 'Log In'

    expect(page).to have_content("Logged In As: #{user.first_name}")
  end

  scenario "user updates profile picture" do
    user_sign_in(user)
    visit edit_user_registration_path
    attach_file 'user[profile_photo]',
      "#{Rails.root}/spec/support/images/NAF-logo.png"
    fill_in 'Current password', with: user.password
    click_button "Update"

    expect(page).to_not have_css("img[src*='photo.png']")
    expect(page).to have_css("img[src*='NAF-logo.png']")
  end
end
