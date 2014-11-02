class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid do |t|
      t.string :fxa_id
      t.string :email
      t.string :name
      t.text :description
      t.string :oauth_token
      t.string :oauth_token_type

      t.timestamps
    end

    add_index :users, :fxa_id, unique: true
  end
end
