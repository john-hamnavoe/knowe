
class Filter < AllFutures::Base
  # Facets
  attribute :query, :json

  # Pagination
  attribute :items, :integer, default: 10
  attribute :page, :integer, default: 1

  # Sorting
  attribute :sort, :string, default: ""
end