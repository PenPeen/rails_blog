# frozen_string_literal: true

module Resolvers
  module PaginationHelper
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
