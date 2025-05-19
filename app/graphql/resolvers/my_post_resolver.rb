# frozen_string_literal: true

# Usage
=begin
query{
  myPost(id: 1) {
    post{
      id
      title
      content
      published
    }
  }
}
=end

module Resolvers
  class MyPostResolver < LoginRequiredResolver
    type Types::PostType, null: false
    description "Fetches a post created by the current user"

    argument :id, ID, required: true

    def resolve(id:)
      current_user = context[:current_user]
      post = current_user.posts.find_by(id:)

      if post
        post
      else
        raise GraphQL::ExecutionError, "Post not found"
      end
    end
  end
end
