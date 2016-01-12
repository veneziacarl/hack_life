require 'rails_helper'

feature 'user uses advanced search', %{
  As a User
  I want to search the lifehacks with more detail
  So I can find a specific lifehack easier
} do

  # Acceptance Criteria:
  # [x] I should see an advanced search bar on the search results page
  # [x] I should be able to use any or all of the advanced search features to
  #     find the correct item
  # [x] search is case-insensitive
  # [x] can search user by first or last name or both

  let! (:lifehack) { FactoryGirl.create(:lifehack) }
  let! (:lifehack2) { FactoryGirl.create(:lifehack) }
  let! (:user) { FactoryGirl.create(:user) }

  scenario 'user advanced searches by title and is case-insensitive' do
    user_sign_in(user)
    click_link 'Advanced'
    within('.advanced-search') do
      fill_in 'title', with: 'tIe'
    end
    click_button 'Advanced Search'

    expect(page).to have_content('2 result(s) found')
  end

  scenario 'user advanced searches by description and is case-insensitive' do
    user_sign_in(user)
    click_link 'Advanced'
    within('.advanced-search') do
      fill_in 'description', with: 'kNOt'
    end
    click_button 'Advanced Search'

    expect(page).to have_content('2 result(s) found')
  end

  scenario 'user advanced searches by user first name and is case-insensitive' do
    user_sign_in(user)
    click_link 'Advanced'
    within('.advanced-search') do
      fill_in 'user', with: 'JOhN'
    end
    click_button 'Advanced Search'

    expect(page).to have_content('2 result(s) found')
  end

  scenario 'user advanced searches by user last name, case-insensitive' do
    user_sign_in(user)
    click_link 'Advanced'
    within('.advanced-search') do
      fill_in 'user', with: 'lASTly'
    end
    click_button 'Advanced Search'

    expect(page).to have_content('2 result(s) found')
  end

  scenario 'user advanced searches by user full name, case-insensitive' do
    user_sign_in(user)
    click_link 'Advanced'
    within('.advanced-search') do
      fill_in 'user', with: 'JoHN lAstly'
    end
    click_button 'Advanced Search'

    expect(page).to have_content('2 result(s) found')
  end

  scenario 'user search does not show any unrelated results' do
    user_sign_in(user)
    click_link 'Advanced'
    within('.advanced-search') do
      fill_in 'user', with: 'billy joe'
    end
    click_button 'Advanced Search'

    expect(page).to have_content('0 result(s) found')
  end

  scenario 'user searches using multiple fields' do
    user_sign_in(user)
    georgia = User.create(first_name: 'georgia', last_name: 'ly', email: 'm@m.com', password: 'password')
    georgia_hack = Lifehack.create(title: 'test', creator: georgia)
    click_link 'Advanced'
    within('.advanced-search') do
      fill_in 'user', with: 'john'
      fill_in 'title', with: 'test'
    end
    click_button 'Advanced Search'

    expect(page).to have_content('3 result(s) found')
    expect(page).to have_content(georgia_hack.title)
  end
end
