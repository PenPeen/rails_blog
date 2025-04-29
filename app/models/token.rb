# == Schema Information
#
# Table name: tokens
#
#  id         :bigint           not null, primary key
#  expired_at :datetime         not null
#  uuid       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_tokens_on_user_id  (user_id)
#  index_tokens_on_uuid     (uuid) UNIQUE
#
class Token < ApplicationRecord
  belongs_to :user

  validates :uuid, presence: true, uniqueness: true
  validates :expired_at, presence: true
end
