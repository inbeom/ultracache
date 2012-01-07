class Order
  include Mongoid::Document
  include Ultracache::Cached

  field :name

  belongs_to :customer
  cached_queue_in :customer, :as => :cached_orders do |obj|
    obj.to_json
  end
end
