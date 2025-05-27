# frozen_string_literal: true

module Types
  class UserInputType < Types::BaseInputObject
    graphql_name "UserInputType"
    description "Attributes for creating a user"

    argument :email, String,
      required: true,
      description: 'メールアドレス'

    argument :name, String,
      required: true,
      description: '名前'

    argument :password, String,
      required: true,
      description: 'パスワード'
  end
end
