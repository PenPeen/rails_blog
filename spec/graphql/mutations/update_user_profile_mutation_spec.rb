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
    let(:current_user) { user }

    context '正常なパラメータの場合' do
      it 'ユーザープロフィールを更新し、成功レスポンスを返すこと' do
        data = result['data']['updateUserProfile']

        expect(data['user']).to be_present
        expect(data['user']['name']).to eq(name)
        expect(data['message']).to eq('プロフィールが正常に更新されました。')

        user.reload
        expect(user.name).to eq(name)
      end

      context 'プロフィール画像も更新する場合' do
        let(:profile) { 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=' }

        it 'プロフィール画像も更新されること' do
          data = result['data']['updateUserProfile']

          expect(data['user']).to be_present
          expect(data['user']['name']).to eq(name)
          expect(data['message']).to eq('プロフィールが正常に更新されました。')

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
        expect(result['errors']).to be_present
        error_message = result['errors'][0]['message']
        expect(error_message).to include('プロフィール更新に失敗しました')
        expect(error_message).to include("can't be blank")
      end

      context 'ファイルサイズが大きすぎる場合' do
        let(:name) { '更新後の名前' }

        before do
          stub_const("UserProfileService::MAX_FILE_SIZE", 1.byte)
        end

        let(:profile) { 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=' }

        it 'ファイルサイズのエラーを返すこと' do
          expect(result['errors']).to be_present
          error_message = result['errors'][0]['message']
          expect(error_message).to include('プロフィール更新に失敗しました')
          expect(error_message).to include('ファイルサイズは2MB以下にしてください')
        end
      end
    end

    context '未認証の場合' do
      let(:current_user) { nil }

      it 'エラーレスポンスを返すこと' do
        expect(result['errors']).to be_present
        expect(result['errors'][0]['message']).to eq("You must be logged in to access this resource")
      end
    end
  end
end
