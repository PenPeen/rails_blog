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

    field :errors, [Types::UserError], null: true
    field :token, String, null: true
    field :user, Types::UserType, null: true

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
