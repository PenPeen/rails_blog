# frozen_string_literal: true

module Types
  class PublishedType < Types::BaseObject
    description "Published posts related fields"

    field :post, Types::PostType,
      null: true,
      resolver: Resolvers::PublishedPostResolver,
      description: '公開中の投稿データ'

    field :posts, Types::PostsType,
      null: false,
      resolver: Resolvers::PublishedPostsResolver,
      description: '公開中の投稿一覧'

    field :search_posts, Types::PostsType,
      null: false,
      resolver: Resolvers::PublishedSearchPostsResolver,
      description: '公開中の投稿一覧（検索用）'
  end
end
