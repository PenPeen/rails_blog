# frozen_string_literal: true

module Types
  class PostsType < Types::BaseObject
    description '投稿一覧情報を返す'

    field :pagination, PaginationType,
      null: true,
      description: 'ページネーション情報'

    field :posts, [PostType],
      null: true,
      description: '投稿一覧'
  end
end
