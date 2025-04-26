# frozen_string_literal: true

module Mutations
  class LogoutMutation < GraphQL::Schema::Mutation
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
