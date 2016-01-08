require 'rails_helper'

feature 'user searches lifehack', %{
  As a User
  I want to search the lifehacks
  So I can find a specific lifehack
} do

  # Acceptance Criteria:
  # [x] I should see a search bar in the top bar of the site
  # [ ] I should be able to enter a word in to the seach bar and be brought
  #     to a results page where I can see all lifehacks containing my search
  #     term in the title
  # [ ] I should be able to click a returned result and be brought to that
  #     lifehack's show page
  # [ ] On the search results page, I should be able to sort my search results
  # [ ] On the search results page, I should be presented with additional search
  #     options to search by title, description, author, etc.
  # [ ] If I enter in a search query that has no results, I should be brought
  #     to the search page and told that there are no results. I should be
  #     presented with a link to return to the main page

  let(:lifehack) { FactoryGirl.create(:lifehack) }
  let(:lifehack2) { FactoryGirl.create(:lifehack) }
  let(:user) { FactoryGirl.create(:user) }

    scenario 'user sees search bar' do
      visit lifehacks_path

      expect(page).to have_css("nav.top-bar #search-bar")
    end

    scenario 'user searches' do
      user_sign_in(user)
      # Lifehack.create(title: 'how to', description: 'descriptionhere', creator: user)
      lifehack
      visit lifehacks_path
      fill_in 'search', with: 'how to'
      click_button 'Search'

      expect(page).to have_content('1 result found')
      expect(page).to have_content(lifehack.title)
    end
#
# scenario 'user views details of lifehack'
#
# scenario 'user sorts search result'
#
# scenario 'search query returns no result'
#
#
#
#
# end
end
