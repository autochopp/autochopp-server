class User < ApplicationRecord
  has_secure_password
  validates :email, uniqueness: {case_sensitive: false}
  before_save { self.email = email.downcase }
end
