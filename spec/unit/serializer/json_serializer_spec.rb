require 'spec_helper'

describe Ultracache::Serializer::JsonSerializer do
  let(:serializer) { Ultracache::Serializer::JsonSerializer.new }
  let(:person) { Person.new }

  describe "#serialize" do
    it "serializes object to JSON" do
      serialized_str = serializer.serialize(person) do |obj|
        { :id => obj.id }
      end

      serialized_str.should == "{\"id\":\"1\"}"
    end
  end

  describe "#deserialize" do
    it "deserializes JSON into object hash" do
      obj_hash = serializer.deserialize("{\"id\":1}")

      obj_hash["id"].should == 1
    end
  end
end
