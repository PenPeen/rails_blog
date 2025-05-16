# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PublishedPosts Query', type: :request do
  describe 'published_posts' do
    let(:query_string) do
      <<~GRAPHQL
        query PublishedPosts($page: Int, $perPage: Int) {
          published {
            posts(page: $page, perPage: $perPage) {
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
    let!(:published_posts) { create_list(:post, 5, user:, published: true) }
    let!(:unpublished_posts) { create_list(:post, 3, user:, published: false) }
    let(:page) { 1 }
    let(:per_page) { 3 }
    let(:variables) { { page: page, perPage: per_page } }
    let(:result) { MyappSchema.execute(query_string, variables:) }
    let(:data) { result['data']['published']['posts'] }
    let(:posts_data) { data['posts'] }
    let(:pagination) { data['pagination'] }

    it '公開済み投稿一覧を返すこと' do
      expect(posts_data.size).to eq(3)

      post_ids = posts_data.map { |p| p['id'].to_i }
      published_post_ids = published_posts.map(&:id)
      expect(post_ids).to all(be_in(published_post_ids))

      expect(pagination['totalCount']).to eq(5)
      expect(pagination['limitValue']).to eq(3)
      expect(pagination['totalPages']).to eq(2)
      expect(pagination['currentPage']).to eq(1)
    end

    context 'ページングがある場合' do
      let(:page) { 2 }

      it '指定したページの投稿を返すこと' do
        expect(posts_data.size).to eq(2) # 2ページ目には残り2件

        expect(pagination['totalCount']).to eq(5)
        expect(pagination['currentPage']).to eq(2)
      end
    end
  end
end
