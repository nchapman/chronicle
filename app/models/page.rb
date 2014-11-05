class Page < ActiveRecord::Base
  has_many :likes

  validates :url, presence: true

  normalize_attribute :url, with: [:strip, :blank]
end
