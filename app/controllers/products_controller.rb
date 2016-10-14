class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]

  # GET /products
  def index
    @products = Product.all
  end

  # GET /products/1
  def show
  end

  # POST /products
  # def create
  #   @product = Product.new(product_params)

  #   if @product.save
  #     render nothing: :true, status: :created, location: @product
  #   else
  #     render json: @product.errors, status: :unprocessable_entity
  #   end
  # end

  # Parameters:
  #
  # {
  #   # Product Data
  #   "name"             => "Product_Name",
  #
  #   # Product Associations: 1. Images
  #   "images" => [
  #     {
  #       "url"        => "https://www.example.org/image1.jpg"
  #     }
  #     # ...
  #   ]
  # }

  # POST /products
  def create
    product_creator = ::ProductCreator.new(params)

    if product_creator.valid?
      if product_creator.publish!
        render nothing: true, status: :created, location: product_creator.product
      else
        render json: product_creator.validation_errors, status: :unprocessable_entity
      end
    else
      render json: product_creator.validation_errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      render :show, status: :ok, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
  end

  private
  def set_product
    @product = Product.find(params[:id])
  end

  # def product_params
  #   params.require(:product).permit(:name, :price, :category_id, :stock_quantity, :images)
  # end
end
