require 'models/person'

class Admin < Person
  include Ultracache::Cached

  has_cached_attribute :cached_permissions do |admin|
    admin.permission
  end

  def name
    'admin'
  end
end
