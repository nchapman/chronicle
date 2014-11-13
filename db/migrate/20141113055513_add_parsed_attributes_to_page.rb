class AddParsedAttributesToPage < ActiveRecord::Migration
  def change
    add_column :pages, :parsed_title, :string
    add_column :pages, :parsed_html, :text
    add_column :pages, :parsed_content, :text
    add_column :pages, :parsed_status_code, :integer
    add_column :pages, :parsed_content_type, :string
    add_column :pages, :parsed_at, :datetime
  end
end
