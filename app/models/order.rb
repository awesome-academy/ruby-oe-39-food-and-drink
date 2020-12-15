class Order < ApplicationRecord
  VALID_PHONE_REGEX = /\A\d[0-9]{9}\z/.freeze

  belongs_to :user
  belongs_to :voucher, optional: true

  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details
  enum status: {waiting: 0, accepted: 1, refused: 2,
                canceled: 3, shipping: 4, delivered: 5}

  validates :phone_number, presence: true,
            format: {with: VALID_PHONE_REGEX}
  validates :address, presence: true

  extend ActiveModel::Callbacks
  define_model_callbacks :cancel, only: :after
  after_cancel :update_quantity_product_cancel

  def cancel
    run_callbacks :cancel do
      canceled!
    end
  end

  def update_quantity_product_cancel
    order_details.map do |od|
      @product = od.product
      @product.update!(quantity: (@product.quantity + od.quantity))
    end
  end
end
