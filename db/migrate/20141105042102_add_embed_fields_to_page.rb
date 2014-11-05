class AddEmbedFieldsToPage < ActiveRecord::Migration
  def change
    add_column :pages, :embed_type, :string
    add_column :pages, :embed_title, :string
    add_column :pages, :embed_url, :string, limit: 2048
    add_column :pages, :embed_description, :text
    add_column :pages, :embed_provider_url, :string, limit: 2048
    add_column :pages, :embed_author_name, :string
    add_column :pages, :embed_author_url, :string, limit: 2048
    add_column :pages, :embed_thumbnail_url, :string, limit: 2048
    add_column :pages, :embed_thumbnail_width, :integer
    add_column :pages, :embed_thumbnail_height, :integer
    add_column :pages, :embed_provider_name, :string
    add_column :pages, :embed_html, :text
    add_column :pages, :embed_height, :integer
    add_column :pages, :embed_width, :integer
  end
end
