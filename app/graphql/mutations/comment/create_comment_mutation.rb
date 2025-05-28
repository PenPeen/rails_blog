# frozen_string_literal: true

module Mutations
  module Comment
    class CreateCommentMutation < Mutations::LoginRequiredMutation
      description '投稿に関連するコメントを作成する'

      argument :post_id, ID,
        required: true,
        description: '投稿ID'

      argument :content, String,
        required: true,
        description: 'コメント内容'

      field :comment, Types::CommentType,
        null: true,
        description: '作成されたコメント'

      field :errors, [Types::UserError],
        null: true,
        description: 'エラー情報'

      def resolve(post_id:, content:)
        result = CreateCommentService.new(
          user: context[:current_user],
          post_id: post_id,
          content: content
        ).call

        {
          comment: result.comment,
          errors: result.errors
        }
      end
    end
  end
end
