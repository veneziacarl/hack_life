require 'rails_helper'

feature 'user adds review', %{
  As a User
  I want to comment on a lifehack
  So I can share my opinion
} do

  # Acceptance Criteria:
  # [x] I can add a new review for a lifehack on the show page
  # [x] On successful submission, the review appears on the lifehack show page
  # [x] If I do not fill out the required fields, I should see errors
  # [x] On error, the review should not appear on the show page

  let (:user) { FactoryGirl.create(:user) }
  let (:lh) { FactoryGirl.create(:lifehack) }

  scenario 'user specifies rating and comment' do

    user_sign_in(user)
    visit lifehack_path(lh)
    click_link 'Add Review'

    within('.rating') { choose '5' }
    fill_in 'Comment', with: 'testcomment'
    click_button 'Add Review'

    expect(page).to have_content('Review made!')
    expect(page).to have_content('5')
    expect(page).to have_content('testcomment')
  end

  scenario 'user specifies rating' do

    user_sign_in(user)
    visit lifehack_path(lh)
    click_link 'Add Review'

    within('.rating') { choose '5' }
    click_button 'Add Review'

    expect(page).to have_content('Review made!')
    expect(page).to have_content('5')
  end

  scenario 'user does not specify rating' do

    user_sign_in(user)
    visit lifehack_path(lh)
    click_link 'Add Review'

    fill_in 'Comment', with: 'testcomment'
    click_button 'Add Review'
    expect(page).to have_content("Review rating can't be blank!")

    visit lifehack_path(lh)
    expect(page).to_not have_content('Comment: testcomment')
  end

  scenario 'user is not logged in and cannot post review' do
    visit root_path
    expect(page).to_not have_content('Add Review')

    click_link('Add Lifehack')
    expect(page).to have_content('You need to sign in or
      sign up before continuing.')
  end
end
