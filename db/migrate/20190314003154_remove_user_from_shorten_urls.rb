class RemoveUserFromShortenUrls < ActiveRecord::Migration[5.2]
  def change
    remove_column :shorten_urls, :user_id, :bigint
  end
end
