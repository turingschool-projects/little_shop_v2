class Item < ApplicationRecord
  validates_presence_of :name, :description, :image
  validates_numericality_of :price, :inventory

  validates_inclusion_of :active, in: [true, false]
  belongs_to :user
  has_many :order_items
  has_many :orders, through: :order_items

  def self.active_items
    Item.where(active: true)
  end

  def self.top_five
    joins(:order_items).where("order_items.fulfilled IS true").order(quantity: :desc).limit(5)
  end

  def self.bottom_five
    joins(:order_items).where("order_items.fulfilled IS true").order(quantity: :asc).limit(5)
  end

  def quantity_bought
    order_items.where(fulfilled: :true).sum(:quantity)
  end
end
