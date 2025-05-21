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
      begin
        post = find_post(post_input.id)

        # サービスクラスを使用して投稿を更新
        service = PostUpdateService.new(
          post: post,
          attributes: post_input.to_h.except(:id, :thumbnail),
          thumbnail: post_input.thumbnail
        )

        begin
          updated_post = service.call

          {
            post: updated_post,
            message: "更新が完了しました。",
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
