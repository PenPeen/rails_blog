# Usage:
=begin
query PostCommentsCursor($postId: ID!, $first: Int, $after: String) {
  PostCommentsCursor(postId: $postId, first: $first, after: $after) {
    edges {
      cursor
      node {
        id
        content
        user {
          id
          name
        }
        createdAt
      }
    }
    pageInfo {
      hasPreviousPage
      hasNextPage
      startCursor
      endCursor
    }
    totalCount
  }
}
=end

# frozen_string_literal: true

module Resolvers
  class PostCommentsCursorResolver < GraphQL::Schema::Resolver
    description '投稿に関連するコメント一覧取得する'

    type Types::CommentType.connection_type, null: false

    argument :post_id, ID, required: true, description: '投稿ID'

    def resolve(post_id:)
      post = Post.find_by(id: post_id)

      return [] unless post

      post.comments.order(created_at: :desc)
    end
  end
end
