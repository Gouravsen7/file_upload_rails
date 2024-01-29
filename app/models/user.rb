class User < ApplicationRecord
  validates :email, :password, presence: { uniqueness: true }
end
