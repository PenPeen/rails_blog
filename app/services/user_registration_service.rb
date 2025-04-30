# frozen_string_literal: true

class UserRegistrationService
  attr_reader :email, :name, :password, :user

  def initialize(email:, name:, password:)
    @email = email
    @name = name
    @password = password
  end

  def call
    ActiveRecord::Base.transaction do
      find_or_create_user
      generate_token
      send_registration_email
      @user
    end
  end

  private

    def find_or_create_user
      @user = User.find_or_initialize_by(email:)

      validate_user_registration

      unless @user.persisted?
        @user.assign_attributes(
          name:,
          password:
        )
        @user.save!
      end
    end

    def validate_user_registration
      if user.persisted? && user.definitive
        raise UserAlreadyRegisteredError, "入力されたメールアドレスは登録済みです。"
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

class UserAlreadyRegisteredError < StandardError; end
