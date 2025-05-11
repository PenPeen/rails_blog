# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :current_user, resolver: Resolvers::CurrentUserResolver
    field :my_posts, resolver: Resolvers::MyPostsResolver
    field :node, resolver: Resolvers::NodeResolver
    field :nodes, resolver: Resolvers::NodesResolver
    field :post, resolver: Resolvers::PostResolver
    field :posts, resolver: Resolvers::PostsResolver
    field :search_posts, resolver: Resolvers::SearchPostsResolver
  end
end
