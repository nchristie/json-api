class CategoriesController < ApplicationController
  # GET /orders
  def index
    @categories = Category.all
  end
end
