class UserPage < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :user
  belongs_to :page
  has_many :extracted_keywords, through: :page
  has_many :extracted_entities, through: :page

  validates :user, presence: true
  validates :page, uniqueness: { scope: :user_id }

  before_validation :assign_page
  before_save :update_status_times

  mapping do
    indexes :user_id, type: :string, index: :not_analyzed
    indexes :title
    indexes :content
    indexes :provider_display
    indexes :provider_name
    indexes :author_name
    indexes :liked, type: :boolean
    indexes :saved, type: :boolean
    indexes :read, type: :boolean
    indexes :interesting, type: :boolean
    indexes :keywords
    indexes :entities
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

  def self.find_or_create_by_url(url, title = nil)
    find_by_url(url).create_with(url: url, title: title).first_or_create
  end

  def self.remove_duplicates
    all.each do |up|
      UserPage.where('id <> ? AND user_id = ? AND page_id = ?', up.id, up.user_id, up.page_id).destroy_all
    end
  end

  delegate :favicon_url, :provider_display, :provider_name, :provider_url, :author_name, :media_type,
           :media_html, :content, :media_height, :media_width, :image_url, :summary, :published_at,
           :parsable?, :interesting?, :watchable?, :screenshot_url, :media_size_ratio,
           to: :page

  def title
    # Don't use titles that look like urls
    if self[:title] && !(self[:title] =~ /(https?:\/\/)|(www\.)/)
      self[:title]
    else
      page.andand.title
    end
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
              :user_id,
              :title,
              :provider_display,
              :provider_name,
              :author_name,
              :description,
              :liked,
              :saved,
              :read
            ]
          )

    # Index plain text content
    hash['content'] = ActionController::Base.helpers.strip_tags(content)
    hash['interesting'] = interesting?
    hash['keywords'] = extracted_keywords.collect(&:name)
    hash['entities'] = extracted_entities.collect(&:name)

    hash
  end

  private

    def assign_page
      self.page ||= Page.find_or_create_by_url(@url)
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
