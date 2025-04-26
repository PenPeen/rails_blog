# frozen_string_literal: true

module Mutations
  class LoginMutation < GraphQL::Schema::Mutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :token, String, null: true
    field :user, Types::UserType, null: true

    def resolve(email:, password:)
      user = User.find_by(email:)

      if user && user.authenticate(password)
        user.create_session!
        token = user.current_session.key

        context[:cookies].signed[:ss_sid] = {
          value: token,
          expires: 1.year.from_now,
          httponly: true,
          secure: Rails.env.production?,
        }

        {
          token: token,
          user: user,
        }
      else
        raise GraphQL::ExecutionError, "Invalid credentials"
      end
    end
  end
end
