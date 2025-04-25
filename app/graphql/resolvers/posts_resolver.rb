# frozen_string_literal: true

module Resolvers
  class PostsResolver < GraphQL::Schema::Resolver
    include Resolvers::PaginationHelper

    type Types::PostsType, null: false
    description "Fetches a list of posts with pagination"

    argument :page, Integer, required: false, default_value: 1
    argument :per_page, Integer, required: false, default_value: 15

    def resolve(page:, per_page:)
      posts = Post.all_published_posts.page(page).per(per_page)
      {
        posts: posts,
        pagination: pagination(posts)
      }
    end
  end
end
