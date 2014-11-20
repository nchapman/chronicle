class InterestingnessMachine
  def initialize(user_pages, percent = 0.3)
    @user_pages = user_pages
    @percent = percent

    @most_interesting_user_pages = []

    calculate
  end

  def calculate
    sorted_user_pages = @user_pages.sort { |a,b| b.interestingness <=> a.interestingness }

    i = 0

    while @most_interesting_user_pages.length < (@percent * @user_pages.length)
      user_page = sorted_user_pages[i]

      unless most_interesting_url?(user_page.url)
        @most_interesting_user_pages << user_page
      end

      i += 1
    end

    @most_interesting_user_pages.each { |up| puts [up.id, up.title, up.url].inspect }
  end

  def most_interesting?(user_page)
    !!@most_interesting_user_pages.delete(user_page)
  end

  private

    def most_interesting_url?(url)
      @most_interesting_user_pages.find { |up| normalize_url(up.url) == normalize_url(url) }
    end

    def normalize_url(url)
      @cached_normalized_urls ||= {}

      @cached_normalized_urls[url] ||= PostRank::URI.normalize(url)
    end
end
