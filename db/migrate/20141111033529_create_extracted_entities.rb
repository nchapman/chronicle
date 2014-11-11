class CreateExtractedEntities < ActiveRecord::Migration
  def change
    create_table :extracted_entities, id: :uuid do |t|
      t.uuid :page_id, null: false
      t.string :name
      t.integer :count

      t.timestamps null: false
    end

    add_foreign_key :extracted_entities, :pages
  end
end
