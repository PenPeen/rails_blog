# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  definitive      :boolean          default(FALSE)
#  email           :string(255)      not null
#  name            :string(255)      not null
#  password_digest :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord

  has_secure_password

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_one :token, dependent: :destroy
  has_one :user_image, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :name, length: { maximum: 10 }

  def create_session!
    sessions.create!(key: Session.generate_key)
  end

  def current_session
    sessions.last
  end
end
