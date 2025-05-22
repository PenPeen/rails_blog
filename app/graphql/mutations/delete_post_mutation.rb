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
    argument :id, ID, required: true

    field :errors, [Types::UserError], null: true
    field :message, String, null: true
    field :post, Types::PostType, null: true
    field :success, Boolean, null: true

    def resolve(id:)
      post = find_post(id)
      post.destroy!

      {
        post:,
        success: true,
        message: "投稿を削除しました。",
      }
    rescue ActiveRecord::RecordNotFound
      {
        success: false,
        message: "投稿が見つかりません。",
      }
    rescue => e
      {
        success: false,
        message: "削除に失敗しました。しばらく経ってから再度実行してください。",
      }
    end

    private
      def find_post(id)
        @post ||= context[:current_user].posts.find(id)
      end
  end
end
