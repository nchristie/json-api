Rails.application.routes.draw do
  resources :categories
  resources :products
  resources :users

  resources :orders, only: [:index, :show, :create] do
    put :cancel, on: :member
    resources :order_items
  end

  get "/404" => "errors#not_found"
  get "/500" => "errors#exception"
end