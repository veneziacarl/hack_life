require 'rails_helper'

feature 'admin updates item', %{
  As an Admin
  I want to updated lifehacks and reviews
  So I can curate the site's content
} do

  # Acceptance Criteria:
  # [] admin can edit lifehack
  # [] admin can edit review
  # [] member cannot edit lifehack where they are not the creator
  # [] member cannot edit review where they are not the creator

  let(:lh) { FactoryGirl.create(:lifehack) }
  let(:lh2) { FactoryGirl.create(:lifehack) }
  let(:member) { FactoryGirl.create(:user, role: "member") }
  let!(:user) { FactoryGirl.create(:user, role: "admin") }
  let(:review) do
    FactoryGirl.create(:review, creator: user, lifehack: lh)
  end

  scenario "admin edits lifehack" do
    user_sign_in(user)
    lh
    visit lifehacks_path
    click_link lh.title

    expect(current_path).to eq(lifehack_path(lh))
    within(".lifehack-admin-panel") do
      click_link 'Edit Lifehack'
    end

    test_title = 'Hopefully this work'
    description = 'Testing out this cool new edition to the lifehack'
    fill_in('lifehack[title]', with: test_title)
    fill_in('lifehack[description]', with: description)
    click_button('Add Lifehack')

    expect(current_path).to eq(lifehack_path(lh))
    expect(page).to have_content(test_title)
    expect(page).to have_content(description)
    expect(page).to have_content(
    "Admin successfully edited lifehack: #{test_title}"
    )
  end

  scenario "admin edits review" do
    user_sign_in(user)
    review
    visit lifehacks_path
    click_link lh.title

    within('.review-admin-panel') do
      click_link 'Edit Review'
    end

    expect(page).to have_content("Admin editd review: #{review.id}")
    expect(page).to have_css('.lifehack-admin-panel')
    expect(page).to have_content(lh.title)
    expect(page).to_not have_content(review.rating)
    expect(page).to_not have_content(review.comment)
  end

  scenario "member can not edit lifehack if they did not create it" do
    user_sign_in(member)
    review
    visit lifehacks_path
    click_link lh.title

    expect(page).to_not have_button('Edit Lifehack')
  end

  scenario "member can not edit review if they did not create it" do
    user_sign_in(member)
    review
    visit lifehacks_path
    click_link lh.title

    expect(page).to_not have_button('Edit Review')
  end
end
