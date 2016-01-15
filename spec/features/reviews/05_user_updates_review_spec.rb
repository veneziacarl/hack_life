require 'rails_helper'
feature 'user updates review', %{
  As a User and the creator of the review
  I want to edit the review
  So I can update the content of the lifehack
} do

  # Acceptance Criteria:
  # [√] I must provide all of the required information
  # [√] If the information is incorrect, I must be provided errors
  # [√] If I am not logged in, I cannot modify the content of the review
  # [√] If I am not the creator, I cannot modify the content of the review

  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:lh) { FactoryGirl.create(:lifehack, creator: user) }
  let!(:review) { FactoryGirl.create(:review, lifehack: lh, creator: user2) }

  scenario 'user sucessfully edits review' do
    user_sign_in(user2)
    click_link(lh.title)

    expect(page).to have_content(lh.title)
    expect(page).to have_content(lh.description)
    expect(page).to have_content(review.comment)

    click_link('Edit')
    new_comment = 'Changing the review'
    fill_in('review[comment]', with: new_comment)

    click_button('Update Review')

    expect(page).to have_content(lh.title)
    expect(page).to have_content(lh.description)
    expect(page).to have_content('Review edited successfully!')
    expect(page).to have_content(new_comment)
  end

  scenario 'user review edit unsuccessful' do
    user_sign_in(user2)
    click_link(lh.title)

    expect(current_path).to eq(lifehack_path(lh))
    expect(page).to have_content(lh.title)
    expect(page).to have_content(lh.description)

    click_link('Edit')

    fill_in('review[comment]', with: '')
    click_button('Update Review')
    expect(page).to have_content('Review edited successfully!')
  end

  scenario 'user attempts to edit another user\'s review' do
    user_sign_in(user)
    click_link(lh.title)

    expect(current_path).to eq(lifehack_path(lh))
    expect(page).to have_content(lh.title)
    expect(page).to have_content(lh.description)
    expect(page).to have_content(review.comment)
  
    within('.review') do
      expect(page).to_not have_link('Edit')
      expect(page).to_not have_link('Delete')
    end
  end
end
