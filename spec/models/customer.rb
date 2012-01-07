class Customer
  include Mongoid::Document
  include Ultracache::Cached

  has_many :orders
  has_cached_queue :cached_orders, :class => 'Order'
end
