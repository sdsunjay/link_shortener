class ShortenUrl < ApplicationRecord
  has_many :url_clicks
  default_scope { order(created_at: :desc) }
  validates :original_url, presence: { message: "Must be given" }
  validates :original_url, url: true

  before_create :generate_short_url
  before_create :generate_admin_url
  # before_create :find_duplicate

  enum status: { active: 0, inactive: 1 }
  validates :status, inclusion: { in: statuses.keys, message: "%{value} is not a valid status" }

  # Check a unique URL for a given web address before saving it into the DB
  def generate_short_url
    short_url = unique_url

    # check if this is a duplicate
    if ShortenUrl.where(short_url: short_url).exists?
      # try again
      generate_short_url
    else
      self.short_url = short_url
    end
  end

  def generate_admin_url
    admin_url = unique_url

    # check if this is a duplicate
    if ShortenUrl.where(admin_url: admin_url).exists?
      # try again
      generate_admin_url
    else
      self.admin_url = admin_url
    end
  end

  def is_duplicate?
    ShortenUrl.where(original_url: original_url).exists?
  end

  def new_url?
    find_duplicate.nil?
  end

  # def sanitize
  # self.original_url.strip!
  # self.sanitize_url
  # end

  def active?
    return true if status == 'active'

    false
  end

  def short
    "http://localhost:3000/#{short_url}"
  end

  def short_admin
    "http://localhost:3000/s/admin/#{admin_url}"
  end

  def unique_url
    [*'a'..'z', *'A'..'Z', *0..9].sample(6).join
  end
end
