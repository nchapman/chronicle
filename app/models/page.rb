class Page < ActiveRecord::Base
  include Extraction

  MINIMUM_IMAGE_ENTROPY = 1.75
  FORCE_SCREENSHOT_PATTERN = /github.com|(\..{2,3}\/$)/

  has_many :likes
  has_many :saves
  has_many :keywords
  has_many :entities

  validates :url, presence: true

  after_commit :post_process, on: :create
  always_background :post_process

  normalize_attribute :url, with: [:strip, :blank] do |value|
    if value
      # Normalize URL to prevent unnecessary duplicates
      Addressable::URI.parse(value).normalize.to_s
    end
  end

  def post_process
    reload

    # TODO: Factor in cache time
    update_extracted_data! unless extracted_title.present?
  end

  def title
    extracted_title
  end

  def description
    extracted_description
  end

  def image_url
    if extracted_image_url && extracted_image_entropy && extracted_image_entropy > MINIMUM_IMAGE_ENTROPY && !(url =~ FORCE_SCREENSHOT_PATTERN)
      extracted_image_url
    else
      screenshot_url
    end
  end

  def published_at
    if extracted_published.present?
      @published_at ||= Time.at(extracted_published / 1000)
    end
  end

  def screenshot_url
    @screenshot_url ||= build_url2png_url
  end

  def build_url2png_url(max_width = 500)
    query_string = "?url=#{CGI.escape(url)}&viewport=1280x800&thumbnail_max_width=#{max_width}"
    token = Digest::MD5.hexdigest("#{query_string}#{Settings.url2png.secret_key}")

    "http://api.url2png.com/v6/#{Settings.url2png.api_key}/#{token}/png/#{query_string}"
  end
end
