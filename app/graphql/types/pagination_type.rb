# frozen_string_literal: true

module Types
  class PaginationType < Types::BaseObject
    field :total_count, Integer, null: true
    field :limit_value, Integer, null: true
    field :total_pages, Integer, null: true
    field :current_page, Integer, null: true
  end
end
