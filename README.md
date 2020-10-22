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




