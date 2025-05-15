# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MyPosts Query', type: :request do
  describe 'my_posts' do
    let(:query_string) do
      <<~GRAPHQL
        query MyPosts($page: Int, $perPage: Int) {
          myPosts(page: $page, perPage: $perPage) {
            posts {
              id
              title
              content
            }
            pagination {
              totalCount
              limitValue
              totalPages
              currentPage
            }
          }
        }
      GRAPHQL
    end

    let(:user) { create(:user) }
    let!(:posts) { create_list(:post, 5, user: user) }
    let(:variables) { { page: 1, perPage: 3 } }

    context 'ログインしている場合' do
      it '自分の投稿一覧を返すこと' do
        result = MyappSchema.execute(
          query_string,
          variables: variables,
          context: { current_user: user }
        )

        data = result['data']['myPosts']
        expect(data['posts'].size).to eq(3)
        expect(data['posts'][0]['id']).to eq(posts.first.id.to_s)
        expect(data['posts'][0]['title']).to eq(posts.first.title)

        pagination = data['pagination']
        expect(pagination['totalCount']).to eq(5)
        expect(pagination['limitValue']).to eq(3)
        expect(pagination['totalPages']).to eq(2)
        expect(pagination['currentPage']).to eq(1)
      end
    end

    context 'ログインしていない場合' do
      it 'エラーを返すこと' do
        result = MyappSchema.execute(
          query_string,
          variables: variables,
          context: { current_user: nil }
        )

        expect(result['errors']).to be_present
        expect(result['errors'][0]['message']).to include('You must be logged in')
      end
    end
  end
end
