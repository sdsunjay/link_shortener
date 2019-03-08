class AddAdminUrlToShortenUrls < ActiveRecord::Migration[5.2]
  def change
    add_column :shorten_urls, :admin_url, :string
  end
end
