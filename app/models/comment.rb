class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :room
  belongs_to :article

  validates :comment, presence: true
end
