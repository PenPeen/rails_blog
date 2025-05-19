# frozen_string_literal: true

class UserConfirmationService
  attr_reader :token, :user

  def initialize(token:)
    @token = Token.find_by(uuid: token)
    raise TokenNotFoundError, "無効なトークンです。" unless @token
    @user = @token.user
  end

  def call
    ActiveRecord::Base.transaction do
      validate_token
      confirm_user
      create_session
    end

    user.sessions.last
  end

  private
    def validate_token
      if token.expired_at < Time.current
        raise TokenExpiredError, "トークンの有効期限が切れています。再度会員登録を実施してください。"
      end
    end

    def confirm_user
      if user.definitive?
        raise UserAlreadyConfirmedError, "既に登録済みのユーザーです。ログインしてください。"
      end
      user.update!(definitive: true)
    end

    def create_session
      session = user.create_session!
    end
end

class TokenNotFoundError < StandardError; end
class TokenExpiredError < StandardError; end
class UserAlreadyConfirmedError < StandardError; end
