# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::PostCommentsResolver, type: :request do
  describe 'resolve' do
    let(:user) { create(:user) }
    let(:post_record) { create(:post, user: user) }
    let(:query) do
      <<~GQL
        query PostComments($postId: ID!) {
          postComments(postId: $postId) {
            comments {
              id
              content
              user {
                id
                name
              }
            }
            count
          }
        }
      GQL
    end

    context '投稿にコメントがある場合' do
      before do
        create_list(:comment, 3, post: post_record, user: user)
      end

      it 'コメント一覧を取得できること' do
        variables = { postId: post_record.id }

        post '/graphql', params: { query: query, variables: variables }

        json = JSON.parse(response.body)
        data = json['data']['postComments']

        expect(data['comments'].length).to eq(3)
        expect(data['count']).to eq(3)
        expect(data['comments'][0]['user']['id']).to eq(user.id.to_s)
      end
    end

    context '投稿にコメントがない場合' do
      it '空の配列を返すこと' do
        variables = { postId: post_record.id }

        post '/graphql', params: { query: query, variables: variables }

        json = JSON.parse(response.body)
        data = json['data']['postComments']

        expect(data['comments']).to eq([])
        expect(data['count']).to eq(0)
      end
    end

    context '存在しない投稿IDの場合' do
      it '空の配列を返すこと' do
        variables = { postId: 9999 }

        post '/graphql', params: { query: query, variables: variables }

        json = JSON.parse(response.body)
        data = json['data']['postComments']

        expect(data['comments']).to eq([])
        expect(data['count']).to eq(0)
      end
    end
  end
end
