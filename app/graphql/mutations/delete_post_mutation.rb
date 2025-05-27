# frozen_string_literal: true

# Usage
=begin
mutation DeletePost($input: DeletePostInputType!) {
  deletePost(input: $input) {
    success
    post {
      id
      title
      content
    }
    message
    errors {
      message
      path
    }
  }
}
=end

module Mutations
  class DeletePostMutation < LoginRequiredMutation
    description '投稿削除'

    argument :id, ID,
      required: true,
      description: '投稿ID'

    field :errors, [Types::UserError],
      null: true,
      description: 'エラー情報'

    field :message, String,
      null: true,
      description: 'メッセージ'

    field :post, Types::PostType,
      null: true,
      description: '投稿情報'

    field :success, Boolean,
      null: true,
      description: '成功フラグ'

    def resolve(id:)
      result = DeletePostService.new(
        user: context[:current_user],
        post_id: id
      ).call

      {
        post: result.post,
        success: result.success,
        message: result.message,
        errors: result.errors
      }
    end
  end
end
