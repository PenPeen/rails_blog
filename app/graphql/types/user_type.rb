# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    description 'ユーザー情報'

    field :created_at, GraphQL::Types::ISO8601DateTime,
      null: false,
      description: '作成日時'

    field :email, String,
      null: false,
      description: 'メールアドレス'

    field :id, ID,
      null: false,
      description: 'ID'

    field :name, String,
      null: false,
      description: '名前'

    field :updated_at, GraphQL::Types::ISO8601DateTime,
      null: false,
      description: '更新日時'

    field :posts, [Types::PostType],
      null: true,
      description: 'ユーザーが投稿した投稿'

    field :user_image, Types::UserImageType,
      null: true,
      description: 'ユーザーのプロフィール画像'

    def posts
      Loaders::AssociationLoader.for(User, :posts).load(object)
    end

    def user_image
      Loaders::AssociationLoader.for(User, :user_image).load(object)
    end
  end
end
