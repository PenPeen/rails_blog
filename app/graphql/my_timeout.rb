# frozen_string_literal: true

class MyTimeout < GraphQL::Schema::Timeout
  def handle_timeout(error, query)
    Rails.logger.warn("GraphQL Timeout: #{error.message}: #{query.query_string}")
    # Bugsnag.notify(error, {query_string: query.query_string})
  end
end
