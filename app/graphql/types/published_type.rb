# frozen_string_literal: true

module Types
  class PublishedType < Types::BaseObject
    description "Published posts related fields"

    field :post, resolver: Resolvers::PublishedPostResolver
    field :posts, resolver: Resolvers::PublishedPostsResolver
    field :search_posts, resolver: Resolvers::PublishedSearchPostsResolver
  end
end
