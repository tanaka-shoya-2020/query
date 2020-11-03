# Queryアプリとは

このアプリは新米エンジニアを対象とした記事投稿ができるアプリケーションです。

内容は非常にシンプルで、新規登録の手続きをした後にルームをご自身で作成されるか、
すでに作成されたルームに入室していただくことで、自由に記事の投稿、閲覧、コメント
などを行うことができます。

仮に他の方に投稿を知られたくない場合も、投稿自体は自分自身のもの以外はすべてルーム内
でしか閲覧ができないため、プライバシーも守られています。

# アプリケーションのURL

 https://query-app-30448.herokuapp.com/

上記のURLからアプリの画面に遷移することができます。
少し起動時に時間がかかってしまうことがあります。

## ID/Pass

- ID: admin
- Pass: 2020

# テスト用アカウント

## 投稿者用
| メールアドレス     | パスワード  | ルーム     | ルームパスワード |
|----------------  | ----------|-----------|---------------|
| foobar1@gmail.com| foobar1   |テストルーム1| foobar1       |

## 閲覧者用
| メールアドレス     | パスワード  | ルーム     | ルームパスワード |
|----------------  | ----------|-----------|---------------|
| foobar2@gmail.com| foobar1   |テストルーム1| foobar1       |

# 利用方法
<image_src="query-room_in.png", size='350x200'>
# テーブル設計

## users テーブル

| Column           | Type    | Options     |
| ---------------- | ------- | ----------  |
| nickname         | string  | null: false |
| email            | string  | null: false |
| password         | string  | null: false |

### Association

- has_many :room_users
- has_many :articles
- has_many :comments

## rooms テーブル

| Column           | Type    | Options     |
| ---------------- | ------- | ----------  |
| name             | string  | null: false |
| password         | string  | null: false |

### Association

- has_many :rooms_users
- has_many :articles
- has_many :comments

## room_users テーブル

| Column     | Type        | Options                        |
| -----------| -------     | ------------------------------ |
| user       | references  | null: false, foreign_key: true |
| room       | references  | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :room

### articles テーブル

| Column         | Type       | Options                        |
| ---------------| ---------- | ------------------------------ |
| title          | string     | null: false                    |
| content        | string     | null: false                    |
| tag            | string     | null: false                    |
| user           | references | null: false, foreign_key: true |
| room           | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :room

### comments テーブル

| Column         | Type       | Options                        |
| ---------------| ---------- | ------------------------------ |
| comment        | string     | null: false                    |
| user           | references | null: false, foreign_key: true |
| room           | references | null: false, foreign_key: true |
| article        | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :room
- belongs_to :article




