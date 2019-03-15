require 'rails_helper'

RSpec.describe 'Home features' do
  it 'displays the name of the app' do
    visit('/')
  #  expect(page).to have_content('
  end
end
feature "Signing in" do
  # background do
  #  User.make(email: 'user@example.com', password: 'caplin')
  # end

  scenario "Entering a valid URL" do
    visit '/'
    fill_in 'shorten_url_url', with: 'https://facebook.com'
    click_button 'Shorten'
    expect(page).to have_content 'Success'
    click_link('Edit')
    expect(page).to have_content 'Success'
    select 'inactive', from: 'shorten_url_status'
    click_button 'Shorten'
    expect(page).to have_content 'Success'
  end


  scenario "Entering an invalid URL" do
    visit '/'
    fill_in 'shorten_url_url', with: 'https;//facebook.com'
    click_button 'Shorten'
    expect(page).to have_content 'url is not a valid url'
  end

  scenario "Entering an invalid admin URL" do
    visit '/s/admin/123456'
    expect(page).to have_content 'not found'
  end
end
