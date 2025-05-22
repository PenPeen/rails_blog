# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DeletePost Mutation', type: :request do
  describe 'delete_post' do
    let(:query_string) do
      <<~GRAPHQL
        mutation DeletePost($input: DeletePostMutationInput!) {
          deletePost(input: $input) {
            post {
              id
              title
              content
            }
            success
            message
            errors {
              message
              path
            }
          }
        }
      GRAPHQL
    end

    let(:user) { FactoryBot.create(:user, definitive: true) }
    let(:post_record) { FactoryBot.create(:post, user:) }
    let(:post_id) { post_record.id }

    let(:variables) do
      {
        input: {
          id: post_id.to_s
        }
      }
    end

    let(:result) do
      MyappSchema.execute(
        query_string,
        variables:,
        context: { current_user: }
      )
    end

    let(:data) { result['data'] && result['data']['deletePost'] }
    let(:current_user) { user }

    context '正常なパラメータの場合' do
      it '投稿を削除し、成功レスポンスを返すこと' do
        expect(data['post']).to be_present
        expect(data['post']['id']).to eq(post_id.to_s)
        expect(data['success']).to be true
        expect(data['message']).to eq('投稿を削除しました。')
        expect(data['errors']).to be_nil

        expect { post_record.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context '投稿が見つからない場合' do
      let(:post_id) { 9999 }

      it 'エラーレスポンスを返すこと' do
        expect(data['post']).to be_nil
        expect(data['success']).to be false
        expect(data['message']).to eq('投稿が見つかりません。')
      end
    end

    context '未認証の場合' do
      let(:current_user) { nil }

      it 'ログインエラーを返すこと' do
        expect(data).to be_nil
        expect(result['errors']).to be_present
        expect(result['errors'][0]['message']).to eq('You must be logged in to access this resource')
      end
    end
  end
end
