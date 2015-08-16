json.array!(@kbns) do |kbn|
  json.extract! kbn, :id
  json.url kbn_url(kbn, format: :json)
end
