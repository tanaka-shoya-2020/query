class Room < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20}

  has_secure_password
end
