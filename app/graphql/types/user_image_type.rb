# frozen_string_literal: true

module Types
  class UserImageType < Types::BaseObject
    description 'ユーザープロフィール画像'

    field :profile, String,
      null: true,
      description: 'URL'

    def profile
      Loaders::ActiveStorageLoader.for(UserImage, :profile).load(object.id).then do |profile|
        if Rails.env.production?
          profile.url
        else
          Rails.application.routes.url_helpers.rails_blob_url(profile, host: Rails.application.routes.default_url_options[:host])
        end
      end
    end
  end
end
