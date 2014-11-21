class InterestingnessMachine
  def initialize(user_pages, distributions = { most: 0.05, very: 0.05, fairly: 0.10, mildly: 0.10 })
    @user_pages = user_pages
    @distributions = distributions
    @interesting_user_pages = {}
    @user_pages_distribution = {}
    @urls_distribution = {}

    @unique_distributions = {}

    calculate
  end

  def calculate
    sorted_user_pages.each do |user_page|
      @distributions.each_pair do |key, value|
        # Next distribution if this one is full
        next if distribution_quota_met?(key)

        # Distribute the user page unless we've already distributed one like it
        distribute_user_page(key, user_page) unless already_distributed?(user_page)

        # Next user_page
        break
      end
    end

    @urls_distribution.keys.sort.each do |k|
      puts k
      puts @urls_distribution[k].title
    end
  end

  def get_unique_distribution(external_key, user_page)
    distribution = get_distribution(user_page)

    if @unique_distributions[user_page] == external_key
      distribution
    elsif !@unique_distributions.has_key?(user_page)
      @unique_distributions[user_page] = external_key

      distribution
    else
      nil
    end
  end

  def uniquely_interesting?(external_key, user_page)
    !!(get_unique_distribution(external_key, user_page))
  end

  def get_distribution(user_page)
    @user_pages_distribution[user_page]
  end

  def interesting?(user_page)
    @user_pages_distribution.has_key?(user_page)
  end

  private

    def distribution_quota_met?(key)
      @interesting_user_pages[key] ||= []

      @interesting_user_pages[key].length >= (@user_pages.length * @distributions[key])
    end

    def sorted_user_pages
      @sorted_user_pages ||= @user_pages.sort { |a,b| b.interestingness <=> a.interestingness }
    end

    def distribute_user_page(key, user_page)
      @interesting_user_pages[key] ||= []
      @interesting_user_pages[key] << user_page

      @user_pages_distribution[user_page] = key
      @urls_distribution[normalize_url(user_page.url)] = user_page
    end

    def already_distributed?(user_page)
      @user_pages_distribution.has_key?(user_page) || @urls_distribution.has_key?(normalize_url(user_page.url))
      # Bail if we've already assigned this very user_page
      #return true if @user_pages_distribution[user_page]

      # Check to see if this URL has been distributed
      # @interesting_user_pages.each_pair do |k, user_pages|
      #   user_pages.each do |up|
      #     return true if normalize_url(up.url) == normalize_url(user_page.url)
      #   end
      # end

      # false
    end

    def normalize_url(url)
      @cached_normalized_urls ||= {}

      @cached_normalized_urls[url] ||= PostRank::URI.normalize(url).to_s
    end
end
