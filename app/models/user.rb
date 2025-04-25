# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  auth_token      :string(255)
#  email           :string(255)      not null
#  name            :string(255)      not null
#  password_digest :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_auth_token  (auth_token)
#  index_users_on_email       (email) UNIQUE
#
require 'securerandom'

class User < ApplicationRecord

  has_secure_password

  has_many :posts, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  def generate_token
    SecureRandom.hex(20)
  end

  def save_auth_token!(token)
    update!(auth_token: token)
  end
end
