class CreateUrlClicks < ActiveRecord::Migration[5.2]
  def change
    create_table :url_clicks do |t|
      t.references :shorten_url, index: true, null: false, foreign_key: true
      t.timestamps
    end
  end
end
