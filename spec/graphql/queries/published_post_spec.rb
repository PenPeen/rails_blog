# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PublishedPost Query', type: :request do
  describe 'published_post' do
    let(:query_string) do
      <<~GRAPHQL
        query PublishedPost($id: ID!) {
          published {
            post(id: $id) {
              id
              title
              content
            }
          }
        }
      GRAPHQL
    end

    let(:user) { create(:user) }
    let!(:published_post) { create(:post, user:, published: true) }
    let!(:unpublished_post) { create(:post, user:, published: false) }
    let(:post_id) { published_post.id }
    let(:variables) { { id: post_id } }
    let(:result) { MyappSchema.execute(query_string, variables:) }
    let(:data) { result['data'] && result['data']['published'] && result['data']['published']['post'] }
    let(:errors) { result['errors'] }

    context '公開済み投稿の場合' do
      it '投稿の詳細を返すこと' do
        expect(data).to be_present
        expect(data['id']).to eq(published_post.id.to_s)
        expect(data['title']).to eq(published_post.title)
        expect(data['content']).to eq(published_post.content)
      end
    end

    context '非公開投稿の場合' do
      let(:post_id) { unpublished_post.id }

      it 'データにnilを返すこと' do
        expect(data).to be_nil
      end
    end
  end
end
