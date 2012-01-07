require "spec_helper"

describe Ultracache::HasCachedAttribute do
  let(:person_attribute_block) do
    to_proc do |obj|
      obj.name
    end
  end

  let(:cached_attribute) do
    Ultracache::HasCachedAttribute.new :cached_name,
      :self_class => Person, :serializer_block => person_attribute_block
  end

  describe "#key" do
    it "has proper form" do
      cached_attribute.key(Person.new).should == "person:1:cached_name"
    end
  end
end
