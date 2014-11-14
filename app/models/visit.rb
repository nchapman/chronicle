class Visit < ActiveRecord::Base
  belongs_to :user
  belongs_to :user_page
  has_one :page, through: :user_page

  validates :url, presence: true, on: :create

  before_create :assign_user_page

  attr_writer :url
  attr_accessor :title

  # Clean up and normalize the URL
  normalize_attribute :url do |value|
    Page.normalize_url(value)
  end

  def url
    @url || (user_page && user_page.page && user_page.page.url)
  end

  def assign_user_page
    self.user_page = user.user_pages.find_or_create_by_url(url, title)
  end
end
