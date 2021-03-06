require "rails_helper"

# Acceptance Criteria:
# [x] user can see current account details page
# [x] user can navigate to edit account page
# [x] user can update name
# [x] user can update email
# [x] user can update profile picture
# [x] user can update password
# [x] user must enter current password for update to persist

feature "edit account details" do

  let (:user) { FactoryGirl.create(:user) }
  let! (:lifehack) { FactoryGirl.create(:lifehack, creator: user) }
  let! (:review) do
    FactoryGirl.create(:review, creator: user, lifehack: lifehack)
  end

  before (:each) do
    user_sign_in(user)
  end

  scenario "user sees current account details" do
    click_link "Welcome #{user.first_name}"

    expect(page).to have_content("User Details")
    expect(page).to have_content("Name: #{user.full_name}")
    expect(page).to have_content("Email: #{user.email}")
    expect(page).to have_content(review.lifehack.title)
  end

  scenario 'user navigates to edit account page' do
    click_link "Welcome #{user.first_name}"
    click_link "Update Account Information"

    expect(page).to have_content('Edit User')
  end

  scenario "user must enter current password for profile update" do
    visit edit_user_registration_path
    fill_in 'First name', with: 'bob'
    fill_in 'Current password', with: "notcorrectPW"
    click_button 'Update'

    expect(page).to have_content("error")

    click_link "Welcome #{user.first_name}"
    expect(page).to_not have_content("bob")
  end

  scenario "user updates name" do
    visit edit_user_registration_path
    fill_in 'First name', with: 'bob'
    fill_in 'Last name', with: 'smith'
    fill_in 'Current password', with: user.password
    click_button 'Update'

    click_link("Welcome bob")
    expect(page).to have_content("Name: bob smith")
  end

  scenario "user updates email" do
    visit edit_user_registration_path
    fill_in 'Email', with: "test@email.com"
    fill_in 'Current password', with: user.password
    click_button 'Update'
    click_link "Welcome #{user.first_name}"

    expect(page).to have_content("Email: test@email.com")
  end

  scenario "user updates password" do
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

    expect(page).to have_content("Welcome #{user.first_name}")
  end

  scenario "user updates profile picture" do
    visit edit_user_registration_path
    attach_file 'user[profile_photo]',
      "#{Rails.root}/spec/support/images/NAF-logo.png"
    fill_in 'Current password', with: user.password
    click_button "Update"

    expect(page).to_not have_css("img[src*='photo.png']")
    expect(page).to have_css("img[src*='NAF-logo.png']")
  end

  scenario "user cannot update other profiles" do
    click_link('Sign Out')
    user_sign_in(FactoryGirl.create(:user))
    visit lifehack_path(lifehack)
    within ".review-#{review.id}" do
      click_link review.creator.full_name
    end

    expect(current_path).to eq(user_path(review.creator))
    expect(page).to_not have_link('Update Account Information')
    expect(page).to have_content("Name: #{review.creator.full_name}")
    expect(page).to have_content("Email: #{review.creator.email}")
  end
end
