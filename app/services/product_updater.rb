class ProductUpdater

  class NoProductFoundForId < StandardError
    def initialize(product_id)
      super("We have no record of a product with id: #{product_id}")
    end
  end

  class InvalidParams < StandardError
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
    validation_errors.merge!(product.errors.messages)
  end

  def validation_errors
    @validation_errors ||= {}
  end

  def params_valid?
    if params.include?("id")
      true
    else
      raise InvalidParams.new(params)
    end
  end

  def product_exists?
    product
  end

  def product
    begin
      @product ||= Product.find(product_id)
    rescue ActiveRecord::RecordNotFound
      raise NoProductFoundForId.new(product_id)
    end
  end


end