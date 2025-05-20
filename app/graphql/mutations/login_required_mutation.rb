# frozen_string_literal: true

module Mutations
  class LoginRequiredMutation < BaseMutation
    def authorized?(args)
      if context[:current_user]
        true
      else
        raise GraphQL::ExecutionError, "You must be logged in to access this resource"
      end
    end
  end
end
