# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserRegistrationService, type: :model do
  describe '#call' do
    let(:email) { 'test@example.com' }
    let(:name) { 'テストユーザー' }
    let(:password) { 'password' }
    let(:service) { described_class.new(email:, name:, password:) }

    context '新規ユーザーの場合' do
      it 'ユーザーを登録できること' do
        expect { service.call }.to change(User, :count).by(1)
      end

      it 'トークンを生成すること' do
        expect { service.call }.to change(Token, :count).by(1)
      end

      it 'メール送信ジョブをキューに追加すること' do
        expect { service.call }.to have_enqueued_job(UserMailerJob)
      end

      it 'ユーザー情報が正しいこと' do
        user = service.call
        expect(user.email).to eq(email)
        expect(user.name).to eq(name)
        expect(user).to be_valid
        expect(user.definitive).to eq(false)
      end

      it 'トークン情報が正しいこと' do
        user = service.call
        token = user.token
        expect(token).to be_present
        expect(token.uuid).to be_present
        expect(token.expired_at).to be > Time.current
      end
    end

    context '登録済みユーザーの場合（definitive = false）' do
      let!(:existing_user) { FactoryBot.create(:user, email:, definitive: false) }

      it '新規ユーザーを作成しないこと' do
        expect { service.call }.not_to change(User, :count)
      end

      it 'トークンを更新または作成すること' do
        old_token = existing_user.token
        user = service.call

        if old_token.present?
          expect(user.token.uuid).not_to eq(old_token.uuid)
        else
          expect(user.token).to be_present
        end
      end

      it 'メール送信ジョブをキューに追加すること' do
        expect { service.call }.to have_enqueued_job(UserMailerJob)
      end
    end

    context '登録済み確定ユーザーの場合（definitive = true）' do
      before do
        FactoryBot.create(:user, email:, definitive: true)
      end

      it 'UserAlreadyRegisteredErrorを発生させること' do
        expect { service.call }.to raise_error(UserAlreadyRegisteredError, "入力されたメールアドレスは登録済みです。")
      end
    end
  end
end
