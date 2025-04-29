# frozen_string_literal: true

# Usage
=begin
query CurrentUser {
  currentUser {
    id
    email
    name
  }
}
=end

module Resolvers
  class CurrentUserResolver < GraphQL::Schema::Resolver
    type Types::UserType, null: true
    description "Fetches the current logged in user"

    def resolve
      context[:current_user]
    end
  end
end
