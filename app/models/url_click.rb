class UrlClick < ApplicationRecord
  default_scope { order(created_at: :desc) }
  belongs_to :shorten_url, -> { order(created_at: :desc) }
  validates :shorten_url_id, presence: { message: 'Click must belong to a URL' }
end
