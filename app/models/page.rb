class Page < ActiveRecord::Base
  include Extraction

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
    extracted_image_url
  end

  def published_at
    if extracted_published.present?
      @published_at ||= Time.at(extracted_published / 1000)
    end
  end
end
