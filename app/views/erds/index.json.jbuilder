json.array!(@erds) do |erd|
  json.extract! erd, :id
  json.url erd_url(erd, format: :json)
end
