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
