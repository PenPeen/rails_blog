# frozen_string_literal: true

module Types
  class PaginationType < Types::BaseObject
    field :current_page, Integer, null: true
    field :limit_value, Integer, null: true
    field :total_count, Integer, null: true # rubocop:disable GraphQL/ExtractType
    field :total_pages, Integer, null: true # rubocop:disable GraphQL/ExtractType
  end
end
