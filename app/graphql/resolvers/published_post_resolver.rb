# frozen_string_literal: true

# Usage
=begin
query PublishedPost($id: ID!) {
  publishedPost(id: $id) {
    id
    title
    content
  }
}
=end

module Resolvers
  class PublishedPostResolver < GraphQL::Schema::Resolver
    type Types::PostType, null: false
    description "Fetches a published post by ID"

    argument :id, ID, required: true

    def resolve(id:)
      Post.all_published_posts.find(id)
    end
  end
end
