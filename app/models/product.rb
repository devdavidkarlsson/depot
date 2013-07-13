class Product < ActiveRecord::Base
  validates_presence_of :title, :description, :image_url, :date_available
  validates_numericality_of :price
  validate :positive_price

  protected
  #Makes sure that a positive number has been added to the field price
  def positive_price
    errors.add(:price, "should be positive") unless price.nil? || price >= 0.01
  end
end
