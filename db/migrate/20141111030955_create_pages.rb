class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages, id: :uuid do |t|
      t.string :url, null: false
      t.string :extracted_type
      t.string :extracted_title
      t.string :extracted_url, limit: 2048
      t.text :extracted_description
      t.string :extracted_provider_url, limit: 2048
      t.string :extracted_author_name
      t.string :extracted_author_url, limit: 2048
      t.string :extracted_image_url, limit: 2048
      t.integer :extracted_image_width
      t.integer :extracted_image_height
      t.float :extracted_image_entropy
      t.text :extracted_image_caption
      t.string :extracted_image_color
      t.string :extracted_provider_name
      t.text :extracted_html
      t.integer :extracted_height
      t.integer :extracted_width
      t.string :extracted_provider_display
      t.boolean :extracted_safe
      t.text :extracted_content
      t.string :extracted_favicon_url, limit: 2048
      t.string :extracted_favicon_color
      t.string :extracted_language
      t.text :extracted_lead
      t.integer :extracted_cache_age
      t.integer :extracted_offset
      t.bigint :extracted_published
      t.string :extracted_media_type
      t.text :extracted_media_html
      t.integer :extracted_media_height
      t.integer :extracted_media_width
      t.integer :extracted_media_duration
      t.datetime :extracted_at

      t.timestamps null: false
    end

    add_index :pages, :url, unique: true
  end
end
