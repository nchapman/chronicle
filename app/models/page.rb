class Page < ActiveRecord::Base
  has_many :likes

  validates :url, presence: true

  normalize_attribute :url, with: [:strip, :blank] do |value|
    if value
      # Normalize URL to prevent unnecessary duplicates
      Addressable::URI.parse(value).normalize.to_s
    end
  end

  def self.post_process(id)
    find(id).post_process!
  end

  def post_process!
    update_embed

    save!
  end

  def update_embed
    # TODO: replace this with a more permanent solution
    return if url =~ /localhost/

    response = embedly.oembed(url: url).first

    self.embed_type = response.type
    self.embed_title = response.title
    self.embed_url = response.url
    self.embed_description = response.description
    self.embed_provider_url = response.provider_url
    self.embed_author_name = response.author_name
    self.embed_author_url = response.author_url
    self.embed_thumbnail_url = response.thumbnail_url
    self.embed_thumbnail_width = response.thumbnail_width
    self.embed_thumbnail_height = response.thumbnail_height
    self.embed_provider_name = response.provider_name
    self.embed_html = response.html
    self.embed_height = response.height
    self.embed_width = response.width
  end

  def title
    embed_title
  end

  def description
    embed_title
  end

  private

    def embedly
      @embedly ||= Embedly::API.new(key: ENV['EMBEDLY_KEY'])
    end
end
