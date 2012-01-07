require "spec_helper"

describe Ultracache::Relationship do
  it "is initialized with name and options" do
    relationship = Ultracache::Relationship.new :my,
      :self_class => 'Person', :associated_class => 'Admin'

    relationship.name.should == :my
    relationship.self_class.should == Person
    relationship.associated_class.should == Admin
  end
end
