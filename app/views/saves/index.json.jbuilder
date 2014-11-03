json.array!(@saves) do |safe|
  json.extract! safe, :id, :user_id, :page_id
  json.url save_url(safe, format: :json)
end
