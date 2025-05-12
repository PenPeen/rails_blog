# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, resolver: Resolvers::NodeResolver
    field :nodes, resolver: Resolvers::NodesResolver
    field :current_user, resolver: Resolvers::CurrentUserResolver
    field :posts, resolver: Resolvers::PostsResolver
    field :my_posts, resolver: Resolvers::MyPostsResolver
    field :post, resolver: Resolvers::PostResolver
    field :search_posts, resolver: Resolvers::SearchPostsResolver

    field :test, String, null: false
    def test
      "test"
    end
  end
end
