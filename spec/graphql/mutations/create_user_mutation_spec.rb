# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CreateUser Mutation', type: :request do
  describe 'create_user' do
    let(:query_string) do
      <<~GRAPHQL
        mutation CreateUser($userInput: UserInputType!) {
          createUser(userInput: $userInput) {
            user {
              id
              name
              email
            }
            token
            message
          }
        }
      GRAPHQL
    end

    let(:name) { 'テストユーザー' }
    let(:email) { 'test@example.com' }
    let(:password) { 'password' }
    let(:variables) do
      {
        userInput: {
          name:,
          email:,
          password:
        }
      }
    end
    let(:result) { MyappSchema.execute(query_string, variables:) }
    let(:data) { result['data'] && result['data']['createUser'] }

    context '正常なパラメータの場合' do
      it 'ユーザーを作成し、成功レスポンスを返すこと' do
        expect {
          expect(data['user']).to be_present
          expect(data['user']['name']).to eq(name)
          expect(data['user']['email']).to eq(email)
          expect(data['token']).to be_present
          expect(data['message']).to eq('確認メールを送信しました。')

          user = User.find_by(email:)
          expect(user).to be_present
          expect(user.name).to eq(name)
          expect(user.definitive).to eq(false)
          expect(user.token).to be_present
          expect(user.token.uuid).to eq(data['token'])
        }.to change(User, :count).by(1)
          .and change(Token, :count).by(1)
          .and have_enqueued_job(UserMailerJob)
      end
    end

    context 'メールアドレスが既に登録されている場合' do
      before do
        FactoryBot.create(:user, email:, definitive: true)
      end

      it 'エラーレスポンスを返すこと' do
        expect {
          expect(result['errors']).to be_present
          expect(result['errors'][0]['message']).to include('ユーザー登録に失敗しました')
          expect(result['errors'][0]['message']).to include('入力されたメールアドレスは登録済みです')
        }.to not_change(User, :count)
          .and not_change(Token, :count)
          .and not_enqueue_job(UserMailerJob)
      end
    end

    context 'バリデーションエラーの場合' do
      let(:email) { '' }

      it 'エラーレスポンスを返すこと' do
        expect {
          expect(result['errors']).to be_present
          expect(result['errors'][0]['message']).to include('ユーザー登録に失敗しました')
        }.to not_change(User, :count)
          .and not_change(Token, :count)
          .and not_enqueue_job(UserMailerJob)
      end
    end
  end
end
