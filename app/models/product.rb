class Product < ApplicationRecord
  belongs_to :category

  has_many :order_details, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many_attached :images
  has_many :orders, through: :order_details

  validates :name, presence: true
  validates :quantity, presence: true,
            numericality: {only_integer: true,
                           greater_than: Settings.validation.number.zero}
  validates :price, presence: true,
            numericality: {greater_than: Settings.validation.number.zero}
  scope :order_alphabet_name, ->{order name: :asc}
  scope :filter_product_by_name, ->(name){where("name like ?", "%#{name}%")}
end
