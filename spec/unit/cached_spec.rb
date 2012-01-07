require "spec_helper"

describe Ultracache::Cached do
  before do
    Ultracache::Configurations.storage = Ultracache::Storage::Redis.new(:urls => ['localhost:6379'])
  end

  context "without model hierarchy" do
    let(:post) { Post.new }

    it "should have a relationships object" do
      Post.relationships.should_not == nil
    end
  end

  context "with model hierarchy" do
    let(:person) { Person.new }
    let(:admin)  { Admin.new }

    context "for parent models" do
      it "has defined relationships" do
        expect{person.cached_name}.to_not raise_error(NoMethodError)
      end

      it "should not have relationships declared in child class" do
        expect{person.cached_permissions}.to raise_error(NoMethodError)
      end

      it "has relationships only in its scope" do
        Person.relationships.keys.should == [:cached_name]
      end
    end

    context "for child models" do
      it "has relationships different to parent class" do
        Admin.relationships.object_id.should_not == Person.relationships.object_id
      end
      it "has defined relationships" do
        expect{admin.cached_permissions}.to_not raise_error(NoMethodError)
      end

      it "has relationships declared in parent class" do
        expect{admin.cached_name}.to_not raise_error(NoMethodError)
      end

      it "has relationships only in its scope" do
        Admin.relationships.keys.map(&:to_s).sort.should == [:cached_name, :cached_permissions].map(&:to_s).sort
      end
    end
  end
end
