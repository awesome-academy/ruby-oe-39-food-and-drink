class Voucher < ApplicationRecord
  has_many :orders, dependent: :destroy
end
