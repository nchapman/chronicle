class Page < ActiveRecord::Base
  has_many :likes

  validates :url, presence: true

  normalize_attribute :url, with: [:strip, :blank] do |value|
    if value
      # Normalize URL to prevent unnecessary duplicates
      Addressable::URI.parse(value).normalize.to_s
    end
  end
end
