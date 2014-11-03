json.array!(@likes) do |like|
  json.extract! like, :id, :user_id, :page_id, :title
  json.url like_url(like, format: :json)
end
