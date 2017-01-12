class ProductUpdater

  class NoProductFoundForIdError < StandardError
    def initialize(product_id)
      super("We have no record of a product with id: #{product_id}")
    end
  end

  class InvalidParamsError < StandardError
    def initialize(params)
      super("No `product_id` key passed")
    end
  end

  class InvalidPriceError < StandardError
    def initialize(params)
      super("No `product_id` key passed")
    end
  end

  attr_reader :product_id, :params

  def initialize(product_id, params)
    @product_id = product_id
    @params = params
  end

  def update!
    if product_exists? && params_valid?
      product.price = params["price"]
      product.save!
    else
      render_all_errors
    end
  end

  private

  def render_all_errors
    #validation_errors.merge!(product.errors.messages)
  rescue InvalidParamsError => e
    product.tap { |p| p.errors.add(:base, e.message) }
  rescue NoProductFoundForIdError => e
    product.tap { |p| p.errors.add(:base, e.message) }
  end

  # def validation_errors
  #   @validation_errors ||= {}
  # end

  def params_valid?
    if params.include?("id")
      true
    else
      raise InvalidParamsError.new(params)
    end
  end

  def product_exists?
    product
  end

  def product
    begin
      @product ||= Product.find(product_id)
    rescue ActiveRecord::RecordNotFound
      raise NoProductFoundForIdError.new(product_id)
    end
  end
end