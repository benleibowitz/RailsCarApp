json.array!(@cars) do |car|
  json.extract! car, :id, :year, :make, :model, :price
  json.url car_url(car, format: :json)
end
