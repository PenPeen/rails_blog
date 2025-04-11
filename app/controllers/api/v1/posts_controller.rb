module Api
  module V1
    class PostsController < Api::ApplicationController
      PER_PAGE = 10

      def index
        posts =
          if params[:user_id]
            Post.publish_posts_for_user(params[:user_id])
          else
            Post.all_published_posts
          end

        paginated_posts = posts.page(current_page).per(PER_PAGE)
        render json: paginated_posts.as_json(methods: [:thumbnail_url])
      end

      private
        def current_page
          params[:page] || 1
        end
    end
  end
end
