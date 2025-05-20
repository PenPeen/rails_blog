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

    field :message, String, null: true
    field :post, Types::PostType, null: true
    field :errors, [Types::UserError], null: true

    def resolve(post_input:)
      begin
        post = find_post(post_input.id)

        if post.update(post_input.to_h)
          {
            post:,
            message: "更新が完了しました。",
          }
        else
          post_errors = post.errors.map do |error|
            {
              message: error.full_message,
              path: ["postInput", error.attribute.to_s]
            }
          end

          { errors: post_errors }
        end
      rescue ActiveRecord::RecordNotFound
        {
          errors: [
            {
              message: "投稿が見つかりません。",
              path: ["postInput", "id"]
            }
          ]
        }
      rescue => e
        {
          errors: [
            { message: "更新に失敗しました。#{e.message}" }
          ]
        }
      end
    end

    private
      def find_post(id)
        @post ||= Post.find(id)
      end
  end
end
