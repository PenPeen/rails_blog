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

module Mutations
  class CreateUserMutation < GraphQL::Schema::Mutation
    argument :user_input, Types::UserInputType, required: true

    field :message, String, null: true
    field :token, String, null: true
    field :user, Types::UserType, null: true
    field :errors, [Types::UserError], null: false

    def resolve(user_input:)
      service = UserRegistrationService.new(
        email: user_input.email,
        name: user_input.name,
        password: user_input.password
      )

      begin
        user = service.call
        {
          user:,
          token: user.token.uuid,
          message: "確認メールを送信しました。",
          errors: []
        }
      rescue UserAlreadyRegisteredError => e
        {
          user: nil,
          token: nil,
          message: nil,
          errors: [
            {
              message: "ユーザー登録に失敗しました。#{e.message}",
              path: ["userInput", "email"]
            }
          ]
        }
      rescue ActiveRecord::RecordInvalid => e
        user_errors = e.record.errors.map do |error|
          {
            message: error.full_message,
            path: ["userInput", error.attribute.to_s]
          }
        end

        {
          user: nil,
          token: nil,
          message: nil,
          errors: user_errors
        }
      rescue StandardError => e
        {
          user: nil,
          token: nil,
          message: nil,
          errors: [
            {
              message: "予期せぬエラーが発生しました。#{e.message}",
              path: []
            }
          ]
        }
      end
    end
  end
end
