require 'rails_helper'
feature 'user updates lifehack', %{
  As a User and the creator of the lifehack
  I want to edit the lifehack
  So I can update the content of the lifehack
} do

  # Acceptance Criteria:
  # [√] I must provide all of the required information
  # [√] If the information is incorrect, I must be provided errors
  # [√] If I am not logged in, I cannot modify the content of the lifehack
  # [√] If I am not the creator, I cannot modify the content of the lifehack

  let (:user) { FactoryGirl.create(:user) }
  let!(:lifehack) { FactoryGirl.create(:lifehack, creator: user) }
  let (:user2) { FactoryGirl.create(:user) }

  scenario 'navigate to lifehack show page and edit lifehack' do
    user_sign_in(user)
    click_link(lifehack.title)

    expect(current_path).to eq(lifehack_path(lifehack))

    click_link('Edit Lifehack')

    expect(find_field('lifehack[title]').value).to eq(lifehack.title)
    expect(find_field('lifehack[description]').value).to eq(lifehack.description)

    title = 'Hopefully this work'
    description = 'Testing out this cool new edition to the lifehack'
    fill_in('lifehack[title]', with: title)
    fill_in('lifehack[description]', with: description)
    click_button('Add Lifehack')

    expect(current_path).to eq(lifehack_path(lifehack))
    expect(page).to have_content(title)
    expect(page).to have_content(description)
    expect(page).to have_content('Lifehack Edited Successfully!')
  end

  scenario 'user attempts to post an invalid title' do
    user_sign_in(user)
    click_link(lifehack.title)
    click_link('Edit Lifehack')

    expect(find_field('lifehack[title]').value).to eq(lifehack.title)
    expect(find_field('lifehack[description]').value).to eq(lifehack.description)


    description = 'How fast can I type this without making a mistake'
    fill_in('lifehack[title]', with: '')
    fill_in('lifehack[description]', with: description)
    click_button('Add Lifehack')

    expect(find_field('lifehack[title]').value).to eq('')
    expect(find_field('lifehack[description]').value).to eq(description)
  end

  scenario 'user attempts to edit another user\'s lifehack' do
    user_sign_in(user2)
    click_link(lifehack.title)
    click_link('Edit Lifehack')

    expect(page).to have_content('You are not the Authorized User')
  end
end
