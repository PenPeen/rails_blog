# frozen_string_literal: true

module Types
  class PublishedType < Types::BaseObject
    description "Published posts related fields"

    field :post, Types::PostType, null: true, resolver: Resolvers::PublishedPostResolver
    field :posts, [Types::PostType], null: false, resolver: Resolvers::PublishedPostsResolver
    field :search_posts, [Types::PostType], null: false, resolver: Resolvers::PublishedSearchPostsResolver
  end
end
