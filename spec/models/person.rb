class Person
  include Ultracache::Cached

  has_cached_attribute :cached_name do |person|
    person.name
  end

  def id
    "1"
  end

  def name
    'person'
  end
end
