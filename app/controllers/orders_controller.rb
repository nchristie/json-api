class OrdersController < ApplicationController
  # GET /orders
  def index
    @orders = Order.all
    if @orders
      render :index, status: :ok
    else
      #Render a message
      render nothing: :true
    end
  end

  # GET /orders/1
  def show
    @order = Order.find(params[:id])
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

  def cancel
    @order = Order.from_user(user).cancellable.where(id: params[:id]).first

    if @order
      OrderManager.user_cancel(@order, "Cancellation from #{user.name}")
      render nothing: :true, status: :ok, location: order_url(@order)
    else
      render nothing: :true, status: :unprocessable_entity
    end
  end
end
