class User < ApplicationRecord
  has_many_attached :images
  has_many :ratings, dependent: :destroy
  has_many :orders, dependent: :destroy

  enum role: {admin: 0, member: 1}
end
