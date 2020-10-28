Rails.application.routes.draw do

  resources :orders
  resources :line_items
  resources :carts
  resources :products
  post 'line_items/:id/reduce' => "line_items#reduce_quantity", as: "line_item_reduce" 

  resources :products do
    get :who_bought, on: :member
  end

  root 'store#index', as: 'store_index'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
