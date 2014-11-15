namespace :import do
  desc "Imports Pinboard bookmarks for a given user"
  task pinboard: :environment do
    user = User.find(ENV['user_id'])
    bookmarks = JSON.parse(File.read(ENV['path']))

    bookmarks.each do |b|
      puts "Importing #{b['description']}"

      url = b['href']
      title = title
      description = b['extended'].present? ? b['extended'] : nil
      created_at = Time.parse(b['time'])

      begin
        user_page = user.user_pages.new({ url: url, title: title, description: description, created_at: created_at, liked: true })

        puts '   Already exists' unless user_page.save
      rescue
        puts "   Failed: #{$!}"
      end
    end
  end

end
