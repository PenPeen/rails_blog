# frozen_string_literal: true

module Types
  class BaseConnection < Types::BaseObject
    # add `nodes` and `pageInfo` fields, as well as `edge_type(...)` and `node_nullable(...)` overrides
    include GraphQL::Types::Relay::ConnectionBehaviors

    field :total_count, Integer, null: false, description: '総件数'
    field :current_page, Integer, null: false, description: '現在のページ'
    field :total_page, Integer, null: false, description: '総ページ数'

    def total_count
      object.items&.size || 0
    end

    def current_page
      return 1 unless paginated?

      if object.after
        offset = decode_cursor(object.after) + 1
        (offset.to_f / per_page).ceil
      else
        1
      end
    end

    def total_page
      return 1 unless paginated?

      count = total_count
      (count.to_f / per_page).ceil
    end

    private
      def decode_cursor(cursor)
        Base64.decode64(cursor).sub('arrayconnection:', '').to_i
      end

      def paginated?
        per_page > 0
      end

      def per_page
        return @per_page if defined?(@per_page)
        @per_page = object.first || object.last || 0
      end
  end
end
