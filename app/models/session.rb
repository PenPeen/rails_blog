# == Schema Information
#
# Table name: sessions
#
#  id         :bigint           not null, primary key
#  key        :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_sessions_on_key      (key) UNIQUE
#  index_sessions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Session < ApplicationRecord
  belongs_to :user

  validates :key, presence: true, uniqueness: true

  def self.generate_key
    SecureRandom.hex(20)
  end
end
