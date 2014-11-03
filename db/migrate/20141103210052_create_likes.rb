class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :page_id
      t.string :title

      t.timestamps
    end

    add_index :likes, :user_id
    add_index :likes, :page_id
  end
end
