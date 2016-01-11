require 'rails_helper'

feature 'user uses advanced search', %{
  As a User
  I want to search the lifehacks with more detail
  So I can find a specific lifehack easier
} do

  # Acceptance Criteria:
  # [x] I should see an advanced search bar on the search results page
  # [ ] I should be able to use any or all of the advanced search features to
  #     find the correct item

  let(:lifehack) { FactoryGirl.create(:lifehack) }
  let(:lifehack2) { FactoryGirl.create(:lifehack) }
  let(:user) { FactoryGirl.create(:user) }

  scenario 'user sees advanced search bar' do
    user_sign_in(user)
    visit search_lifehacks_path

    expect(page).to have_css(".advanced-search")
  end
end
