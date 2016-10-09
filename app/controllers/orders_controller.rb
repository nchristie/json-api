class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy]

  # GET /orders
  def index
    @orders = Order.all

    render :index
  end

  # GET /orders/1
  def show
  end

  # POST /orders
  def create
    order_creator = ::OrderCreator.new(user, params)
    @order = order_creator.publish!

    if order_creator.successful?
      render nothing: :true, status: :created, location: order_url(@order)
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /orders/1
  def update
    if @order.update(order_params)
      render :show, status: :ok, location: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
