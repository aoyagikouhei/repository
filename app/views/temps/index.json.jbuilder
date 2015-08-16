json.array!(@temps) do |temp|
  json.extract! temp, :id
  json.url temp_url(temp, format: :json)
end
