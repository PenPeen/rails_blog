module Api
  module V1
    class PostsController < Api::ApplicationController
      PER_PAGE = 10

      def index
        posts =
          if params[:user_id].present?
            Post.publish_posts_for_user(params[:user_id])
          else
            Post.all_published_posts
          end

        paginated_posts = posts.page(current_page).per(PER_PAGE)
        render json: paginated_posts, meta: pagination_meta(paginated_posts)
      end

      private
        def current_page
          params[:page] || 1
        end

        def pagination_meta(paginated_records)
          {
            current_page: paginated_records.current_page,
            next_page: paginated_records.next_page,
            prev_page: paginated_records.prev_page,
            total_pages: paginated_records.total_pages,
            total_count: paginated_records.total_count
          }
        end
    end
  end
end
