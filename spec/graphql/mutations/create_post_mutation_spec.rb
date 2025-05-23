# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CreatePost Mutation', type: :request do
  describe 'create_post' do
    let(:query_string) do
      <<~GRAPHQL
        mutation CreatePost($input: CreatePostMutationInput!) {
          createPost(input: $input) {
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
    let(:title) { '新しい投稿のタイトル' }
    let(:content) { '新しい投稿の内容です。' }
    let(:published) { false }
    let(:thumbnail) { nil }

    let(:variables) do
      {
        input: {
          postInput: {
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

    let(:data) { result['data'] && result['data']['createPost'] }
    let(:current_user) { user }

    context '正常なパラメータの場合' do
      it '投稿を作成し、成功レスポンスを返すこと' do
        expect {
          result
        }.to change(Post, :count).by(1)

        expect(data['post']).to be_present
        expect(data['post']['title']).to eq(title)
        expect(data['post']['content']).to eq(content)
        expect(data['post']['published']).to eq(published)
        expect(data['message']).to eq('投稿が完了しました。')
        expect(data['errors']).to be_nil

        created_post = Post.last
        expect(created_post.title).to eq(title)
        expect(created_post.content).to eq(content)
        expect(created_post.published).to eq(published)
        expect(created_post.user).to eq(user)
      end

      context 'サムネイル画像も指定する場合' do
        let(:thumbnail) { 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=' }

        it 'サムネイル画像も作成されること' do
          expect {
            result
          }.to change(Post, :count).by(1)

          expect(data['post']).to be_present
          expect(data['post']['title']).to eq(title)
          expect(data['post']['content']).to eq(content)
          expect(data['post']['published']).to eq(published)
          expect(data['post']['thumbnailUrl']).to be_present
          expect(data['message']).to eq('投稿が完了しました。')
          expect(data['errors']).to be_nil

          created_post = Post.last
          expect(created_post.title).to eq(title)
          expect(created_post.content).to eq(content)
          expect(created_post.published).to eq(published)
          expect(created_post.user).to eq(user)
          expect(created_post.thumbnail).to be_attached
        end
      end
    end

    context 'バリデーションエラーの場合' do
      let(:title) { '' }

      it 'エラーレスポンスを返すこと' do
        expect {
          result
        }.not_to change(Post, :count)

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
        stub_const("PostCreationService::MAX_FILE_SIZE", 1.byte)
      end

      it 'ファイルサイズのエラーを返すこと' do
        expect {
          result
        }.not_to change(Post, :count)

        expect(data['post']).to be_nil
        expect(data['message']).to be_nil
        expect(data['errors']).to be_present
        expect(data['errors'][0]['message']).to include('ファイルサイズは2MB以下にしてください')
        expect(data['errors'][0]['path']).to eq(['postInput', 'thumbnail'])
      end
    end

    context '未認証の場合' do
      let(:current_user) { nil }

      it 'ログインエラーを返すこと' do
        expect {
          result
        }.not_to change(Post, :count)

        expect(data).to be_nil
        expect(result['errors']).to be_present
        expect(result['errors'][0]['message']).to eq('You must be logged in to access this resource')
      end
    end
  end
end
