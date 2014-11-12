class UserPage < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :user
  belongs_to :page
  has_many :extracted_keywords, through: :page
  has_many :extracted_entities, through: :page

  validates :user, presence: true

  before_create :assign_page
  before_save :update_status_times

  mapping do
    indexes :title, analyzer: :snowball
    indexes :content, analyzer: :snowball
    indexes :provider_display
    indexes :provider_name
    indexes :author_name
    indexes :description
    indexes :liked, type: :boolean
    indexes :saved, type: :boolean
    indexes :read, type: :boolean
    indexes :keywords, analyzer: :snowball
    indexes :entities, analyzer: :snowball
  end

  attr_writer :url

  # Clean up and normalize the URL
  normalize_attribute :url do |value|
    Page.normalize_url(value)
  end

  def self.likes
    where(liked: true).order('user_pages.created_at desc')
  end

  def self.saves
    where(saved: true).order('user_pages.created_at desc')
  end

  def self.find_by_url(url)
    joins(:page).where('pages.url' => Page.normalize_url(url))
  end

  def self.find_or_create_by_url(url)
    find_by_url(url).create_with(url: url).first_or_create
  end

  delegate :favicon_url, :provider_display, :provider_name, :provider_url, :author_name, :media_type,
           :media_html, :content, :media_height, :media_width, :image_url, :summary, :published_at,
           to: :page

  def title
    self[:title] || page.andand.title
  end

  def description
    self[:description] || summary
  end

  def url
    @url || page.andand.url
  end

  def mark_liked!
    update!(liked: true)
  end

  def mark_unliked!
    update!(liked: false)
  end

  def mark_saved!
    update!(saved: true)
  end

  def mark_unsaved!
    update!(saved: false)
  end

  def as_indexed_json(options = {})
    hash = as_json(
            only: [
              :title,
              :content,
              :provider_display,
              :provider_name,
              :author_name,
              :description,
              :liked,
              :saved,
              :read
            ]
          )

    hash['keywords'] = extracted_keywords.collect(&:name)
    hash['entities'] = extracted_entities.collect(&:name)

    hash
  end

  private

    def assign_page
      self.page = Page.find_or_create_by_url(@url)
    end

    def update_status_times
      if saved_changed?
        self.saved_at = self.saved ? Time.now : nil
      end

      if liked_changed?
        self.liked_at = self.liked ? Time.now : nil
      end

      if read_changed?
        self.read_at = self.read ? Time.now : nil
      end
    end
end
