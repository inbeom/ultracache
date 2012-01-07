require "spec_helper"

describe Ultracache::Configurations do
  let(:config) do
    Ultracache::Configurations
  end

  let(:redis_storage) do
    Ultracache::Storage::Redis.new(:urls => ['localhost:6379'])
  end

  let(:json_serializer) do
    Ultracache::Serializer::JsonSerializer.new
  end

  it "cannot be initialized" do
    Ultracache::Configurations.new.should raise_error(NoMethodError)
  end

  describe "#storage=" do
    it "sets storage object for ultracache" do
      config.storage = redis_storage

      Ultracache::Configurations.storage.should == redis_storage
    end
  end

  describe "#serializer=" do
    it "sets serializer object for ultracache" do
      config.serializer = json_serializer

      Ultracache::Configurations.serializer.should == json_serializer
    end
  end

  describe "#add_relationships" do
    it "adds relationships object for the specified class" do
      config.add_relationships(Post)
      container = config.send :relationships_container
      container[Post].relationships.should == {}
    end
  end

  describe "#find_relationships" do
    it "finds relationships object associated with the specified class" do
      config.find_relationships(Post).relationships.should == {}
    end
  end
end
