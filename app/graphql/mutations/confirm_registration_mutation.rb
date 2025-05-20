# frozen_string_literal: true

# Usage
=begin
mutation ConfirmRegistration($token: String!) {
  confirmRegistration(token: $token) {
    success
    token
    errors {
      message
      path
    }
  }
}
=end

module Mutations
  class ConfirmRegistrationMutation < BaseMutation
    argument :token, String, required: true

    field :success, Boolean, null: true
    field :token, String, null: true
    field :errors, [Types::UserError], null: true

    def resolve(token:)
      service = UserConfirmationService.new(token:)

      begin
        session = service.call
        {
          success: true,
          token: session.key,
          errors: []
        }
      rescue TokenNotFoundError, TokenExpiredError, UserAlreadyConfirmedError => e
        {
          success: false,
          token: nil,
          errors: [
            { message: e.message }
          ]
        }
      rescue StandardError => e
        {
          success: false,
          token: nil,
          errors: [
            { message: "原因不明なエラーが発生しました。しばらく経ってから再度お試しください。" }
          ]
        }
      end
    end
  end
end
