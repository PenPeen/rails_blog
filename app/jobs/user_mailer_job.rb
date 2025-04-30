# frozen_string_literal: true

class UserMailerJob < ApplicationJob
  queue_as :default

  def perform(user_id, token, mail_type)
    user = User.find(user_id)

    case mail_type.to_sym
    when :provisional_registration
      UserMailer.provisional_registration(user, token).deliver_now
    end
  end
end
