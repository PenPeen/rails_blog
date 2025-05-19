# frozen_string_literal: true

# Usage
=begin
mutation UpdatePost($input: UpdatePostMutationInput!) {
  updatePost(input: $input) {
    post {
      id
      title
      content
      published
    }
  }
}
=end

module Mutations
  class UpdatePostMutation < LoginRequiredMutation
    argument :post_input, Types::PostInputType, required: true

    field :post, Types::PostType, null: false
    field :message, String, null: false

    def resolve(post_input:)
      post = find_post(post_input.id)

      if post.update(post_input.to_h)
        {
          post:,
          message: "更新が完了しました。"
        }
      else
        raise GraphQL::ExecutionError.new(
          "更新に失敗しました。\n#{post.errors.full_messages.join("\n")}"
        )
      end
    rescue => e
      raise GraphQL::ExecutionError.new(
        "更新に失敗しました。\n#{e.message}"
      )
    end

    private
      def find_post(id)
        @post ||= Post.find(id)
      rescue ActiveRecord::RecordNotFound
        raise GraphQL::ExecutionError.new(
          "投稿が見つかりません。"
        )
      end
  end
end
