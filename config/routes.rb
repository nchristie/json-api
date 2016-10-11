Rails.application.routes.draw do
  resources :users
  resources :categories

  resources :products do
    resources :images, only: [:index, :create]
  end

  resources :orders, only: [:index, :show, :create] do
    put :cancel, on: :member
    resources :order_items
  end

  get "/404" => "errors#not_found"
  get "/500" => "errors#exception"
end