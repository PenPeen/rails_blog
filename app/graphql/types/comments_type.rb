# frozen_string_literal: true

module Types
  class CommentsType < Types::BaseObject
    description 'コメント一覧'

    field :comments, [Types::CommentType],
      null: false,
      description: 'コメント一覧'

    field :count, Integer,
      null: false,
      description: 'コメント数'
  end
end
