# frozen_string_literal: true

module Resolvers
  class PostResolver < GraphQL::Schema::Resolver
    type Types::PostType, null: false
    description "Fetches a post by ID"

    argument :id, ID, required: true

    def resolve(id:)
      Post.find(id)
    end
  end
end
