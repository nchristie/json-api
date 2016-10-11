class ImagesController < ApplicationController

  # GET /images
  def index
    @product = Product.find(params[:product_id])
    @images = @product.images
  end

end