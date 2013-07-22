class Order < ActiveRecord::Base
  has_many :line_items
  PAYMENT_TYPES = [
       ["Credit", "cc"],
       ["Paypal", "pp"],
       ["Purchase Order", "po"]
  ].freeze

  validates_presence_of :name, :email, :address, :city, :pay_type
  validates_inclusion_of :pay_type, :in =>
      PAYMENT_TYPES.map {|disp, value| value}

  def self.pending_shipping
    find(:all, :conditions => "shipped_at is null")
  end

  def mark_as_shipped
    self.shipped_at = Time.now
  end
end
