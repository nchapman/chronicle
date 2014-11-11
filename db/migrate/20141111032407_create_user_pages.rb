class CreateUserPages < ActiveRecord::Migration
  def change
    create_table :user_pages, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :page_id, null: false
      t.string :title, length: 2048
      t.text :description
      t.boolean :saved
      t.boolean :liked
      t.boolean :read
      t.datetime :saved_at
      t.datetime :liked_at
      t.datetime :read_at

      t.timestamps null: false
    end

    add_foreign_key :user_pages, :users
    add_foreign_key :user_pages, :pages
  end
end
