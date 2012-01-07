class Post
  include Ultracache::Cached

  attr_accessor :person_id

  def id
    "1"
  end
end
