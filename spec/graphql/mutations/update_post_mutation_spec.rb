# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UpdatePost Mutation', type: :request do
  describe 'update_post' do
    let(:query_string) do
      <<~GRAPHQL
        mutation UpdatePost($input: UpdatePostMutationInput!) {
          updatePost(input: $input) {
            post {
              id
              title
              content
              published
              thumbnailUrl
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
    let(:post_record) { FactoryBot.create(:post, user:) }
    let(:post_id) { post_record.id }
    let(:title) { '更新後のタイトル' }
    let(:content) { '更新後の内容です。' }
    let(:published) { false }
    let(:thumbnail) { nil }

    let(:variables) do
      {
        input: {
          postInput: {
            id: post_id.to_s,
            title:,
            content:,
            published:,
            thumbnail:
          }
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

    let(:data) { result['data'] && result['data']['updatePost'] }
    let(:current_user) { user }

    context '正常なパラメータの場合' do
      it '投稿を更新し、成功レスポンスを返すこと' do
        expect(data['post']).to be_present
        expect(data['post']['id']).to eq(post_id.to_s)
        expect(data['post']['title']).to eq(title)
        expect(data['post']['content']).to eq(content)
        expect(data['post']['published']).to eq(published)
        expect(data['message']).to eq('更新が完了しました。')
        expect(data['errors']).to be_nil

        post_record.reload
        expect(post_record.title).to eq(title)
        expect(post_record.content).to eq(content)
        expect(post_record.published).to eq(published)
      end

      context 'サムネイル画像も更新する場合' do
        let(:thumbnail) { 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=' }

        it 'サムネイル画像も更新されること' do
          expect(data['post']).to be_present
          expect(data['post']['title']).to eq(title)
          expect(data['post']['content']).to eq(content)
          expect(data['post']['published']).to eq(published)
          expect(data['post']['thumbnailUrl']).to be_present
          expect(data['message']).to eq('更新が完了しました。')
          expect(data['errors']).to be_nil

          post_record.reload
          expect(post_record.title).to eq(title)
          expect(post_record.content).to eq(content)
          expect(post_record.published).to eq(published)
          expect(post_record.thumbnail).to be_attached
        end
      end
    end

    context 'バリデーションエラーの場合' do
      let(:title) { '' }

      it 'エラーレスポンスを返すこと' do
        expect(data['post']).to be_nil
        expect(data['message']).to be_nil
        expect(data['errors']).to be_present
        expect(data['errors'][0]['message']).to include('タイトル')
        expect(data['errors'][0]['path']).to eq(['postInput', 'title'])
      end
    end

    context 'ファイルサイズが大きすぎる場合' do
      let(:thumbnail) { 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=' }

      before do
        stub_const("UpdatePostService::MAX_FILE_SIZE", 1.byte)
      end

      it 'ファイルサイズのエラーを返すこと' do
        expect(data['post']).to be_nil
        expect(data['message']).to be_nil
        expect(data['errors']).to be_present
        expect(data['errors'][0]['message']).to include('ファイルサイズは2MB以下にしてください')
        expect(data['errors'][0]['path']).to eq(['postInput', 'thumbnail'])
      end
    end

    context '投稿が見つからない場合' do
      let(:post_id) { 9999 }

      it 'エラーレスポンスを返すこと' do
        expect(data['post']).to be_nil
        expect(data['message']).to be_nil
        expect(data['errors']).to be_present
        expect(data['errors'][0]['message']).to eq('投稿が見つかりません。')
        expect(data['errors'][0]['path']).to eq(['postInput', 'id'])
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
