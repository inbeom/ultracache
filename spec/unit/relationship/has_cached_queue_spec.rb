require "spec_helper"

describe Ultracache::HasCachedQueue do
  let(:object_block) do
    to_proc do |obj|
      obj.to_json
    end
  end

  let(:has_cached_queue) do
    Ultracache::HasCachedQueue.new :cached_objects,
      :self_class => 'Person', :serializer_block => object_block
  end

  describe "#key" do
    it "has form of [class]:[id]:[name]" do
      has_cached_queue.key(Person.new).should == "person:1:cached_objects"
    end
  end
end
