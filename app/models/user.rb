class User < ApplicationRecord
  before_save { self.username = username.downcase }

  has_secure_password
  validates :username, presence: true, uniqueness: { case_sensitive: false }
end
