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
      begin
        service = PostCreationService.new(
          user: context[:current_user],
          attributes: post_input.to_h.except(:thumbnail),
          thumbnail: post_input.thumbnail
        )

        begin
          created_post = service.call

          {
            post: created_post,
            message: "投稿が完了しました。",
          }
        rescue ActiveRecord::RecordInvalid => e
          post_errors = e.record.errors.map do |error|
            {
              message: error.full_message,
              path: ["postInput", error.attribute.to_s]
            }
          end

          { errors: post_errors }
        end
      rescue => e
        {
          errors: [
            { message: "投稿に失敗しました。#{e.message}" }
          ]
        }
      end
    end
  end
end
