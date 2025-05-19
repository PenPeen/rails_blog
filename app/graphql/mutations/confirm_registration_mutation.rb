# frozen_string_literal: true

# Usage
=begin
mutation ConfirmRegistration($token: String!) {
  confirmRegistration(token: $token) {
    success
  }
}
=end

module Mutations
  class ConfirmRegistrationMutation < BaseMutation
    argument :token, String, required: true

    field :success, Boolean, null: false
    field :token, String, null: true

    def resolve(token:)
      service = UserConfirmationService.new(token:)

      begin
        session = service.call
        {
          success: true,
          token: session.key
        }
      rescue TokenNotFoundError, TokenExpiredError, UserAlreadyConfirmedError => e
        raise GraphQL::ExecutionError.new(e.message)
      rescue StandardError => e
        raise GraphQL::ExecutionError.new("原因不明なエラーが発生しました。しばらく経ってから再度お試しください。")
      end
    end
  end
end
