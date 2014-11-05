class CreateEntities < ActiveRecord::Migration
  def change
    create_table :entities, id: :uuid do |t|
      t.uuid :page_id
      t.string :name
      t.integer :count

      t.timestamps
    end

    add_index :entities, :page_id
    add_index :entities, :name
  end
end
