namespace :user_pages do
  task reindex: :environment do
    UserPage.__elasticsearch__.create_index!(force: true)
    UserPage.import
  end
end
