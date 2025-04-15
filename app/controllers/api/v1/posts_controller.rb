module Api
  module V1
    class PostsController < Api::ApplicationController
      PER_PAGE = 10

      def index
        posts = Post.all_published_posts

        paginated_posts = posts.page(current_page).per(PER_PAGE)
        render json: paginated_posts.as_json(methods: [:thumbnail_url])
      end

      def show
        post = Post.all_published_posts.find(params[:id])
        render json: post.as_json(methods: [:thumbnail_url])
      end

      private
        def current_page
          params[:page] || 1
        end
    end
  end
end
