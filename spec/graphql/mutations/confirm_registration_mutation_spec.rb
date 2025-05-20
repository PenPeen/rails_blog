# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ConfirmRegistration Mutation', type: :request do
  describe 'confirm_registration' do
    let(:query_string) do
      <<~GRAPHQL
        mutation ConfirmRegistration($input: ConfirmRegistrationMutationInput!) {
          confirmRegistration(input: $input) {
            success
            token
            errors {
              message
              path
            }
          }
        }
      GRAPHQL
    end

    let(:token) { 'test_token_uuid' }
    let(:variables) do
      {
        input: {
          token: token
        }
      }
    end
    let(:result) { MyappSchema.execute(query_string, variables:) }
    let(:mock_service) { instance_double(UserConfirmationService) }
    let(:mock_session) { instance_double(Session, key: 'session_key') }
    let(:data) { result['data'] && result['data']['confirmRegistration'] }

    before do
      allow(UserConfirmationService).to receive(:new).with(token: token).and_return(mock_service)
    end

    context '正常なトークンの場合' do
      before do
        allow(mock_service).to receive(:call).and_return(mock_session)
      end

      it '成功レスポンスを返すこと' do
        expect(data['success']).to eq(true)
        expect(data['token']).to eq('session_key')
        expect(data['errors']).to be_empty
      end
    end

    context 'トークンが見つからない場合' do
      before do
        allow(mock_service).to receive(:call).and_raise(TokenNotFoundError, "無効なトークンです。")
      end

      it 'エラーレスポンスを返すこと' do
        expect(data['success']).to be_falsey
        expect(data['token']).to be_nil
        expect(data['errors']).to be_present
        expect(data['errors'][0]['message']).to eq("無効なトークンです。")
      end
    end

    context 'トークンの有効期限が切れている場合' do
      before do
        allow(mock_service).to receive(:call).and_raise(TokenExpiredError, "トークンの有効期限が切れています。再度会員登録を実施してください。")
      end

      it 'エラーレスポンスを返すこと' do
        expect(data['success']).to be_falsey
        expect(data['token']).to be_nil
        expect(data['errors']).to be_present
        expect(data['errors'][0]['message']).to eq("トークンの有効期限が切れています。再度会員登録を実施してください。")
      end
    end

    context 'ユーザーがすでに確定済みの場合' do
      before do
        allow(mock_service).to receive(:call).and_raise(UserAlreadyConfirmedError, "既に登録済みのユーザーです。ログインしてください。")
      end

      it 'エラーレスポンスを返すこと' do
        expect(data['success']).to be_falsey
        expect(data['token']).to be_nil
        expect(data['errors']).to be_present
        expect(data['errors'][0]['message']).to eq("既に登録済みのユーザーです。ログインしてください。")
      end
    end

    context '予期せぬエラーが発生した場合' do
      before do
        allow(mock_service).to receive(:call).and_raise(StandardError, "テストエラー")
      end

      it 'エラーレスポンスを返すこと' do
        expect(data['success']).to be_falsey
        expect(data['token']).to be_nil
        expect(data['errors']).to be_present
        expect(data['errors'][0]['message']).to eq("原因不明なエラーが発生しました。しばらく経ってから再度お試しください。")
      end
    end
  end
end
