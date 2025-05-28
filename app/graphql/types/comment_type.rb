# frozen_string_literal: true

module Types
  class CommentType < Types::BaseObject
    description 'コメント情報'

    field :content, String,
      null: false,
      description: 'コメント内容'

    field :created_at, GraphQL::Types::ISO8601DateTime,
      null: false,
      description: '作成日時'

    field :id, ID,
      null: false,
      description: 'コメントID'

    field :post, Types::PostType,
      null: false,
      description: '投稿'

    field :updated_at, GraphQL::Types::ISO8601DateTime,
      null: false,
      description: '更新日時'

    field :user, Types::UserType,
      null: false,
      description: 'コメント投稿者'
  end
end
