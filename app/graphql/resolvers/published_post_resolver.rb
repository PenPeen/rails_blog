# frozen_string_literal: true

# Usage
=begin
query PublishedPost($id: ID!) {
  published {
    post(id: $id) {
      id
      title
      content
    }
  }
}
=end

module Resolvers
  class PublishedPostResolver < GraphQL::Schema::Resolver
    type Types::PostType, null: false
    description "Fetches a published post by ID"

    argument :id, ID, required: true

    def resolve(id:)
      post = Post.all_published_posts.find_by(id:)
      raise GraphQL::ExecutionError, "Post not found" unless post

      post
    end
  end
end
