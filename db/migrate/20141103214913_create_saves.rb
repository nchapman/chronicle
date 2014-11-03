class CreateSaves < ActiveRecord::Migration
  def change
    create_table :saves, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :page_id

      t.timestamps
    end

    add_index :saves, :user_id
    add_index :saves, :page_id
  end
end
