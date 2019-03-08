class AddUserToShortenUrls < ActiveRecord::Migration[5.2]
  def change
    add_reference :shorten_urls, :user, index: true
    add_foreign_key :shorten_urls, :users
  end
end
