require 'rails_helper'

feature 'user adds lifehack', %{
  As a User
  I want to add a lifehack
  So I can share my hack with the community
} do

  # Acceptance Criteria:
  # [x] If I am logged in, I can click a button on the index to
  #     add a new lifehack
  #     and be brought to a form on the 'new' page
  # [x] If I am logged in, and I fill out the form incorrectly,
  #     I am given an error
  # [x] If I am not logged in, I should be told to log in before adding
  #     a new lifehack
  # [x] On successful submission, the lifehack appears on the index
  #     and the user is brought to the show page
  # [x] If I do not fill out the required fields, I should see errors
  # [x] On error, the lifehack should not appear on the index

  let (:user) { FactoryGirl.create(:user) }

  scenario 'logged in user navigates to `new` page' do
    user_sign_in(user)
    visit lifehacks_path
    click_link 'Add Lifehack'

    expect(current_path).to eq(new_lifehack_path)
    expect(page).to have_css('form')
  end

  scenario 'logged in user adds new lifehack' do
    user_sign_in(user)
    visit new_lifehack_path
    fill_in 'Title', with: 'cut pizza better'
    fill_in 'Description', with: 'fold it over and cut 3 times for 6 pieces'
    click_button 'Add Lifehack'

    expect(page).to have_content('Lifehack Created Successfully!')
    expect(page).to have_content('cut pizza better')
    expect(page).to have_content('fold it over and cut 3 times for 6 pieces')
    expect(page).to have_content(user.first_name)

    visit lifehacks_path
    expect(page).to have_content('cut pizza better')
  end

  scenario 'logged in user incorrectly fills out form' do
    user_sign_in(user)
    visit new_lifehack_path
    fill_in 'Description', with: 'fold it over and cut 3 times for 6 pieces'
    click_button 'Add Lifehack'

    expect(page).to have_content('error in submission')
    expect(find_field('Description').value).to eq(
      'fold it over and cut 3 times for 6 pieces'
    )

    visit lifehacks_path
    expect(page).to_not have_content('cut pizza better')
  end

  scenario 'not logged in user cannot create lifehack' do
    visit lifehacks_path
    click_link 'Add Lifehack'
    expect(page).to have_content("You need to sign in or sign up before continuing.")
    expect(current_path).to eq('/users/sign_in')
  end
end
