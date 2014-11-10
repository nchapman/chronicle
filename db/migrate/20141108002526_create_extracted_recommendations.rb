class CreateExtractedRecommendations < ActiveRecord::Migration
  def change
    create_table :extracted_recommendations, id: :uuid do |t|
      t.uuid :page_id
      t.uuid :recommended_page_id
      t.float :score

      t.timestamps
    end

    add_index :extracted_recommendations, :page_id
    add_index :extracted_recommendations, :recommended_page_id

    add_column :pages, :should_extract_recommendations, :boolean, default: false
  end
end
