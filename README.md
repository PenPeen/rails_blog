# Rails ブログアプリケーション

## 概要
このアプリケーションはRails 7.1.5で構築されたブログプラットフォームです。
ユーザー登録、投稿管理、GraphQL APIなどの機能を提供します。

## 技術スタック
- Ruby: 3.1.7
- Rails: 7.1.5
- MySQL: 8.0 (開発環境)
- Docker/Docker Compose (開発環境)

## 主な機能
- ユーザー管理（登録、認証）
- ブログ投稿（作成、編集、表示）
- GraphQL API

## 開発環境のセットアップ

### 必要条件
- Docker
- Docker Compose

### 環境構築手順
1. リポジトリをクローン
```
git clone [リポジトリURL]
cd rails_blog
```

2. Dockerコンテナを起動
```
docker-compose up -d
```

3. データベースの作成とマイグレーション
```
docker-compose exec web bash
rails db:create
rails db:migrate
```

### 開発用コマンド

#### Railsコンソールの起動
```
docker-compose exec web bash
rails console
```

#### テストの実行
```
docker-compose exec web bash
rspec
```

## API仕様
このアプリケーションはGraphQL APIを提供しています。開発環境では以下のURLでGraphiQLを利用できます：
```
http://localhost:5001/graphiql
```

## デプロイ
...
