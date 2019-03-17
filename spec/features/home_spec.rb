require 'rails_helper'

RSpec.describe 'Shorten Url features' do

  feature "Security" do
    # let!(:url) { create(:shorten_url, original_url: "https://facebook.com") }
    after(:all) do
        DatabaseCleaner.clean_with(:truncation)
    end

    short = ShortenUrl.create(original_url: 'https://google.com')
    it "shows we cannot access this page" do
      visit "shorten_urls/#{short.id}"
      expect(page).to have_content 'Not Authorized'
      expect(page.status_code).to eq(401)
    end
  end

  feature "Edit" do
    # background do
    #  User.make(email: 'user@example.com', password: 'caplin')
    # end

    scenario "Entering and Editing valid URL" do
      visit '/'
      fill_in 'shorten_url_original_url', with: 'https://facebook.com'
      click_button 'Shorten'
      expect(page).to have_content 'Url: https://facebook.com'
      expect(page).to have_content 'Status: Active'
      expect(page).to have_content 'Admin: http://localhost:3000/s/admin'
      find('#Edit').click
      select 'inactive', from: 'shorten_url_status'
      click_button 'Shorten'
      expect(page).to have_content 'Status: Inactive'
      click_link('short_admin')
      expect(page).to have_content 'Url: https://facebook.com'
      expect(page).to have_content 'Status: Inactive'
      find('#Edit').click
      select 'active', from: 'shorten_url_status'
      click_button 'Shorten'
      expect(page).to have_content 'Status: Active'
    end
  end

  feature "Redirect to Error page"
  scenario "Check clicking Inactive URL" do
    visit '/'
    fill_in 'shorten_url_original_url', with: 'https://facebook.com'
    click_button 'Shorten'
    expect(page).to have_content 'Url: https://facebook.com'
    expect(page).to have_content 'Status: Active'
    expect(page).to have_content 'Admin: http://localhost:3000/s/admin'
    click_link('short_admin')
    expect(page).to have_content 'Url: https://facebook.com'
    expect(page).to have_content 'Status: Active'
    find('#Edit').click
    select 'inactive', from: 'shorten_url_status'
    click_button 'Shorten'
    expect(page).to have_content 'Status: Inactive'
    click_link('short_url')
    expect(page).to have_content 'URL has expired'
    expect(page.status_code).to eq(404)
  end

  scenario "Entering an invalid URL" do
    visit '/'
    fill_in 'shorten_url_original_url', with: 'https;//facebook.com'
    click_button 'Shorten'
    expect(page).to have_content 'Invalid URL'
  end

  scenario "Entering an invalid admin URL" do
    visit '/s/admin/123456'
    expect(page).to have_content 'You have attempted to access a page for which you are not authorized'
    expect(page.status_code).to eq(401)
  end
  scenario "Entering an invalid URL" do
    visit '/123456'
    expect(page).to have_content 'URL not found'
    expect(page.status_code).to eq(404)
  end
end
