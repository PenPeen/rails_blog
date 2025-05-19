# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserConfirmationService, type: :model do
  describe '#call' do
    let(:user) { FactoryBot.create(:user, definitive: false) }
    let(:token_uuid) { SecureRandom.uuid }
    let!(:token) { FactoryBot.create(:token, user: user, uuid: token_uuid, expired_at: 1.hour.from_now) }
    let(:service) { described_class.new(token: token_uuid) }

    context '有効なトークンの場合' do
      it 'ユーザーのdefinitiveフラグをtrueに設定すること' do
        expect { service.call }.to change { user.reload.definitive }.from(false).to(true)
      end

      it 'セッションを生成すること' do
        expect { service.call }.to change(Session, :count).by(1)
      end

      it '生成したセッションを返すこと' do
        session = service.call
        expect(session).to be_a(Session)
        expect(session.user).to eq(user)
      end
    end

    context 'トークンが見つからない場合' do
      let(:service) { described_class.new(token: 'invalid_token') }

      it 'TokenNotFoundErrorを発生させること' do
        expect { service.call }.to raise_error(TokenNotFoundError, "無効なトークンです。")
      end
    end

    context 'トークンの有効期限が切れている場合' do
      let!(:token) { FactoryBot.create(:token, user: user, uuid: token_uuid, expired_at: 1.hour.ago) }

      it 'TokenExpiredErrorを発生させること' do
        expect { service.call }.to raise_error(TokenExpiredError, "トークンの有効期限が切れています。再度会員登録を実施してください。")
      end
    end

    context 'ユーザーがすでに確定済みの場合' do
      let(:user) { FactoryBot.create(:user, definitive: true) }

      it 'UserAlreadyConfirmedErrorを発生させること' do
        expect { service.call }.to raise_error(UserAlreadyConfirmedError, "既に登録済みのユーザーです。ログインしてください。")
      end
    end
  end
end
