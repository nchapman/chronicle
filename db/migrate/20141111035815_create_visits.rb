class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :user_page_id, null: false

      t.timestamps null: false
    end

    add_foreign_key :visits, :users
    add_foreign_key :visits, :user_pages
  end
end
