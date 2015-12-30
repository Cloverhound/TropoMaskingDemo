json.array!(@masks) do |mask|
  json.extract! mask, :id, :phone_number, :number_id
  json.url mask_url(mask, format: :json)
end
