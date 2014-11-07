class AddExtractedImageEntropyToPage < ActiveRecord::Migration
  def change
    add_column :pages, :extracted_image_entropy, :float
  end
end
