class Room < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20},
            uniqueness: true
  has_secure_password

  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]{6,}+\z/i.freeze
  validates_format_of :password, with: PASSWORD_REGEX
  validates :password, presence: true
end
