class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :page_id

      t.timestamps
    end

    add_index :visits, :user_id
    add_index :visits, :page_id
  end
end
