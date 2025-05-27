# frozen_string_literal: true

module Types
  class UserProfileInputType < Types::BaseInputObject
    graphql_name "UserProfileInputType"
    description "Attributes for updating a user profile"

    argument :name, String,
      required: true,
      description: '名前'

    argument :profile, String,
      required: false,
      description: 'Base64エンコードされたプロフィール画像文字列'
  end
end
