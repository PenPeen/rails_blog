# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GraphQL API', type: :request do
  describe 'POST /graphql' do
    let(:query) {
      <<~GRAPHQL
        query {
          __schema {
            queryType {
              name
            }
          }
        }
      GRAPHQL
    }

    it '200のレスポンスが返ること' do
      post '/graphql', params: { query: }
      expect(response).to have_http_status(:success)
    end
  end
end
