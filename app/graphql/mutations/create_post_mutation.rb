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
    argument :post_input, Types::CreatePostInputType, required: true

    field :errors, [Types::UserError], null: true
    field :message, String, null: true
    field :post, Types::PostType, null: true

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
