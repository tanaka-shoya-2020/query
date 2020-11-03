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

トップページに遷移すると、ログインボタンと新規登録ボタンが画面上部にありますので、ユーザーのサインインをします。

次に、既にルームが存在している場合はルームに入室、そうでない場合はルームを作成します。

そうすると、ルームに入りますので、そこから記事やコメントの投稿、閲覧、編集などの機能を使用することができます。

# 目指した課題解決

Qiitaのようなプログラミングに関する技術情報共有サービスはとてもよく使われているのですが、実際Qiitaに投稿できる記事というのは企業がそれぞれ持っている細かいノウハウのようなものでなく、一般的な記事である場合が多く見受けられました。

そのため、私はクローズな環境を提供することにより、ノウハウの共有などをより円滑に行うことができる環境づくりをすることを目指しました。

# 要件定義
|           機能              |         目的             |
|----------------------------|------------------------- |
|トップページの作成             |ユーザーがサービスを利用する際に、使い勝手の向上を図ることを目的とします。|
|新規登録orログインページの作成  |ユーザーのログイン管理をするため。|
|ルーム作成                    |ルームを作成することで、ルーム外のユーザーが勝手に記事を閲覧できないようにします。|
|新規投稿ページの作成            |ユーザーがルーム内でのみ閲覧できるような記事を投稿するため。|
|ユーザーのマイページの作成       |自身の投稿した記事を閲覧するため。|
|投稿詳細ページの作成            |ルーム内で投稿した記事の閲覧をするため。|
|投稿詳細ページ(コメント機能)の作成|ルーム内で投稿した記事のコメントを付与することができます。|
|投稿編集ページの作成            |投稿した記事の編集をすることができます。|
|投稿削除機能の作成              |投稿した記事の削除をすることができます。|
|検索機能の導入                 |投稿した記事の検索を行うことができます。|
|ビューの作成                   |最低限のUI/UXを確保するため。     |
|結合テストコードの作成           |正常に機能が動作していることを確認する。また、機能変更などを行った際に、機能が正常かどうかを手動で確認することはヒューマンエラーの可能性が生じたり、工数がかかるので、それらを保証することを目的とします。|


# 実装予定の機能

|        機能                              |           目的        |
|---------------------------------------- |-----------------------|
| herokuからAWSのEC2を使ったアプリケーション管理| herokuではアプリケーションを手軽に本番環境で試したい場合には相性がいいものの、インフラ構築をする点ではAWSの方が自由度が高いこともあり、将来的なリターンが大きいと考えたので。
| コメント閲覧機能 | 自身の残したコメントを確認することで、今後そのコメントを閲覧したいときに即座に閲覧することができるため。
| slackへの投稿通知機能 | 自身のした投稿や記事に対するコメントなどを確認しやすくするため。|

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

# ローカルでの動作方法

% ruby --version  を実行します。

バージョンが2.6.5であることを確認します。

% rails -v を実行します。

バージョンが6.0.0であることを確認します。

次に、ローカルにアプリケーションをクローンします。

% git clone https://github.com/tanaka-shoya-2020/query.git

アプリケーションのディレクトリに移動します。

% cd query

gemをインストールします。

% bundle install

yarnをインストールします。

% yarn install

データベースを作成します。

% rails db:create

マイグレーションに記述した内容を、データベースに適用します。

% rails db:migrate






