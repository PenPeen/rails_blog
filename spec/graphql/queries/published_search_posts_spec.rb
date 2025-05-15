# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PublishedSearchPosts Query', type: :request do
  describe 'published_search_posts' do
    let(:query_string) do
      <<~GRAPHQL
        query PublishedSearchPosts($title: String!, $page: Int, $perPage: Int) {
          published {
            searchPosts(title: $title, page: $page, perPage: $perPage) {
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
        }
      GRAPHQL
    end

    let(:user) { create(:user) }
    let!(:apple_post) { create(:post, user:, title: 'リンゴについて', published: true) }
    let!(:banana_post) { create(:post, user:, title: 'バナナについて', published: true) }
    let!(:orange_post) { create(:post, user:, title: 'オレンジについて', published: true) }
    let!(:unpublished_post) { create(:post, user:, title: 'リンゴのレシピ', published: false) }

    let(:variables) { { title: 'リンゴ', page: 1, perPage: 10 } }

    context '検索キーワードに一致する公開済み投稿がある場合' do
      it '一致する投稿を返すこと' do
        result = MyappSchema.execute(query_string, variables:)

        data = result['data']['published']['searchPosts']
        expect(data['posts'].size).to eq(1)
        expect(data['posts'][0]['id']).to eq(apple_post.id.to_s)
        expect(data['posts'][0]['title']).to eq('リンゴについて')

        pagination = data['pagination']
        expect(pagination['totalCount']).to eq(1)
        expect(pagination['currentPage']).to eq(1)
      end
    end

    context '検索キーワードに一致する投稿がない場合' do
      let(:variables) { { title: '存在しないキーワード', page: 1, perPage: 10 } }

      it '空の結果を返すこと' do
        result = MyappSchema.execute(query_string, variables:)

        data = result['data']['published']['searchPosts']
        expect(data['posts'].size).to eq(0)

        pagination = data['pagination']
        expect(pagination['totalCount']).to eq(0)
      end
    end

    context '非公開投稿は検索結果に含まれないこと' do
      it '公開済み投稿のみを返すこと' do
        result = MyappSchema.execute(query_string, variables:)

        data = result['data']['published']['searchPosts']
        post_ids = data['posts'].map { |p| p['id'].to_i }

        expect(post_ids).to include(apple_post.id)
        expect(post_ids).not_to include(unpublished_post.id)
      end
    end
  end
end
