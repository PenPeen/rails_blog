# frozen_string_literal: true

# Usage
=begin
mutation CreateUser($userInput: UserInputType!) {
  createUser(userInput: $userInput) {
    user {
      id
      name
      email
    }
    token
    message
    errors {
      message
      path
    }
  }
}
=end

module Mutations::User
  class CreateUserMutation < GraphQL::Schema::Mutation
    description 'ユーザー作成'

    argument :user_input, Types::UserInputType,
      required: true,
      description: 'ユーザー情報'

    field :errors, [Types::UserError],
      null: true,
      description: 'エラー情報'

    field :message, String, null: true,
      description: 'メッセージ'

    field :token, String, null: true,
      description: 'トークン'

    field :user, Types::UserType,
      null: true,
      description: '作成されたユーザー'

    def resolve(user_input:)
      service = CreateUserService.new(**user_input.to_h)
      result = service.call

      {
        user: result.user,
        token: result.token,
        message: result.message,
        errors: result.errors
      }
    end
  end
end
