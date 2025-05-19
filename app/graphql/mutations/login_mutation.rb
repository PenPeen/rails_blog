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
  }
}
=end

module Mutations
  class LoginMutation < GraphQL::Schema::Mutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :token, String, null: true
    field :user, Types::UserType, null: true

    def resolve(email:, password:)
      user = User.find_by(email:)

      if user && user.authenticate(password)
        if user.definitive?
          user.create_session!
          token = user.current_session.key

          {
            token:,
            user:
          }
        else
          raise GraphQL::ExecutionError, "メールアドレスの認証が完了していません。\nメールをご確認ください。"
        end
      else
        raise GraphQL::ExecutionError, "メールアドレスまたはパスワードが正しくありません。"
      end
    end
  end
end
