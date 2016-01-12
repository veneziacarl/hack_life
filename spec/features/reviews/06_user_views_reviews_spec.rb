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

  let!(:review) { FactoryGirl.create(:review) }
  let(:user) { FactoryGirl.create(:user) }

  scenario 'user visits lifehack details and sees reviews for that lifehack' do

    user_sign_in(user)

    visit lifehack_path(review.lifehack)

    expect(page).to have_content(review.lifehack.title)
    expect(page).to have_content(review.lifehack.description)
    expect(page).to have_content 'Add Review'
    expect(page).to have_content(review.rating)
    expect(page).to have_content(review.comment)
    end
  end
