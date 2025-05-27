# frozen_string_literal: true

# Usage
=begin
query{
  myPosts(page: 1, perPage: 3) {
    posts{
      id
      title
    }
  }
}
=end

module Resolvers
  class MyPostsResolver < LoginRequiredResolver
    include Resolvers::PaginationHelper

    type Types::PostsType, null: false
    description "Fetches a list of posts created by the current user"

    argument :page, Integer,
      required: false,
      default_value: 1,
      description: 'ページ番号'

    argument :per_page, Integer,
      required: false,
      default_value: 15,
      description: '1ページあたりの表示件数'

    def resolve(page:, per_page:)
      current_user = context[:current_user]
      posts = current_user.posts.page(page).per(per_page)

      {
        posts:,
        pagination: pagination(posts)
      }
    end
  end
end
