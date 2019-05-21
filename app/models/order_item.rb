class OrderItem < ApplicationRecord
  belongs_to :item
  belongs_to :order

  validates_numericality_of :quantity, :price
  validates_inclusion_of :fulfilled, in: [true, false]
end
