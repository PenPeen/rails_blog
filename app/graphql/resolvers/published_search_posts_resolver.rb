# frozen_string_literal: true

# Usage
=begin
query PublishedSearchPosts($title: String!) {
  published {
    searchPosts(title: $title) {
      posts {
        id
        title
      }
    }
  }
}
=end

module Resolvers
  class PublishedSearchPostsResolver < GraphQL::Schema::Resolver
    include Resolvers::PaginationHelper

    type Types::PostsType, null: false
    description "Searches published posts by title"

    argument :page, Integer,
      required: false,
      default_value: 1,
      description: 'ページ番号'

    argument :per_page, Integer,
      required: false,
      default_value: 15,
      description: '1ページあたりの表示件数'

    argument :title, String,
      required: true,
      description: '検索文字列'

    def resolve(title:, page:, per_page:)
      posts = Post.all_published_posts.search_by_title(title).page(page).per(per_page)
      {
        posts:,
        pagination: pagination(posts)
      }
    end
  end
end
