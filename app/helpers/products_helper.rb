module ProductsHelper
  def load_image_product product
    if product.images.attached?
      image_tag product.images, class: "pic-4"
    else
      image_tag "default.jpeg", class: "pic-4"
    end
  end
end
