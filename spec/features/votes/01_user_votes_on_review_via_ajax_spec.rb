require 'rails_helper'

feature "user adds vote to review via ajax", %{
  As a User
  I want to vote on a review
  Without having the page refresh
}, js: true do

  # Acceptance Criteria:
  # [] When I click on the vote button page should not refresh
  # [] When I vote on a review the score should be update immmidiately
  # []  When I click the note button twice, the vote should only update once
  # []  When I click the note button twice, an error message should display

  let (:user) { FactoryGirl.create(:user) }
  let (:user2) { FactoryGirl.create(:user) }
  let (:review) { FactoryGirl.create(:review) }

  scenario 'user upvotes review' do
    user_sign_in(user)
    visit lifehack_path(review.lifehack)
    within('.review') do
      expect(page).to have_content("Score: 0")
    end

    expect_no_page_reload do
      click_button '+1'

      within('.review') do
        expect(page).to have_content("Score: 1")
      end
    end
  end

  scenario 'multiple users upvote the same review' do
    user_sign_in(user)
    visit lifehack_path(review.lifehack)
    click_button '+1'

    click_link 'Sign Out'

    user_sign_in(user2)
    visit lifehack_path(review.lifehack)

    expect_no_page_reload do
      click_button '+1'

      within('.review') do
        expect(page).to have_content("Score: 2")
      end
    end
  end

  scenario 'user downvotes review' do
    user_sign_in(user)
    visit lifehack_path(review.lifehack)

    expect_no_page_reload do
      click_button '-1'

      within('.review') do
        expect(page).to have_content("Score: -1")
      end
    end
  end

  scenario 'user can only make 1 up vote on a single review' do
    user_sign_in(user)
    visit lifehack_path(review.lifehack)

    expect_no_page_reload do
      click_button '+1'
      within('.review') do
        expect(page).to have_content("Score: 1")
      end

      click_button '+1'
      expect(page).to have_content('You have already upvoted this review!')

      within('.review') do
        expect(page).to have_content("Score: 1")
      end
    end
  end

  scenario 'user can only make 1 down vote on a single review'

  scenario 'user can change vote on already voted review'

  scenario 'user can up vote for multiple reviews on the same lifehack'

  scenario 'user can down vote for multiple reviews on the same lifehack'

  scenario 'user cannot vote for same review after voting on another review'

  scenario 'user can up vote for reviews on different lifehacks'

end
