json.array!(@products) do |product|
  json.extract! product, :title, :description, :image_url, :price, :date_available
  json.url product_url(product, format: :json)
end
