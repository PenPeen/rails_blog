# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def provisional_registration(user, token)
    @user = user
    @token = token
    @url = "http://localhost:3000/api/registration/confirm?token=#{token}"

    mail(
      to: @user.email,
      subject: "【Railsブログ】ユーザー登録の確認"
    )
  end
end
