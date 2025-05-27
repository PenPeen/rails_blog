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
    description 'ログイン処理'

    argument :email, String,
      required: true,
      description: 'メールアドレス'

    argument :password, String,
      required: true,
      description: 'パスワード'

    field :errors, [Types::UserError],
      null: true,
      description: 'エラー情報'

    field :token, String,
      null: true,
      description: 'トークン'

    field :user, Types::UserType,
      null: true,
      description: 'ユーザー情報'

    def resolve(email:, password:)
      result = LoginService.new(
        email: email,
        password: password
      ).call

      {
        token: result.token,
        user: result.user,
        errors: result.errors
      }
    end
  end
end
