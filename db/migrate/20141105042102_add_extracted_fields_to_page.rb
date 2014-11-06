class AddExtractedFieldsToPage < ActiveRecord::Migration
  def change
    add_column :pages, :extracted_type, :string
    add_column :pages, :extracted_title, :string
    add_column :pages, :extracted_url, :string, limit: 2048
    add_column :pages, :extracted_description, :text
    add_column :pages, :extracted_provider_url, :string, limit: 2048
    add_column :pages, :extracted_author_name, :string
    add_column :pages, :extracted_author_url, :string, limit: 2048
    add_column :pages, :extracted_image_url, :string, limit: 2048
    add_column :pages, :extracted_image_width, :integer
    add_column :pages, :extracted_image_height, :integer
    add_column :pages, :extracted_image_caption, :text
    add_column :pages, :extracted_image_color, :string
    add_column :pages, :extracted_provider_name, :string
    add_column :pages, :extracted_html, :text
    add_column :pages, :extracted_height, :integer
    add_column :pages, :extracted_width, :integer
    add_column :pages, :extracted_provider_display, :string
    add_column :pages, :extracted_safe, :boolean
    add_column :pages, :extracted_content, :text
    add_column :pages, :extracted_favicon_url, :string, limit: 2048
    add_column :pages, :extracted_favicon_color, :string
    add_column :pages, :extracted_language, :string
    add_column :pages, :extracted_lead, :text
    add_column :pages, :extracted_cache_age, :integer
    add_column :pages, :extracted_offset, :integer
    add_column :pages, :extracted_published, :bigint
    add_column :pages, :extracted_media_type, :string
    add_column :pages, :extracted_media_html, :text
    add_column :pages, :extracted_media_height, :integer
    add_column :pages, :extracted_media_width, :integer
    add_column :pages, :extracted_media_duration, :integer
  end
end
