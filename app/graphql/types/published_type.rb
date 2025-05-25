# frozen_string_literal: true

module Types
  class PublishedType < Types::BaseObject
    description "Published posts related fields"

    field :post, Types::PostType, null: true, resolver: Resolvers::PublishedPostResolver
    field :posts, Types::PostsType, null: false, resolver: Resolvers::PublishedPostsResolver
    field :search_posts, Types::PostsType, null: false, resolver: Resolvers::PublishedSearchPostsResolver
  end
end
