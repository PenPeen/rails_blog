# frozen_string_literal: true

class LoginService
  Result = Struct.new(:user, :token, :errors, keyword_init: true)

  attr_reader :email, :password

  def initialize(email:, password:)
    @email = email
    @password = password
  end

  def call
    user = User.find_by(email: email)

    if user && user.authenticate(password)
      if user.definitive?
        user.create_session!
        token = user.current_session.key

        Result.new(
          user: user,
          token: token,
          errors: nil
        )
      else
        Result.new(
          user: nil,
          token: nil,
          errors: [
            {
              message: "メールアドレスの認証が完了していません。\nメールをご確認ください。",
              path: ["email"]
            }
          ]
        )
      end
    else
      Result.new(
        user: nil,
        token: nil,
        errors: [
          {
            message: "メールアドレスまたはパスワードが正しくありません。",
            path: ["email", "password"]
          }
        ]
      )
    end
  end
end
