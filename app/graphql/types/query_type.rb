# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description 'QueryType'

    field :current_user, Types::UserType,
      null: true,
      resolver: Resolvers::CurrentUserResolver,
      description: '現在のユーザー情報'

    field :my_post, Types::PostType,
      null: true,
      resolver: Resolvers::MyPostResolver,
      description: '自分の投稿'

    field :my_posts, Types::PostsType,
      null: false,
      resolver: Resolvers::MyPostsResolver,
      description: '自分の投稿一覧'

    field :published, Types::PublishedType,
      null: false,
      resolver: Resolvers::PublishedResolver,
      description: '公開済み投稿へのアクセス'

    field :post_comments, Types::CommentsType,
      null: false,
      resolver: Resolvers::PostCommentsResolver,
      description: '投稿のコメント一覧'

    field :node, resolver: Resolvers::NodeResolver,
      description: 'ノード'

    field :nodes, resolver: Resolvers::NodesResolver,
      description: 'ノード一覧'
  end
end
