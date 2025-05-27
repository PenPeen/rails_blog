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
    description 'ユーザー登録確認'

    argument :token, String,
      required: true,
      description: 'トークン'

    field :errors, [Types::UserError],
      null: true,
      description: 'エラー情報'

    field :success, Boolean,
      null: true,
      description: '成功フラグ'

    field :token, String,
      null: true,
      description: 'トークン'

    def resolve(token:)
      service = UserConfirmationService.new(token:)

      begin
        session = service.call
        {
          success: true,
          token: session.key,
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
