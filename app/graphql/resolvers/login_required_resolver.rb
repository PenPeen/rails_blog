# frozen_string_literal: true

module Resolvers
  class LoginRequiredResolver < GraphQL::Schema::Resolver
    description 'ログインが必要なリソースアクセスに対する認可チェック'

    def authorized?(args)
      if context[:current_user]
        true
      else
        raise GraphQL::ExecutionError, "You must be logged in to access this resource"
      end
    end
  end
end
