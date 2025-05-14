# frozen_string_literal: true

# Usage
=begin
query PublishedSearchPosts($title: String!) {
  publishedSearchPosts(title: $title) {
    posts {
      id
      title
    }
  }
}
=end

module Resolvers
  class PublishedSearchPostsResolver < GraphQL::Schema::Resolver
    include Resolvers::PaginationHelper

    type Types::PostsType, null: false
    description "Searches published posts by title"

    argument :page, Integer, required: false, default_value: 1
    argument :per_page, Integer, required: false, default_value: 15
    argument :title, String, required: true

    def resolve(title:, page:, per_page:)
      posts = Post.all_published_posts.search_by_title(title).page(page).per(per_page)
      {
        posts: posts,
        pagination: pagination(posts)
      }
    end
  end
end
