class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :room
  belongs_to :article

  validates :comment, presence: true, length: { maximum: 1000 }
  validates :user_id, :room_id, :article_id, presence: true
end
