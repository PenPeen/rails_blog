# Rails ブログアプリケーション

## 概要
このアプリケーションはRails 7.1.5で構築されたブログプラットフォームです。
ユーザー登録、投稿管理、GraphQL APIなどの機能を提供します。

## 技術スタック
- Ruby: 3.1.7
- Rails: 7.1.5
- MySQL: 8.0
- Docker/Docker Compose (開発環境)
- GraphQL
- Node.js/npm (フロントエンド連携用)

## 主な機能
- ユーザー管理（登録、認証、プロフィール更新）
- ブログ投稿（作成、編集、表示、検索）
- GraphQL API（フロントエンド連携）
- ページネーション
- 画像アップロード機能

## 開発環境のセットアップ

### 必要条件
- Docker
- Docker Compose

### 環境構築手順
1. リポジトリをクローン
```bash
git clone [リポジトリURL]
cd rails_blog
```

2. Dockerコンテナを起動
```bash
docker-compose up -d
```

3. データベースの作成とマイグレーション
```bash
docker-compose exec web bash
rails db:create
rails db:migrate
```

4. サーバーへのアクセス
```
http://localhost:5001
```

### 開発用コマンド

#### Railsコンソールの起動
```bash
docker-compose exec web bash
rails console
```

#### テストの実行
```bash
docker-compose exec web bash
rspec
```

#### Rubocopによるコード品質チェック
```bash
docker-compose exec web bash
rubocop
```

## GraphQL API

このアプリケーションはGraphQL APIを提供しています。開発環境では以下のURLでGraphiQLを利用できます：
```
http://localhost:5001/graphiql
```

### 主要なクエリ

#### ユーザー認証
```graphql
mutation Login($email: String!, $password: String!) {
  login(email: $email, password: $password) {
    token
    user {
      id
      name
      email
    }
  }
}
```

#### 投稿一覧取得
```graphql
query GetPosts($page: Int, $perPage: Int) {
  published {
    posts(page: $page, perPage: $perPage) {
      posts {
        id
        title
        content
        thumbnailUrl
        createdAt
        user {
          name
        }
      }
      pagination {
        currentPage
        totalPages
        totalCount
      }
    }
  }
}
```

## フロントエンド連携

このRailsアプリケーションは別リポジトリで管理されているNextjsフロントエンドと連携するように設計されています。
フロントエンドリポジトリ: `@Desktop/dev/next_blog`

## 貢献方法

1. このリポジトリをフォーク
2. 機能ブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add some amazing feature'`)
4. ブランチをプッシュ (`git push origin feature/amazing-feature`)
5. Pull Requestを作成

## 注意事項

- Dockerで開発環境を作っているので、rails関連のコマンド実行時はコンテナに入ること: `docker compose exec web bash`
