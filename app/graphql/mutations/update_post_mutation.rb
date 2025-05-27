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
  class UpdatePostMutation < LoginRequiredMutation
    argument :post_input, Types::PostInputType, required: true

    field :errors, [Types::UserError], null: true
    field :message, String, null: true
    field :post, Types::PostType, null: true

    def resolve(post_input:)
      result = UpdatePostService.new(
        post_id: post_input.id,
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
