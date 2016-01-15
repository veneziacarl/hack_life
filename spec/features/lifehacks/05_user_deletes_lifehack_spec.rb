require 'rails_helper'
feature 'user deletes lifehack', %{
  As a User and the creator of the lifehack
  I want to destroy the lifehack
  So I can delete the content of the lifehack
} do

  # Acceptance Criteria:
  # [√] I must be able delete a lifehack from the lifehack show page
  # [√] If I am not the creator, I cannot delete the lifehack

  let (:user) { FactoryGirl.create(:user) }
  let!(:lifehack) { FactoryGirl.create(:lifehack, creator: user) }
  let!(:lifehack2) { FactoryGirl.create(:lifehack, creator: user) }
  # let!(:reviews) { FactoryGirl.create(:review, lifehack: lifehack) }

  let (:user2) { FactoryGirl.create(:user) }

  scenario 'navigate to lifehack show page and delete lifehack' do
    user_sign_in(user)
    expect(page).to have_content(lifehack.title)
    expect(page).to have_content(lifehack2.title)

    click_link(lifehack.title)
    expect(current_path).to eq(lifehack_path(lifehack))

    click_button('Delete Lifehack')
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Admin successfully deleted lifehack:
    #{lifehack.title}")

    expect(page).to have_content(lifehack2.title)
  end

  scenario 'user attempts to edit another user\'s lifehack' do
    user_sign_in(user2)
    expect(page).to have_content(lifehack2.title)

    click_link(lifehack2.title)

    expect(page).to_not have_button('Delete Lifehack')
  end
end
