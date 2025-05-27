# frozen_string_literal: true

# Usage
=begin
query PublishedPosts {
  published {
    posts(page: 1, perPage: 3) {
      posts {
        id
        title
      }
    }
  }
}
=end

module Resolvers
  class PublishedPostsResolver < GraphQL::Schema::Resolver
    include Resolvers::PaginationHelper

    type Types::PostsType, null: false
    description "Fetches a list of published posts with pagination"

    argument :page, Integer,
      required: false,
      default_value: 1,
      description: 'ページ番号'

    argument :per_page, Integer,
      required: false,
      default_value: 15,
      description: '1ページあたりの表示件数'

    def resolve(page:, per_page:)
      posts = Post.all_published_posts.page(page).per(per_page)
      {
        posts:,
        pagination: pagination(posts)
      }
    end
  end
end
