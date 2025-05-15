# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Published Query', type: :request do
  describe 'published' do
    let(:query_string) do
      <<~GRAPHQL
        query Published {
          published {
            __typename
          }
        }
      GRAPHQL
    end

    it 'PublishedTypeを返すこと' do
      result = MyappSchema.execute(query_string)

      data = result['data']['published']
      expect(data).to be_present
      expect(data['__typename']).to eq('Published')
    end
  end
end
