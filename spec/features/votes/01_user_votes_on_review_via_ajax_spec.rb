require 'rails_helper'

feature "user adds vote to review via ajax", %{
  As a User
  I want to vote on a review
  Without having the page refresh
} do

  # Acceptance Criteria:
  # [] When I click on the vote button page should not refresh
  # [] When I vote on a review the score should be update immmidiately
  # []  When I click the note button twice, the vote should only update once
  # []  When I click the note button twice, an error message should display

  let (:user) { FactoryGirl.create(:user) }
  let (:user2) { FactoryGirl.create(:user) }
  let (:samelh) { FactoryGirl.create(:lifehack) }
  let (:review) { FactoryGirl.create(:review) }
  let (:review_list) { FactoryGirl.create_list(:review, 2, lifehack: samelh) }
  let (:review_different_lifehack) { FactoryGirl.create_list(:review, 2) }

  scenario 'user upvotes review', js: true do
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

  scenario 'multiple users upvote the same review', js: true do
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

  scenario 'user downvotes review', js: true do
    user_sign_in(user)
    visit lifehack_path(review.lifehack)

    expect_no_page_reload do
      click_button '-1'

      within('.review') do
        expect(page).to have_content("Score: -1")
      end
    end
  end

  scenario 'user can only make 1 up vote on a single review', js: true do
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

  scenario 'user can only make 1 down vote on a single review', js: true do
    user_sign_in(user)
    visit lifehack_path(review.lifehack)

    expect_no_page_reload do
      click_button '-1'
      within('.review') do
        expect(page).to have_content("Score: -1")
      end

      click_button '-1'

      expect(page).to have_content('You have already downvoted this review!')
      within('.review') do
        expect(page).to have_content("Score: -1")
      end
    end
  end

  scenario 'user can change vote on already voted review', js: true do
    user_sign_in(user)
    visit lifehack_path(review.lifehack)
    expect_no_page_reload do
      click_button '+1'

      within('.review') do
        expect(page).to have_content("Score: 1")
      end
      click_button '-1'

      within('.review') do
        expect(page).to have_content("Score: -1")
      end
    end
  end

  scenario 'user can up vote for multiple reviews on the same lifehack', js: true do
    user_sign_in(user)
    visit lifehack_path(review_list.first.lifehack)

    expect_no_page_reload do
      review_list.each do |review|
        within(".review-#{review.id}") do
          click_button '+1'
        end

        within(".review-#{review.id}") do
          expect(page).to have_content("Score: 1")
        end
      end

      within(".review-#{review_list.first.id}") do
        expect(page).to have_content("Score: 1")
      end
    end
  end

  scenario 'user can down vote for multiple reviews on the same lifehack', js: true do
    user_sign_in(user)
    visit lifehack_path(review_list.first.lifehack)

    expect_no_page_reload do
      review_list.each do |review|
        within(".review-#{review.id}") do
          click_button '-1'
        end

        within(".review-#{review.id}") do
          expect(page).to have_content("Score: -1")
        end
      end

      within(".review-#{review_list.first.id}") do
        expect(page).to have_content("Score: -1")
      end
    end
  end

  scenario 'user cannot vote for same review after voting on another review', js: true do
    user_sign_in(user)
    visit lifehack_path(review_list.first.lifehack)

    expect_no_page_reload do
      review_list.each do |review|
        within(".review-#{review.id}") do
          click_button '-1'
        end

        within(".review-#{review.id}") do
          expect(page).to have_content("Score: -1")
        end
      end

      within(".review-#{review_list.first.id}") do
        click_button '-1'

        expect(page).to have_content("Score: -1")
      end
      expect(page).to have_content('You have already downvoted this review!')
    end
  end

  scenario 'user can up vote for reviews on different lifehacks', js: true do
    user_sign_in(user)

    review_different_lifehack.each do |review|
      visit lifehack_path(review.lifehack)

      expect_no_page_reload do
        within(".review-#{review.id}") do
          click_button '+1'
        end

        within(".review-#{review.id}") do
          expect(page).to have_content("Score: 1")
        end
      end
    end
  end
end
