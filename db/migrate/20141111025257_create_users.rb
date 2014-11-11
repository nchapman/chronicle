class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid do |t|
      t.string :fxa_uid, null: false
      t.string :email, null: false
      t.string :name
      t.text :description
      t.string :oauth_token, null: false
      t.string :oauth_token_type, null: false

      t.timestamps null: false
    end

    add_index :users, :fxa_uid, unique: true
  end
end
