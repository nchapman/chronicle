class Page < ActiveRecord::Base
  include Extraction

  # Constants
  MINIMUM_IMAGE_ENTROPY = 1.75
  EXTRACTED_IMAGE_DENY_PATTERN = /github.com|(\..{2,3}\/$)/
  SCREENSHOT_DENY_PATTERN = /localhost/

  # Relationships
  has_many :likes
  has_many :saves
  has_many :keywords
  has_many :entities

  # Validations
  validates :url, presence: true

  # This seems hacky but is reliable
  after_commit :post_process, if: Proc.new { previous_changes[:id] }

  # Always enqueue these methods to run in the background
  always_background :post_process

  # Alias the extracted attributes
  alias_attribute :title, :extracted_title
  alias_attribute :favicon_url, :extracted_favicon_url
  alias_attribute :provider_display, :extracted_provider_display
  alias_attribute :provider_name, :extracted_provider_name
  alias_attribute :provider_url, :extracted_provider_url
  alias_attribute :author_name, :extracted_author_name
  alias_attribute :media_type, :extracted_media_type
  alias_attribute :media_html, :extracted_media_html
  alias_attribute :content, :extracted_content
  alias_attribute :media_height, :extracted_media_height
  alias_attribute :media_width, :extracted_media_width

  # Clean up and normalize the URL
  normalize_attribute :url, with: [:strip, :blank] do |value|
    if value
      # Normalize URL to prevent unnecessary duplicates
      Addressable::URI.parse(value).normalize.to_s
    end
  end

  # Gather meta data for this page
  def post_process
    Rails.logger.info('Post processing page: ' + url)
    # Make sure we have the latest
    reload

    update_extracted_data!
  end

  def image_url
    if valid_extracted_image_url?
      extracted_image_url
    elsif valid_screenshot_url?
      screenshot_url
    end
  end

  def description
    extracted_lead || extracted_description
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

  def media_size_ratio
    media_height.to_f / media_width.to_f
  end

  private

    def valid_extracted_image_url?
      extracted_image_url &&
      extracted_image_entropy &&
      extracted_image_entropy > MINIMUM_IMAGE_ENTROPY &&
      !(url =~ EXTRACTED_IMAGE_DENY_PATTERN)
    end

    def valid_screenshot_url?
      !(url =~ SCREENSHOT_DENY_PATTERN)
    end

    def build_url2png_url(max_width = 500)
      query_string = "?url=#{CGI.escape(url)}&viewport=1280x800&thumbnail_max_width=#{max_width}"
      token = Digest::MD5.hexdigest("#{query_string}#{Settings.url2png.secret_key}")

      "http://api.url2png.com/v6/#{Settings.url2png.api_key}/#{token}/png/#{query_string}"
    end
end
