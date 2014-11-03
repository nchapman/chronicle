class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages, id: :uuid do |t|
      t.string :url

      t.timestamps
    end

    add_index :pages, :url, :unique: true
  end
end
