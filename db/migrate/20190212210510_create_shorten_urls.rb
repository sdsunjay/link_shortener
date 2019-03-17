class CreateShortenUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :shorten_urls do |t|
      t.text :original_url, null: false, unique: true
      t.string :short_url
      t.integer :status, null: false, default: 0
      t.timestamps
    end
  end
end
