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

    let(:search_keyword) { 'リンゴ' }
    let(:page) { 1 }
    let(:per_page) { 10 }
    let(:variables) { { title: search_keyword, page: page, perPage: per_page } }
    let(:result) { MyappSchema.execute(query_string, variables:) }
    let(:data) { result['data']['published']['searchPosts'] }
    let(:posts_data) { data['posts'] }
    let(:pagination) { data['pagination'] }

    context '検索キーワードに一致する公開済み投稿がある場合' do
      it '一致する投稿を返すこと' do
        expect(posts_data.size).to eq(1)
        expect(posts_data[0]['id']).to eq(apple_post.id.to_s)
        expect(posts_data[0]['title']).to eq('リンゴについて')

        expect(pagination['totalCount']).to eq(1)
        expect(pagination['currentPage']).to eq(1)
      end
    end

    context '検索キーワードに一致する投稿がない場合' do
      let(:search_keyword) { '存在しないキーワード' }

      it '空の結果を返すこと' do
        expect(posts_data.size).to eq(0)
        expect(pagination['totalCount']).to eq(0)
      end
    end

    context '非公開投稿は検索結果に含まれないこと' do
      it '公開済み投稿のみを返すこと' do
        post_ids = posts_data.map { |p| p['id'].to_i }

        expect(post_ids).to include(apple_post.id)
        expect(post_ids).not_to include(unpublished_post.id)
      end
    end
  end
end
