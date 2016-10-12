class ProductCreator

  attr_reader :user, :params

  # user   - the user making the API call.
  # params - the parameters for the product as well as the associated images
  def initialize(user, params)
    @user   = user
    @params = params
  end

  # Validates all parameters. Returns +true+ if they are all valid, +false+ otherwise.
  def valid?
    validations_pass?
    validation_errors.empty?
  end

  def validation_errors
    @validation_errors ||= {}
  end

  # Creates a product in the database as well as any associated images.
  # Returns a boolean indicating whether or not the product was successfully saved to the DB.
  def publish!
    product.save

    if product.persisted?
      if param(:images).present? && param(:images).size > 0
        create_images(product)
      end
      return true
    else
      validation_errors.merge!(product.errors.messages)
      return false
    end
  end

  private

  def product
    @created_product ||= Product.new(product_params)
  end

  def product_params
    ActionController::Parameters.new({
      name:           param(:name),
      price:          param(:price),
      stock_quantity: param(:stock_quantity),
      category_id:    param(:price)
    }).permit!
  end

  def valid_images?
    param(:images).present? && param(:images).size > 0 ? true : false
  end

  # For each declared image create it.
  def create_images(product)
    Array(param(:images)).each do |image_params|
      image = build_image(image_params)
      image.save!
    end
  end

  def build_image(params)
    # TODO: Add background worker to actually process image data that is passed.
    Image.new(product_id: product.id)
  end

  def validations_pass?
    if product.valid?
      true
    else
      validation_errors.merge!(product.errors.messages)
      false
    end
  end

  def param(key)
    params.fetch(key)
  end
end