# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  content    :text(65535)      not null
#  published  :boolean          default(FALSE)
#  title      :string(255)      not null
#  top_image  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  belongs_to :user

  has_one_attached :thumbnail

  validates :title, :content, presence: true

  scope :published, -> { where(published: true) }
  scope :hidden, -> { where(published: false) }

  scope :by_recent, -> { order(created_at: :desc) }
  scope :all_posts, -> { by_recent }
  scope :all_published_posts, -> { published.by_recent }
  scope :publish_posts_for_user, ->(user_id) { where(user_id:).published.by_recent }
  scope :search_by_title, ->(title) { where("title LIKE ?", "%#{title}%") }

  def thumbnail_url
    return nil unless thumbnail.attached?

    if Rails.env.production?
      thumbnail.url
    else
      Rails.application.routes.url_helpers.rails_blob_url(
        thumbnail,
        host: Rails.application.routes.default_url_options[:host]
      )
    end
  end
end
