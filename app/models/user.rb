class User < ApplicationRecord
  has_many :posts, dependent: :destroy

  validates :name, :password, presence: true
  validates :email, presence: true, uniqueness: true
end
