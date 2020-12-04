class Order < ApplicationRecord
  belongs_to :user
  belongs_to :voucher

  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details
  enum status: {waiting: 0, accepted: 1, refused: 2,
                canceled: 3, shipping: 4, delivered: 5}
end
