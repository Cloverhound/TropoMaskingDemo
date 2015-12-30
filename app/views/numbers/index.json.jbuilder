json.array!(@numbers) do |number|
  json.extract! number, :id, :phone_number, :masks
  json.url number_url(number, format: :json)
end
