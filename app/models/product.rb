class Product < ApplicationRecord
  belongs_to :category

  has_many :order_details, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many_attached :images
  has_many :orders, through: :order_details
end
