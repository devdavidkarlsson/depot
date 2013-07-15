class StoreController < ApplicationController
  def index
    @products = Product.salable_items
  end



  def add_to_cart
    product = Product.find(params[:id])
    @cart = find_cart
    @cart.add_product(product)
    redirect_to(:action => 'display_cart')
  rescue ActiveRecord::RecordNotFound
    logger.error("Attempt to access invalid product #{params[:id]}")
    flash[:notice] = "Invalid product"
    redirect_to :action => 'index'
  end

  def display_cart
    @cart = find_cart
    @items = @cart.items
    if @items.empty?
      redirect_to_index("Your cart is empty")
    end
  end


  def empty_cart
    @cart = find_cart
    @cart.empty!
    redirect_to_index("Your cart is now empty")
  end


  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to(:action => 'index')
  end

  def checkout
    @cart = find_cart
    @items = @cart.items
    if @items.empty?
      redirect_to_index("There's nothing to checkout in your cart!")
    else
      redirect_to_index("new order should have been created")
      # @order= Order.new
    end
  end

  private
  def find_cart
    session[:cart] ||= Cart.new
  end


end
