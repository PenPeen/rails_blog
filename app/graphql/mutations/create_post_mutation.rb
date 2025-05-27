# frozen_string_literal: true

# Usage
=begin
mutation CreatePost($input: CreatePostMutationInput!) {
  createPost(input: $input) {
    post {
      id
      title
      content
      published
      thumbnailUrl
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
  class CreatePostMutation < LoginRequiredMutation
    description '投稿作成'

    argument :post_input, Types::CreatePostInputType,
      required: true,
      description: '入力値'

    field :errors, [Types::UserError], null: true,
      description: 'エラー情報'

    field :message, String,
      null: true,
      description: 'メッセージ'

    field :post, Types::PostType,
      null: true,
      description: '作成された投稿'

    def resolve(post_input:)
      result = CreatePostService.new(
        user: context[:current_user],
        attributes: post_input.to_h.except(:thumbnail),
        thumbnail: post_input.thumbnail
      ).call

      {
        post: result.post,
        message: result.message,
        errors: result.errors
      }
    end
  end
end
