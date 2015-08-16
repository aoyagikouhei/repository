json.array!(@errs) do |err|
  json.extract! err, :id
  json.url err_url(err, format: :json)
end
