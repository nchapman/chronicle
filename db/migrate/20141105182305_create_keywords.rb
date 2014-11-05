class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords, id: :uuid do |t|
      t.uuid :page_id
      t.string :name
      t.float :score

      t.timestamps
    end

    add_index :keywords, :page_id
    add_index :keywords, :name
  end
end
