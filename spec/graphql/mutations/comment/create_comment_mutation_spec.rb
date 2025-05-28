# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CreateComment Mutation', type: :request do
  describe 'create_comment' do
    let(:query_string) do
      <<~GRAPHQL
        mutation CreateComment($input: CreateCommentMutationInput!) {
          createComment(input: $input) {
            comment {
              id
              content
              user {
                id
                name
              }
              post {
                id
                title
              }
            }
            errors {
              message
              path
            }
          }
        }
      GRAPHQL
    end

    let(:user) { FactoryBot.create(:user, definitive: true) }
    let(:post_record) { create(:post, user: user) }
    let(:post_id) { post_record.id }
    let(:content) { 'Test comment content' }

    let(:variables) do
      {
        input: {
          postId: post_id,
          content: content
        }
      }
    end

    let(:result) do
      MyappSchema.execute(
        query_string,
        variables: variables,
        context: { current_user: current_user }
      )
    end

    let(:data) { result['data'] && result['data']['createComment'] }
    let(:current_user) { user }

    context '正常なパラメータの場合' do
      it 'コメントを作成し、成功レスポンスを返すこと' do
        expect {
          result
        }.to change(Comment, :count).by(1)

        expect(data['comment']).to be_present
        expect(data['comment']['content']).to eq(content)
        expect(data['comment']['user']['id']).to eq(user.id.to_s)
        expect(data['comment']['post']['id']).to eq(post_record.id.to_s)
        expect(data['errors']).to be_nil

        created_comment = Comment.last
        expect(created_comment.content).to eq(content)
        expect(created_comment.user).to eq(user)
        expect(created_comment.post).to eq(post_record)
      end
    end

    context '異常系' do
      context '存在しない投稿IDの場合' do
        let(:post_id) { 9999 }

        it 'エラーレスポンスを返すこと' do
          expect {
            result
          }.not_to change(Comment, :count)

          expect(data['comment']).to be_nil
          expect(data['errors']).to be_present
          expect(data['errors'][0]['message']).to eq('投稿が見つかりません')
        end
      end

      context '空のコンテンツの場合' do
        let(:content) { '' }

        it 'バリデーションエラーを返すこと' do
          expect {
            result
          }.not_to change(Comment, :count)

          expect(data['comment']).to be_nil
          expect(data['errors']).to be_present
          expect(data['errors'][0]['message']).to include('入力してください')
        end
      end

      context '未認証の場合' do
        let(:current_user) { nil }

        it 'ログインエラーを返すこと' do
          expect {
            result
          }.not_to change(Comment, :count)

          expect(data).to be_nil
          expect(result['errors']).to be_present
          expect(result['errors'][0]['message']).to eq('You must be logged in to access this resource')
        end
      end
    end
  end
end
