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

    field :errors, [Types::UserError], null: true
    field :message, String, null: true
    field :token, String, null: true
    field :user, Types::UserType, null: true

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
