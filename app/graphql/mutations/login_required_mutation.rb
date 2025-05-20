# frozen_string_literal: true

module Mutations
  class LoginRequiredMutation < BaseMutation
    def resolve(**args)
      raise NotImplementedError, "#{self.class.name}#resolve must be implemented"
    end

    def ready?(**args)
      if context[:current_user].blank?
        return false, {
          errors: [
            {
              message: "ログインが必要です",
              path: []
            }
          ]
        }
      end

      true
    end
  end
end
