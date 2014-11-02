json.array!(@users) do |user|
  json.extract! user, :id, :fxa_id, :email, :name, :description, :oauth_token
  json.url user_url(user, format: :json)
end
