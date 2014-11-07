module Extraction
  extend ActiveSupport::Concern

  def self.update_all_extracted_data
    Page.where('extracted_title IS NULL').each do |page|
      page.update_extracted_data!
    end
  end

  def update_extracted_data!
    # TODO: Where is the right place to check for this?
    unless url =~ /localhost/
      update_extracted_data
      save!
    end
  end

  def update_extracted_data
    # TODO: replace this with a more permanent solution
    return if url =~ /localhost/

    response = embedly.extract(url: url).first

    self.extracted_type = response.type
    self.extracted_title = response.title
    self.extracted_url = response.url
    self.extracted_description = response.description
    self.extracted_provider_url = response.provider_url

    # Get the first extracted author
    if response.authors && (author = response.authors.first)
      self.extracted_author_name = author['name']
      self.extracted_author_url = author['url']
    end

    # Get first extracted image
    if response.images && (image = response.images.first)
      self.extracted_image_url = image['url']
      self.extracted_image_width = image['width']
      self.extracted_image_height = image['height']
      self.extracted_image_caption = image['caption']
      self.extracted_image_entropy = image['entropy']

      # Get first extracted image color
      if image['colors'] && (image_color = image['colors'].first)
        self.extracted_image_color = rgb_to_hex(image_color['color'])
      end
    end

    self.extracted_provider_name = response.provider_name
    self.extracted_html = response.html
    self.extracted_height = response.height
    self.extracted_width = response.width
    self.extracted_provider_display = response.provider_display
    self.extracted_safe = response.safe
    self.extracted_content = response.content
    self.extracted_favicon_url = response.favicon_url

    # Get first extracted favicon color
    if response.favicon_colors && (favicon_color = response.favicon_colors.first)
      self.extracted_favicon_color = rgb_to_hex(favicon_color['color'])
    end

    self.extracted_language = response.language
    self.extracted_lead = response.lead
    self.extracted_cache_age = response.cache_age
    self.extracted_offset = response.offset
    self.extracted_published = response.published

    if response.media
      self.extracted_media_type = response.media.type
      self.extracted_media_html = response.media.html
      self.extracted_media_height = response.media.height
      self.extracted_media_width = response.media.width
      self.extracted_media_duration = response.media.duration
    end

    # Create keywords
    self.keywords.delete_all

    response.keywords.each do |k|
      self.keywords.create!(name: k['name'], score: k['score'])
    end

    # Create entities
    self.entities.delete_all

    response.entities.each do |e|
      self.entities.create!(name: e['name'], count: e['count'])
    end
  end

  def rgb_to_hex(rgb_array)
    hex = ''

    rgb_array.each { |n| hex += n.to_s(16).rjust(2, '0') }

    "##{hex}"
  end

  private

    def embedly
      @embedly ||= Embedly::API.new(key: Settings.embedly.key)
    end
end
