# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :current_user, resolver: Resolvers::CurrentUserResolver
    field :my_posts, resolver: Resolvers::MyPostsResolver
    field :node, resolver: Resolvers::NodeResolver
    field :nodes, resolver: Resolvers::NodesResolver
    field :published, Types::PublishedType, resolver: Resolvers::PublishedResolver
  end
end
