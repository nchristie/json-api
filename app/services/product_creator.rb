class ProductCreator

  REQUIRED_KEYS = [:name, :price, :category_id, :stock_quantity, :images]

  attr_reader :params

  # params - the parameters for the product as well as the associated images
  def initialize(params)
    @params = params
  end

  # Validates all parameters. Returns +true+ if they are all valid, +false+ otherwise.
  def valid?
    required_keys_present?
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
      category_id:    param(:category_id)
    }).permit!
  end

  def valid_images?
    param(:images).present? && param(:images).size > 0 ? true : false
  end

  # For each declared image create it.
  def create_images(product)
    Array(param(:images)).each do |image_params|
      image = build_image(image_params)
      image.save
    end
  end

  def build_image(params)
    # TODO: Add background worker to actually process image data that is passed.
    Image.new(
                  product_id: product.id,
                  #TODO: image.data will not be string - instead Base64...
                  data: params[:data]
                )
  end

  def required_keys_present?
    REQUIRED_KEYS.each do |req_key|
      if params.keys.map(&:to_sym).exclude?(req_key)
        validation_errors.merge!({"Parameter(s) Missing" => "Check the required keys"})
        return false
      end
    end
    true
  end

  def param(key)
    params.fetch(key)
  end
end