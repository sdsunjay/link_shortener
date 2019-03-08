class ShortenUrl < ApplicationRecord
  has_many :url_clicks
  default_scope { order(created_at: :desc) }
  validates :original_url, presence: true
  validates :original_url, url: true

  before_create :generate_short_url
  before_create :generate_admin_url
  # before_save { self.errors.add(:base, 'error here or something') if self.short_url.nil? }
  # before_create :find_duplicate

  enum status: { active: 0, inactive: 1 }

  UNIQUE_ID_LENGTH = 6
  LETTERS = [*'a'..'z', *'A'..'Z', *0..9]

  # Check a unique URL for a given web address before saving it into the DB
  def generate_short_url
     short_url = LETTERS.shuffle[0,UNIQUE_ID_LENGTH].join

     # check if this is a duplicate
     if ShortenUrl.where(short_url: short_url).exists?
       # try again
       self.generate_short_url
     else
       self.short_url = short_url
     end
  end

  def generate_admin_url
     admin_url = LETTERS.shuffle[0,UNIQUE_ID_LENGTH].join

     # check if this is a duplicate
     if ShortenUrl.where(admin_url: admin_url).exists?
       # try again
       self.generate_admin_url
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
    return true if self.status == 'active'
    false
  end

  def short
    "http://localhost:3000/#{short_url}"
  end

  def short_admin
    "http://localhost:3000/s/admin/#{admin_url}"
  end

end
