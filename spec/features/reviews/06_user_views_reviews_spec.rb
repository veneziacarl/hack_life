require 'rails_helper'

feature 'user views reviews for a lifehack', %{
    'As a user
    I want to view all reviews on a lifehack
    So that I can decide which lifehack I might want to use'
  } do

  # Acceptance criteria
  # [√] I must be logged in
  # [√] I must be on the lifehack details page
  # [√] I can see a list of reviews ordered by most recent review

  let (:lifehack) { FactoryGirl.create(:lifehack) }
  let (:review1) { FactoryGirl.create(:review, lifehack: lifehack) }
  let (:review2) { FactoryGirl.create(:review, lifehack: lifehack)}
  let (:review3) { FactoryGirl.create(:review, lifehack: lifehack)}
  let (:review4) { FactoryGirl.create(:review, lifehack: lifehack)}
  let (:user) { FactoryGirl.create(:user) }

  scenario 'user visits lifehack details and sees reviews for that lifehack' do

    user_sign_in(user)

    visit lifehack_path(lifehack)

    expect(page).to have_content(review1.lifehack.title)
    expect(page).to have_content(lifehack.description)
    expect(page).to have_content 'Add Review'
    expect(page).to have_content(review1.rating)
    expect(page).to have_content(review1.comment)
    expect(page).to have_content(review2.rating)
    expect(page).to have_content(review1.created_at)

    expect(page).to have_content("Next")
    end
  end
