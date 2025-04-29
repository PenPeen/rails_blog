# frozen_string_literal: true

# Usage
=begin
query SearchPosts($title: String!) {
  searchPosts(title: $title) {
    posts {
      id
      title
    }
  }
}
=end

module Resolvers
  class SearchPostsResolver < GraphQL::Schema::Resolver
    include Resolvers::PaginationHelper

    type Types::PostsType, null: false
    description "Searches posts by title"

    argument :title, String, required: true
    argument :page, Integer, required: false, default_value: 1
    argument :per_page, Integer, required: false, default_value: 15

    def resolve(title:, page:, per_page:)
      posts = Post.search_by_title(title).page(page).per(per_page)
      {
        posts: posts,
        pagination: pagination(posts)
      }
    end
  end
end
