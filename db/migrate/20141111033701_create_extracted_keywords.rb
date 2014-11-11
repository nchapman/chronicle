class CreateExtractedKeywords < ActiveRecord::Migration
  def change
    create_table :extracted_keywords, id: :uuid do |t|
      t.uuid :page_id, null: false
      t.string :name
      t.float :score

      t.timestamps null: false
    end

    add_foreign_key :extracted_keywords, :pages
  end
end
