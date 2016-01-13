require 'rails_helper'

feature 'user searches lifehack', %{
  As a User
  I want to search the lifehacks
  So I can find a specific lifehack
} do

  # Acceptance Criteria:
  # [x] I should see a search bar in the top bar of the site
  # [x] I should be able to enter a word in to the seach bar and be brought
  #     to a results page where I can see all lifehacks containing my search
  #     term in the title
  # [x] I should be able to click a returned result and be brought to that
  #     lifehack's show page.
  # [x] If I enter in a search query that has no results, I should be brought
  #     to the search page and told that there are no results. I should be
  #     presented with a link to return to the main page
  # [x] Search is case-insensitive


  let! (:lifehack) { FactoryGirl.create(:lifehack) }
  let (:lifehack2) { FactoryGirl.create(:lifehack) }
  let(:user) { FactoryGirl.create(:user) }

  scenario 'user sees search bar' do
    visit lifehacks_path

    expect(page).to have_css("nav.top-bar #search-bar")
  end

  scenario 'user searches and finds one item' do
    user_sign_in(user)
    visit lifehacks_path
    fill_in 'search-all', with: 'how to'
    click_button 'Search'

    expect(page).to have_content('1 result(s) found')
    expect(page).to have_content(lifehack.title)
  end

  scenario 'user searches and finds multiple items' do
    user_sign_in(user)
    lifehack2
    visit lifehacks_path
    fill_in 'search-all', with: 'how to'
    click_button 'Search'

    expect(page).to have_content('2 result(s) found')
    expect(page).to have_link(lifehack.title)
    expect(page).to have_link(lifehack2.title)
  end

  scenario 'user views details of a specfic lifehack found through search' do
    user_sign_in(user)
    lifehack
    visit lifehacks_path
    fill_in 'search-all', with: 'how to'
    click_button 'Search'
    click_link lifehack.title

    expect(page).to have_content(lifehack.title)
    expect(page).to have_content(lifehack.description)
    expect(page).to have_content(lifehack.creator.first_name)
    expect(page).to have_content(lifehack.creator.last_name)
  end

  scenario 'search query returns no result' do
    user_sign_in(user)
    visit lifehacks_path
    fill_in 'search-all', with: 'this won\'t work'
    click_button 'Search'

    expect(page).to have_content('0 result(s) found')

    click_link ('Back to Index')
    expect(current_path).to eq(lifehacks_path)
  end

  scenario 'search is case-insensitive' do
    user_sign_in(user)
    visit lifehacks_path
    fill_in 'search-all', with: 'HoW TO'
    click_button 'Search'

    expect(page).to have_content('1 result(s) found')
    expect(page).to have_content(lifehack.title)
  end
end
