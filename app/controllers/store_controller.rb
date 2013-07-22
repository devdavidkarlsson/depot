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
      #redirect_to_index("new order should have been created")
       @order= Order.new
    end
  end

  def save_order
    @cart = find_cart
    @items = @cart.items
    @order = Order.new( save_order_params )
    @order.line_items << @cart.items
    if @order.save
      @cart.empty!
      redirect_to_index('Thank you for your order ' + @order.name+'.')
    else
      render(:action => 'checkout')
    end
  end

  def ship
    count = 0
    if things_to_ship = params[:to_be_shipped]
      count = do_ship(things_to_ship)
      if count > 0
        count_text = pluralize(count, "order")
        flash.now[:notice] = "#{count} shipped"
      end
    end
    @pending_orders = Order.pending_shipping
  end


  private
  def do_ship(things_to_ship)
    count = 0
    things_to_ship.each do |order_id, do_it|
      if do_it =="yes"
        order = Order.find(order_id)
        order.mark_as_shipped
        order.save
        count += 1
      end
    end
    count
  end
  def pluralize(count, noun)
    case count
      when 0 then "No #{noun.pluralize}"
      when 1 then "One #{noun}"
      else    "#{count} #{noun.pluralize}"
    end
  end

  def save_order_params
    # This says that params[:order] is required, but inside that, only params[:name][:email]... and params[:post][:body] are permitted
    # Unpermitted params will be stripped out
    params.require(:order).permit(:name, :email, :address, :city, :pay_type)
  end


  def find_cart
    session[:cart] ||= Cart.new
  end



end
