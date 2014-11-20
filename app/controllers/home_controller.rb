class HomeController < ApplicationController
  def index
    if current_user
      @visits = current_user
        .visits
        .joins({ user_page: :page })
        .where("pages.url NOT LIKE ? AND visits.created_at > ?", '%localhost%', 1.day.ago.to_date) # HACK: Exclude localhost for demos
        .includes({ user_page: :page })
        .order('visits.created_at desc')

      @machine = InterestingnessMachine.new(@visits.collect(&:user_page))
    end
  end
end
