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
    type Types::PostType, null: true
    description "Fetches a published post by ID"

    argument :id, ID,
      required: true,
      description: '投稿ID'

    def resolve(id:)
      Post.all_published_posts.find_by(id:)
    end
  end
end
