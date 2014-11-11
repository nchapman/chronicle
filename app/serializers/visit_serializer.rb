class VisitSerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :user_page
end
