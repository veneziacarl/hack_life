require 'rails_helper'

feature 'user adds review', %{
  As a User
  I want to comment on a lifehack
  So I can share my opinion
} do

  # Acceptance Criteria:
  # [ ] I can add a new review for a lifehack on the show page
  # [ ] On successful submission, the review appears on the lifehack show page
  # [ ] If I do not fill out the required fields, I should see errors
  # [ ] On error, the review should not appear on the show page

  scenario 'user specifies rating and comment' do
    visit root_path
    click_link 'Add Review'

    within('.rating') { choose '5' }
    fill_in 'Comment', with: 'testcomment'
    click_button 'Add Review'

    expect(page).to have_content('Review made!')
    expect(page).to have_content('Rating: 5')
    expect(page).to have_content('Comment: testcomment')
  end

  scenario 'user specifies rating' do
    visit root_path
    click_link 'Add Review'

    within('.rating') { choose '5' }
    click_button 'Add Review'

    expect(page).to have_content('Review made!')
    expect(page).to have_content('Rating: 5')
  end

  scenario 'user does not specify rating' do
    visit root_path
    click_link 'Add Review'

    fill_in 'Comment', with: 'testcomment'
    click_button 'Add Review'
    expect(page).to have_content("Review rating can't be blank!")

    visit reviews_path
    expect(page).to_not have_content('Comment: testcomment')
  end

  scenario 'user sees new review form on show page'
  scenario 'user sees new review on successful submission'
end
