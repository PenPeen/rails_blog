# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :current_user, Types::UserType, null: true, resolver: Resolvers::CurrentUserResolver
    field :my_post, Types::PostType, null: true, resolver: Resolvers::MyPostResolver
    field :my_posts, [Types::PostType], null: false, resolver: Resolvers::MyPostsResolver
    field :node, resolver: Resolvers::NodeResolver
    field :nodes, resolver: Resolvers::NodesResolver
    field :published, Types::PublishedType, resolver: Resolvers::PublishedResolver
  end
end
