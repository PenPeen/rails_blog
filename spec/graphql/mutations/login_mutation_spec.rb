# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Login Mutation', type: :request do
  describe 'login' do
    let(:query_string) do
      <<~GRAPHQL
        mutation Login($email: String!, $password: String!) {
          login(
            email: $email
            password: $password
          ) {
            token
            user {
              id
              name
              email
            }
            errors {
              message
              path
            }
          }
        }
      GRAPHQL
    end

    let(:email) { 'test@example.com' }
    let(:password) { 'password' }
    let(:variables) do
      {
        email: email,
        password: password
      }
    end
    let(:result) { MyappSchema.execute(query_string, variables: variables) }
    let(:data) { result['data'] && result['data']['login'] }

    context '本登録済みユーザーの場合' do
      let!(:user) { FactoryBot.create(:user, email: email, password: password, definitive: true) }

      it 'ログインに成功し、トークンとユーザー情報を返すこと' do
        expect(data['token']).to be_present
        expect(data['user']).to be_present
        expect(data['user']['id']).to eq(user.id.to_s)
        expect(data['user']['name']).to eq(user.name)
        expect(data['user']['email']).to eq(user.email)
      end

      it 'セッションが作成されること' do
        expect { result }.to change(Session, :count).by(1)
      end
    end

    context '本登録が完了していないユーザーの場合' do
      let!(:user) { FactoryBot.create(:user, email: email, password: password, definitive: false) }

      it 'ログインに失敗し、エラーメッセージを返すこと' do
        expect(data['token']).to be_nil
        expect(data['user']).to be_nil
        expect(data['errors']).to be_present
        expect(data['errors'][0]['message']).to eq("メールアドレスの認証が完了していません。\nメールをご確認ください。")
        expect(data['errors'][0]['path']).to eq(["email"])
      end

      it 'セッションが作成されないこと' do
        expect { result }.not_to change(Session, :count)
      end
    end

    context 'メールアドレスが間違っている場合' do
      let!(:user) { FactoryBot.create(:user, email: 'other@example.com', password: password) }

      it 'ログインに失敗し、エラーメッセージを返すこと' do
        expect(data['token']).to be_nil
        expect(data['user']).to be_nil
        expect(data['errors']).to be_present
        expect(data['errors'][0]['message']).to eq('メールアドレスまたはパスワードが正しくありません。')
        expect(data['errors'][0]['path']).to contain_exactly('email', 'password')
      end
    end

    context 'パスワードが間違っている場合' do
      let!(:user) { FactoryBot.create(:user, email: email, password: 'wrong_password') }

      it 'ログインに失敗し、エラーメッセージを返すこと' do
        expect(data['token']).to be_nil
        expect(data['user']).to be_nil
        expect(data['errors']).to be_present
        expect(data['errors'][0]['message']).to eq('メールアドレスまたはパスワードが正しくありません。')
        expect(data['errors'][0]['path']).to contain_exactly('email', 'password')
      end
    end
  end
end
