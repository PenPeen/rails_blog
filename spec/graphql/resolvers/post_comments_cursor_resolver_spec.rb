# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PostCommentsCursor Query', type: :request do
  describe 'postCommentsCursor' do
    let(:query_string) do
      <<~GRAPHQL
        query PostCommentsCursor($postId: ID!, $first: Int, $after: String) {
          postCommentsCursor(postId: $postId, first: $first, after: $after) {
            edges {
              cursor
              node {
                id
                content
                user {
                  id
                  name
                }
                createdAt
              }
            }
            pageInfo {
              hasNextPage
              hasPreviousPage
              startCursor
              endCursor
            }
            totalCount
          }
        }
      GRAPHQL
    end

    let(:user) { create(:user) }
    let(:post) { create(:post, user: user) }
    let(:post_id) { post.id }
    let(:first) { 10 }
    let(:after) { nil }
    let(:variables) { { postId: post_id, first:, after: } }
    let(:current_user) { user }
    let(:result) do
      MyappSchema.execute(
        query_string,
        variables:,
        context: { current_user: }
      )
    end
    let(:data) { result['data'] && result['data']['postCommentsCursor'] }
    let(:errors) { result['errors'] }

    context '投稿にコメントがある場合' do
      before do
        create_list(:comment, 5, post:, user:)
      end

      it 'コメント一覧を取得できること' do
        expect(data).to be_present
        expect(data['edges'].length).to eq(5)
        expect(data['totalCount']).to eq(5)
        expect(data['edges'][0]['node']['user']['id']).to eq(user.id.to_s)
        expect(data['pageInfo']).to include(
          'hasNextPage' => false,
          'hasPreviousPage' => false
        )
      end
    end

    context '投稿にコメントがない場合' do
      it '空の配列を返すこと' do
        expect(data['edges']).to eq([])
        expect(data['totalCount']).to eq(0)
      end
    end

    context '存在しない投稿IDの場合' do
      let(:post_id) { 9999 }

      it '空の配列を返すこと' do
        expect(data['edges']).to eq([])
        expect(data['totalCount']).to eq(0)
      end
    end
  end
end
