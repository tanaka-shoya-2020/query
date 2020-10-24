class Article < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :text,  presence: true
  validates :user_id, :room_id, presence: true

  belongs_to :user
  belongs_to :room
  has_many   :comments
end
