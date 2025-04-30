# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def provisional_registration(user, token)
    @user = user
    @token = token
    @url = "#{Rails.application.routes.default_url_options[:host]}/registration/confirm?token=#{token}"

    mail(
      to: @user.email,
      subject: "【Railsブログ】ユーザー登録の確認"
    )
  end
end
