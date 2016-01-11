require 'rails_helper'

feature 'admin deletes item', %{
  As an Admin
  I want to delete lifehacks and reviews
  So I can curate the site's content
} do

  # Acceptance Criteria:
  # [x] admin can delete lifehack
  # [x] admin can delete review
  # [x] member cannot delete lifehack where they are not the creator
  # [x] member cannot delete review where they are not the creator

  let(:lifehack) { FactoryGirl.create(:lifehack) }
  let(:lifehack2) { FactoryGirl.create(:lifehack) }
  let(:user) { FactoryGirl.create(:user, role: "member") }
  let(:member) { FactoryGirl.create(:user, role: "member") }
  let(:admin) { FactoryGirl.create(:user, role: "admin") }
  let(:review) do
    FactoryGirl.create(:review, creator: user, lifehack: lifehack)
  end

  scenario "admin deletes lifehack" do
    user_sign_in(admin)
    lifehack
    visit lifehacks_path
    click_link lifehack.title

    within(".lifehack-admin-panel") do
      click_button 'Delete Lifehack'
    end

    expect(current_path).to eq(lifehacks_path)
    expect(page).to have_content(
      "Admin successfully deleted lifehack: #{lifehack.title}"
    )
    within(".lifehacklist") do
      expect(page).to_not have_content(lifehack.title)
    end
  end

  scenario "admin deletes review" do
    user_sign_in(admin)
    review
    visit lifehacks_path
    click_link lifehack.title

    within('.review-admin-panel') do
      click_button 'Delete Review'
    end

    expect(page).to have_content("Admin deleted review: #{review.id}")
    expect(page).to have_css('.lifehack-admin-panel')
    expect(page).to have_content(lifehack.title)
    expect(page).to_not have_content(review.rating)
    expect(page).to_not have_content(review.comment)
  end

  scenario "member can not delete lifehack if they did not create it" do
    user_sign_in(member)
    review
    visit lifehacks_path
    click_link lifehack.title

    expect(page).to_not have_css('.lifehack-admin-panel')
  end

  scenario "member can not delete review if they did not create it" do
    user_sign_in(member)
    review
    visit lifehacks_path
    click_link lifehack.title

    expect(page).to_not have_css('.review-admin-panel')
  end
end
