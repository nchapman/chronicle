class RemoveParsedHtmlFromPages < ActiveRecord::Migration
  def change
    remove_column :pages, :parsed_html
  end
end
