# frozen_string_literal: true

# Usage
=begin
mutation Login($email: String!, $password: String!) {
  login(
    email: $email
    password: $password
  ) {
    token
    user {
      id
      name
      email
    }
    errors {
      message
      path
    }
  }
}
=end

module Mutations
  class LoginMutation < GraphQL::Schema::Mutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :token, String, null: true
    field :user, Types::UserType, null: true
    field :errors, [Types::UserError], null: true

    def resolve(email:, password:)
      user = User.find_by(email:)

      if user && user.authenticate(password)
        if user.definitive?
          user.create_session!
          token = user.current_session.key

          {
            token:,
            user:,
          }
        else
          {
            errors: [
              {
                message: "メールアドレスの認証が完了していません。\nメールをご確認ください。",
                path: ["email"]
              }
            ]
          }
        end
      else
        {
          errors: [
            {
              message: "メールアドレスまたはパスワードが正しくありません。",
              path: ["email", "password"]
            }
          ]
        }
      end
    end
  end
end
