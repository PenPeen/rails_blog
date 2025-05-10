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
  }
}
=end

module Mutations
  class CreateUserMutation < GraphQL::Schema::Mutation
    argument :user_input, Types::UserInputType, required: true

    field :user, Types::UserType, null: true
    field :token, String, null: true
    field :message, String, null: false

    def resolve(user_input:)
      service = UserRegistrationService.new(
        email: user_input.email,
        name: user_input.name,
        password: user_input.password
      )

      begin
        user = service.call
        {
          user: user,
          token: user.token.uuid,
          message: "確認メールを送信しました。"
        }
      rescue UserAlreadyRegisteredError => e
        raise GraphQL::ExecutionError.new(
          "ユーザー登録に失敗しました。\n#{e.message}"
        )
      rescue ActiveRecord::RecordInvalid => e
        raise GraphQL::ExecutionError.new(
          "ユーザー登録に失敗しました。\n#{e.record.errors.full_messages.join(', ')}"
        )
      rescue StandardError => e
        raise GraphQL::ExecutionError.new(
          "予期せぬエラーが発生しました。\n#{e.message}"
        )
      end
    end
  end
end
