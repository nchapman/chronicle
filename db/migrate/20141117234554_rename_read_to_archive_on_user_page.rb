class RenameReadToArchiveOnUserPage < ActiveRecord::Migration
  def change
    rename_column :user_pages, :read, :archived
    rename_column :user_pages, :read_at, :archived_at
  end
end
