class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :page

  validates :url, presence: { on: :create }
  validates :user, presence: true

  before_create :assign_page

  attr_writer :url

  def self.find_by_url(url)
    joins(:page).where('pages.url' => url)
  end

  # This allows likes to accept a URL during creation but proxy lookups to the associated page
  def url
    @url || (page && page.url)
  end

  def assign_page
    self.page = Page.first_or_create_by_url(@url, true)
  end
end
