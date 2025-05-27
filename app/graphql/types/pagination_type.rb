# frozen_string_literal: true

module Types
  class PaginationType < Types::BaseObject
    description 'ページネーション情報'

    field :current_page, Integer,
      null: true,
      description: '現在のページ番号'

    field :limit_value, Integer,
      null: true,
      description: '1ページあたりの表示件数'

    field :total_count, Integer,
      null: true,
      description: '総件数'

    field :total_pages, Integer,
      null: true,
      description: '総ページ数'
  end
end
