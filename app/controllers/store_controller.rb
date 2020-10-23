class StoreController < ApplicationController

  include CurrentCart
  before_action :set_cart, only: [:create]

  

  def index
    @products = Product.order(:title)

    if session[:counter].nil?
      set_cart
    else
      session[:counter] += 1
    end
    
  end



end
