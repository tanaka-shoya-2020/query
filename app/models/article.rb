class Article < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :text,  presence: true, length: { minimum: 30, maximum: 10_000 }
  validates :user_id, :room_id, presence: true

  belongs_to :user
  belongs_to :room
  has_many   :comments, dependent: :destroy

  def self.search(search)
    Article.where('title LIKE(?)', "%#{search}%") if search != ''
  end
end
