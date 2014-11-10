class ExtractedRecommendation < ActiveRecord::Base
  belongs_to :page
  belongs_to :recommended_page, class_name: 'Page'
end
