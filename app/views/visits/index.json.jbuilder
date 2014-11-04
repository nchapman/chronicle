json.array!(@visits) do |visit|
  json.extract! visit, :id, :user_id, :page_id
  json.url visit_url(visit, format: :json)
end
