# frozen_string_literal: true

module Resolvers
  class PublishedResolver < GraphQL::Schema::Resolver
    type Types::PublishedType, null: false
    description "Access to published posts functionality"

    def resolve
      {}  # 空のハッシュを返す
    end
  end
end
