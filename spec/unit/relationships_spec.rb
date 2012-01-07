require "spec_helper"

describe Ultracache::Relationships do
  let(:relationship_1) { Ultracache::Relationship.new(:attr_1) }
  let(:relationship_2) { Ultracache::Relationship.new(:attr_2) }
  let(:relationships) { Ultracache::Relationships.new(Person) }

  let(:relationships_admin) { Ultracache::Relationships.new(Admin) }
  let(:relationship_3) { Ultracache::Relationship.new(:attr_3) }

  it "is initialized with class" do
    rs = Ultracache::Relationships.new(Person)
    rs.klass.should == Person
  end

  it "is initialized with optional hash" do
    rs = Ultracache::Relationships.new(Person, :attr_1 => relationship_1)
    rs.relationships.should == { :attr_1 => relationship_1 }
  end

  describe "#add" do
    it "adds relationship objects to self" do
      relationships.add(relationship_1)
      relationships.relationships.should == { :attr_1 => relationship_1 }
    end
  end

  describe "#keys" do
    it "returns all key values contained in the relationships object" do
      relationships.add(relationship_1)
      relationships.add(relationship_2)

      relationships.keys.map(&:to_s).sort.should == [:attr_1, :attr_2].map(&:to_s).sort
    end
  end

  describe "#find" do
    it "finds desired relationship" do
      relationships.add(relationship_1)
      relationships.add(relationship_2)

      relationships.find(:attr_1).should == relationship_1
    end
  end

  describe "#merge" do
    before(:each) do
      relationships.add(relationship_1)
      relationships.add(relationship_2)
      relationships_admin.add(relationship_3)
    end

    it "concatenates two relationships" do
      rs = relationships.merge(relationships_admin)

      rs.relationships.should == {
        :attr_1 => relationship_1,
        :attr_2 => relationship_2,
        :attr_3 => relationship_3
      }
    end

    it "makes merged relationships to have child class as its label" do
      rs_1 = relationships.merge(relationships_admin)
      rs_1.klass.should == Admin

      rs_2 = relationships_admin.merge(relationships)
      rs_2.klass.should == Admin
    end
  end

end
