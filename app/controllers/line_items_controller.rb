class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:create]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]
  skip_before_action :authorize, only: :create

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit   
  end

  # POST /line_items
  # POST /line_items.json
  def create
    #original created by scaffolding
    #@line_item = LineItem.new(line_item_params)

    product = Product.find(params[:product_id])
    
    #Go to model method first and check if product already exists if not save it
    @line_item = @cart.add_product(product)

    #Add a product to cart even if there are duplicates
    #@line_item = @cart.line_items.build(product: product)
    
    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_index_url }
        #To know which item to highlight to show it added to cart
        format.js { @current_item = @line_item }
        format.json { render :show, status: :created, location: @line_item }
        session[:counter] = 0
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end


  #Manually added route
  #POST /line_items/1/reduce
  def reduce_quantity
    current_item = LineItem.find(params[:id])
    if current_item.quantity > 1
      current_item.quantity = current_item.quantity - 1
      current_item.save()
    else
      current_item.destroy()
    end
    redirect_to store_index_url
  end


  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item.destroy
    respond_to do |format|
      #format.html { redirect_to line_items_url, notice: 'Line item was successfully destroyed.' }
      format.html { redirect_to cart_url(session[:cart_id]), notice: 'Line item was successfully destroyed.' }

      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def line_item_params
      params.require(:line_item).permit(:product_id)
      #Part as a security messure 
      #params.require(:line_item).permit(:product_id, :cart_id)
    end
end
