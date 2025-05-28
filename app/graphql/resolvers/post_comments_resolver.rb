# frozen_string_literal: true

module Resolvers
  class PostCommentsResolver < GraphQL::Schema::Resolver
    description '投稿に関連するコメント一覧取得する'

    type Types::CommentsType, null: false

    argument :post_id, ID, required: true, description: '投稿ID'

    def resolve(post_id:)
      post = Post.find_by(id: post_id)

      return { comments: [], count: 0 } unless post

      comments = post.comments.order(created_at: :desc)

      {
        comments: comments,
        count: comments.size
      }
    end
  end
end
