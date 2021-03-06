class Page < ActiveRecord::Base
  include Extraction

  # Constants
  MINIMUM_IMAGE_ENTROPY = 1.75
  EXTRACTED_IMAGE_DENY_PATTERN = /github.com|(\..{2,3}\/$)|([&?]q=)|([&?]page=\d+)/
  SCREENSHOT_DENY_PATTERN = /localhost/

  # Relationships
  has_many :extracted_keywords
  has_many :extracted_entities
  has_many :user_pages

  # Validations
  validates :url, presence: true

  # This seems hacky but is reliable
  after_commit :enqueue_post_process, if: Proc.new { previous_changes[:id] }
  after_update :index_user_pages

  # Alias the extracted attributes
  alias_attribute :title, :extracted_title
  alias_attribute :provider_display, :extracted_provider_display
  alias_attribute :provider_name, :extracted_provider_name
  alias_attribute :provider_url, :extracted_provider_url
  alias_attribute :author_name, :extracted_author_name
  alias_attribute :media_type, :extracted_media_type
  alias_attribute :media_html, :extracted_media_html
  alias_attribute :media_height, :extracted_media_height
  alias_attribute :media_width, :extracted_media_width
  alias_attribute :favicon_color, :extracted_favicon_color

  alias_attribute :status_code, :parsed_status_code

  # Clean up and normalize the URL
  normalize_attribute :url do |value|
    Page.normalize_url(value)
  end

  def self.normalize_url(url)
    if url.present?
      Addressable::URI.parse(url.strip).normalize.to_s
    end
  end

  def self.find_or_create_by_url(url)
    find_or_create_by(url: url)
  end

  def enqueue_post_process
    PagePostProcessorJob.perform_later(self)
  end

  # Gather meta data for this page
  def post_process!
    Rails.logger.info('Post processing page: ' + url)

    update_parsed_data
    update_extracted_data

    save! if changed?
  end

  def self.post_process_all!
    all.each do |page|
      page.post_process! rescue nil
    end
  end

  def update_parsed_data
    parser = PageParser.new(url).fetch

    self.parsed_title = parser.title
    self.parsed_content = parser.content
    self.parsed_status_code = parser.status
    self.parsed_content_type = parser.content_type
    self.parsed_at = Time.now

    true
  end

  def index_user_pages
    user_pages.each do |user_page|
      user_page.__elasticsearch__.index_document
    end
  end

  def parsable?
    status_code == 200
  end

  def image_url
    if valid_extracted_image_url?
      extracted_image_url
    elsif valid_screenshot_url?
      screenshot_url
    end
  end

  def image_size_ratio
    if extracted_image_height && extracted_image_width
      extracted_image_height.to_f / extracted_image_width.to_f
    else
      # Not sure what the right default is here
      0
    end
  end

  def favicon_url(default_icon = nil)
    if extracted_favicon_url
      extracted_favicon_url
    else
      "https://getfavicon.appspot.com/#{CGI::escape(url)}?defaulticon=#{default_icon}"
    end
  end

  def content
    extracted_content || parsed_content
  end

  def summary
    extracted_description || extracted_lead
  end

  def published_at
    if extracted_published.present?
      @published_at ||= Time.at(extracted_published / 1000)
    end
  end

  def screenshot_url
    @screenshot_url ||= build_url2png_url
  end

  def watchable?
    extracted_media_type == 'video'
  end

  def readable?
    content.present?
  end

  def media_size_ratio
    if media_height && media_width
      media_height.to_f / media_width.to_f
    end
  end

  def interesting?
    parsable? && !search?
  end

  def search?
    url =~ /[?&#][pq]=/i
  end

  def hash_bang?
    url =~ /(#!)|(#(.*?)\/)/
  end

  def valid_extracted_image_url?
    parsable? &&
    extracted_image_url &&
    (extracted_image_entropy && extracted_image_entropy > MINIMUM_IMAGE_ENTROPY) &&
    !(url =~ EXTRACTED_IMAGE_DENY_PATTERN)
  end

  def valid_screenshot_url?
    parsable? && !(url =~ SCREENSHOT_DENY_PATTERN)
  end

  private

    def build_url2png_url(max_width = 500)
      query_string = "?url=#{CGI.escape(url)}&viewport=1280x800&thumbnail_max_width=#{max_width}"
      token = Digest::MD5.hexdigest("#{query_string}#{AppConfig.url2png.secret_key}")

      "http://api.url2png.com/v6/#{AppConfig.url2png.api_key}/#{token}/png/#{query_string}"
    end
end
