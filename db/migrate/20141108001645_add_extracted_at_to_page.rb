class AddExtractedAtToPage < ActiveRecord::Migration
  def change
    add_column :pages, :extracted_at, :datetime
  end
end
