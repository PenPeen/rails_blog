# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, resolver: Resolvers::NodeResolver
    field :nodes, resolver: Resolvers::NodesResolver
    field :current_user, resolver: Resolvers::CurrentUserResolver
    field :posts, resolver: Resolvers::PostsResolver
    field :post, resolver: Resolvers::PostResolver
    field :search_posts, resolver: Resolvers::SearchPostsResolver
  end
end
