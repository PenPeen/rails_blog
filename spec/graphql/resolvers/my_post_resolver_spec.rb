# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MyPost Query', type: :request do
  describe 'my_post' do
    let(:query_string) do
      <<~GRAPHQL
        query MyPost($id: ID!) {
          myPost(id: $id) {
            id
            title
            content
            published
          }
        }
      GRAPHQL
    end

    let(:user) { create(:user) }
    let!(:post) { create(:post, user:) }
    let(:post_id) { post.id }
    let(:variables) { { id: post_id } }
    let(:current_user) { user }
    let(:result) do
      MyappSchema.execute(
        query_string,
        variables:,
        context: { current_user: }
      )
    end
    let(:data) { result['data'] && result['data']['myPost'] }
    let(:errors) { result['errors'] }

    context 'ログインしているユーザーが自分の投稿にアクセスする場合' do
      it '投稿を返すこと' do
        expect(data).to be_present
        expect(data['id']).to eq(post.id.to_s)
        expect(data['title']).to eq(post.title)
        expect(data['content']).to eq(post.content)
        expect(data['published']).to eq(post.published)
      end
    end

    context '存在しない投稿IDにアクセスする場合' do
      let(:post_id) { 0 }

      it 'GraphQL::ExecutionErrorが発生し、エラーメッセージを返すこと' do
        expect(errors).to be_present
        expect(errors[0]['message']).to eq('Post not found')
        expect(data).to be_nil
      end
    end

    context 'ログインしていない場合' do
      let(:current_user) { nil }

      it 'エラーを返すこと' do
        expect(errors).to be_present
        expect(errors[0]['message']).to include('You must be logged in')
        expect(data).to be_nil
      end
    end
  end
end
