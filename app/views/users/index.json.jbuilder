json.array!(@users) do |user|
  json.extract! user, :id, :fxa_uid, :email, :name, :description, :oauth_token, :oauth_token_type
  json.url user_url(user, format: :json)
end
