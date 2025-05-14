# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :current_user, resolver: Resolvers::CurrentUserResolver
    field :my_posts, resolver: Resolvers::MyPostsResolver
    field :node, resolver: Resolvers::NodeResolver
    field :nodes, resolver: Resolvers::NodesResolver
    field :current_user, resolver: Resolvers::CurrentUserResolver
    field :published_posts, resolver: Resolvers::PublishedPostsResolver
    field :my_posts, resolver: Resolvers::MyPostsResolver
    field :published_post, resolver: Resolvers::PublishedPostResolver
    field :published_search_posts, resolver: Resolvers::PublishedSearchPostsResolver
  end
end
