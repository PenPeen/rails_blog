# frozen_string_literal: true

class CreateUserService
  Result = Struct.new(:user, :token, :message, :errors, keyword_init: true)

  attr_reader :email, :name, :password, :user

  def initialize(email:, name:, password:)
    @email = email
    @name = name
    @password = password
  end

  def call
    begin
      @user = User.find_or_initialize_by(email:)

      if @user.persisted? && @user.definitive
        return Result.new(
          user: nil,
          token: nil,
          message: nil,
          errors: [
            {
              message: "ユーザー登録に失敗しました。入力されたメールアドレスは登録済みです。",
              path: ["userInput", "email"]
            }
          ]
        )
      end

      ActiveRecord::Base.transaction do
        create_or_update_user
        generate_token
        send_registration_email
      end

      Result.new(
        user: @user,
        token: @user.token.uuid,
        message: "確認メールを送信しました。",
        errors: nil
      )
    rescue ActiveRecord::RecordInvalid => e
      user_errors = e.record.errors.map do |error|
        {
          message: error.full_message,
          path: ["userInput", error.attribute.to_s]
        }
      end

      Result.new(user: nil, token: nil, message: nil, errors: user_errors)
    rescue StandardError => e
      Result.new(
        user: nil,
        token: nil,
        message: nil,
        errors: [
          { message: "予期せぬエラーが発生しました。#{e.message}" }
        ]
      )
    end
  end

  private

    def create_or_update_user
      unless @user.persisted?
        @user.assign_attributes(
          name:,
          password:
        )
        @user.save!
      end
    end

    def generate_token
      token_uuid = SecureRandom.uuid

      if user.token.present?
        user.token.update!(uuid: token_uuid, expired_at: 24.hours.since)
      else
        user.create_token!(uuid: token_uuid, expired_at: 24.hours.since)
      end
    end

    def send_registration_email
      UserMailerJob.perform_later(user.id, user.token.uuid, :provisional_registration)
    end
end
