class Item < ApplicationRecord
  validates_presence_of :name, :price, :description, :image, :inventory, require: true
  validates :name, uniqueness: true, presence: true
  validates_inclusion_of :active, :in => [true, false]

  belongs_to :user
  has_many :order_items
  has_many :orders, through: :order_items

  def self.all_active
    where(active: true)
  end

  def deactivate
    update_attribute(:active, false)
  end

  def activate
    update_attribute(:active, true)
  end

  def ordered?
    orders != []
  end
end
