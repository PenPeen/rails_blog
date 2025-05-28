# frozen_string_literal: true

# Usage
=begin
mutation Logout{
  logout{
    success
  }
}
=end

# NOTE: CookieのライフサイクルはFEのプロジェクトに移譲したため、現在は利用していない。
module Mutations::Auth
  class LogoutMutation < GraphQL::Schema::Mutation
    description 'ログアウト処理'
    field :success, Boolean, null: false

    def resolve
      if context[:cookies].signed[:ss_sid]
        context[:cookies].delete(:ss_sid)

        { success: true }
      else
        { success: false }
      end
    end
  end
end
