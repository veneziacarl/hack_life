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
  # [] Upon successful creation of a review and email is sent to the lifehack creator

  let (:user) { FactoryGirl.create(:user) }
  let (:lifehack) { FactoryGirl.create(:lifehack) }

  scenario 'user specifies rating and comment' do

    ActionMailer::Base.deliveries.clear

    user_sign_in(user)
    visit lifehack_path(lifehack)
    click_link 'Add Review'

    within('.rating') { choose '5' }
    fill_in 'Comment', with: 'testcomment'
    click_button 'Add Review'

    expect(page).to have_content('Review made!')
    expect(page).to have_content('Rating: 5')
    expect(page).to have_content('Comment: testcomment')
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end

  scenario 'user specifies rating' do

    ActionMailer::Base.deliveries.clear

    user_sign_in(user)
    visit lifehack_path(lifehack)
    click_link 'Add Review'

    within('.rating') { choose '5' }
    click_button 'Add Review'

    expect(page).to have_content('Review made!')
    expect(page).to have_content('Rating: 5')
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end

  scenario 'user does not specify rating' do

    ActionMailer::Base.deliveries.clear

    user_sign_in(user)
    visit lifehack_path(lifehack)
    click_link 'Add Review'

    fill_in 'Comment', with: 'testcomment'
    click_button 'Add Review'
    expect(page).to have_content("Review rating can't be blank!")

    visit lifehack_path(lifehack)
    expect(page).to_not have_content('Comment: testcomment')
    expect(ActionMailer::Base.deliveries.count).to eq(1)

  end

  scenario 'user sees new review form on show page'
  scenario 'user sees new review on successful submission'
  scenario 'user is not logged in and cannot post review'
end
