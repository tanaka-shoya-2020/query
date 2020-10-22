class Room < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20},
            uniqueness: true

  has_secure_password
end
