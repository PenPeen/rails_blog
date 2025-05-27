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
    type Types::PostType, null: true
    description "Fetches a post created by the current user"

    argument :id, ID,
      required: true,
      description: '投稿ID'

    def resolve(id:)
      current_user = context[:current_user]
      current_user.posts.find_by(id:)
    end
  end
end
