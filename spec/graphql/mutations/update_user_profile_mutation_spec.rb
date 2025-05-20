# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UpdateUserProfile Mutation', type: :request do
  describe 'update_user_profile' do
    let(:query_string) do
      <<~GRAPHQL
        mutation UpdateUserProfile($input: UpdateUserProfileMutationInput!) {
          updateUserProfile(input: $input) {
            user {
              id
              name
              email
            }
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
    let(:name) { '更新後の名前' }
    let(:profile) { nil }
    let(:variables) do
      {
        input: {
          userProfileInput: {
            name: name,
            profile: profile
          }
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
    let(:data) { result['data'] && result['data']['updateUserProfile'] }
    let(:current_user) { user }

    context '正常なパラメータの場合' do
      it 'ユーザープロフィールを更新し、成功レスポンスを返すこと' do
        expect(data['user']).to be_present
        expect(data['user']['name']).to eq(name)
        expect(data['message']).to eq('プロフィールが正常に更新されました。')
        expect(data['errors']).to be_empty

        user.reload
        expect(user.name).to eq(name)
      end

      context 'プロフィール画像も更新する場合' do
        let(:profile) { 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=' }

        it 'プロフィール画像も更新されること' do
          expect(data['user']).to be_present
          expect(data['user']['name']).to eq(name)
          expect(data['message']).to eq('プロフィールが正常に更新されました。')
          expect(data['errors']).to be_empty

          user.reload
          expect(user.name).to eq(name)
          expect(user.user_image).to be_present
          expect(user.user_image.profile).to be_attached
        end
      end
    end

    context 'バリデーションエラーの場合' do
      let(:name) { '' }

      it 'エラーレスポンスを返すこと' do
        expect(data['user']).to be_nil
        expect(data['message']).to be_nil
        expect(data['errors']).to be_present
        expect(data['errors'][0]['message']).to include('名前')
        expect(data['errors'][0]['path']).to eq(['userProfileInput', 'name'])
      end

      context 'ファイルサイズが大きすぎる場合' do
        let(:name) { '更新後の名前' }

        before do
          stub_const("UserProfileService::MAX_FILE_SIZE", 1.byte)
        end

        let(:profile) { 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=' }

        it 'ファイルサイズのエラーを返すこと' do
          expect(data['user']).to be_nil
          expect(data['message']).to be_nil
          expect(data['errors']).to be_present
          expect(data['errors'][0]['message']).to include('ファイルサイズは2MB以下にしてください')
          expect(data['errors'][0]['path']).to eq(['userProfileInput', 'profile'])
        end
      end
    end

    context '未認証の場合' do
      let(:current_user) { nil }

      it 'エラーレスポンスを返すこと' do
        expect(data).not_to be_nil
        expect(data['user']).to be_nil
        expect(data['message']).to be_nil
        expect(data['errors']).to be_present
        expect(data['errors'][0]['message']).to eq('ログインが必要です')
        expect(data['errors'][0]['path']).to eq([])
      end
    end
  end
end
