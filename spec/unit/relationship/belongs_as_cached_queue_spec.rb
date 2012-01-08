require "spec_helper"

describe Ultracache::BelongsAsCachedQueue do
  let(:belongs_as_cached_queue) do
    Ultracache::BelongsAsCachedQueue.new :cached_posts, nil,
      :self_class => Post, :associated_class => Person
  end

  describe "#key" do
    it "has form of [parent_class]:[id]:[name]" do
      p = Post.new
      p.person_id = 1
      belongs_as_cached_queue.key(p).should == "person:1:cached_posts"
    end
  end
end
