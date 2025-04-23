# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    field :posts, Types::PostsType, null: false do
      argument :page, Integer, required: false, default_value: 1
      argument :per_page, Integer, required: false, default_value: 15
    end

    def posts(page:, per_page:)
      posts = Post.all_published_posts.page(page).per(per_page)
      {
        posts: posts,
        pagination: pagination(posts)
      }
    end

    field :post, Types::PostType, null: false do
      argument :id, ID, required: true
    end

    def post(id:)
      Post.find(id)
    end

    private
      def pagination(result)
        {
          total_count: result.total_count,
          limit_value: result.limit_value,
          total_pages: result.total_pages,
          current_page: result.current_page
        }
      end
  end
end
