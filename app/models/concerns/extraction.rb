module Extraction
  extend ActiveSupport::Concern

  module ClassMethods
    def update_all_extracted_data
      Page.where('extracted_at IS NULL').each do |page|
        page.update_extracted_data!
      end
    end
  end

  # TODO: This should eventually consider cache time
  def should_update_extracted_data?
    !(url =~ /localhost/) && extracted_at.nil?
  end

  def update_extracted_data!
    update_extracted_data
    save! if changed?
  end

  def update_extracted_data
    return unless should_update_extracted_data?

    Rails.logger.info('Fetching extracted data from embedly')

    response = embedly.extract(url: url).first

    self.extracted_type = response.type
    self.extracted_title = response.title
    self.extracted_url = response.url
    self.extracted_description = response.description
    self.extracted_provider_url = response.provider_url

    # Get the first extracted author
    extract_author(response.authors)

    # Get first extracted image
    extract_image(response.images)

    self.extracted_provider_name = response.provider_name
    self.extracted_html = response.html
    self.extracted_height = response.height
    self.extracted_width = response.width
    self.extracted_provider_display = response.provider_display
    self.extracted_safe = response.safe
    self.extracted_content = response.content
    self.extracted_favicon_url = response.favicon_url

    # Get first extracted favicon color
    extract_favicon_colors(response.favicon_colors)

    self.extracted_language = response.language
    self.extracted_lead = response.lead
    self.extracted_cache_age = response.cache_age
    self.extracted_offset = response.offset
    self.extracted_published = response.published

    # Get media
    extract_media(response.media)

    # Create keywords, but get rid of them all first
    extract_keywords(response.keywords)

    # Create entities, but get rid of them all first
    extract_entities(response.entities)

    self.extracted_at = Time.now
  end

  private

    def extract_author(authors = nil)
      if authors && (author = authors.first)
        self.extracted_author_name = author['name']
        self.extracted_author_url = author['url']
      end
    end

    def extract_image(images = nil)
      if images && (image = images.first)
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
    end

    def extract_favicon_colors(favicon_colors = nil)
      if favicon_colors && (favicon_color = favicon_colors.first)
        self.extracted_favicon_color = rgb_to_hex(favicon_color['color'])
      end
    end

    def extract_media(media = nil)
      if media
        self.extracted_media_type = media.type
        self.extracted_media_html = media.html
        self.extracted_media_height = media.height
        self.extracted_media_width = media.width
        self.extracted_media_duration = media.duration
      end
    end

    def extract_keywords(keywords = nil)
      self.extracted_keywords.delete_all

      if keywords
        keywords.each do |k|
          self.extracted_keywords.create!(name: k['name'], score: k['score'])
        end
      end
    end

    def extract_entities(entities = nil)
      self.extracted_entities.delete_all

      if entities
        entities.each do |e|
          self.extracted_entities.create!(name: e['name'], count: e['count'])
        end
      end
    end

    def rgb_to_hex(rgb_array)
      hex = ''

      rgb_array.each { |n| hex += n.to_s(16).rjust(2, '0') }

      "##{hex}"
    end

    def embedly
      @embedly ||= Embedly::API.new(key: AppConfig.embedly.key)
    end
end
