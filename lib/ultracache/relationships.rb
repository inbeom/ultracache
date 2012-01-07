module Ultracache
  class Relationships
    attr_reader :klass
    attr_reader :relationships

    def initialize(klass, rs = {})
      @relationships = rs
      @klass = klass
    end

    def add(relationship)
      @relationships[relationship.name] = relationship
    end

    def keys
      @relationships.keys
    end

    def find(name)
      @relationships[name]
    end
    alias [] find

    def each
      @relationships.each do |k,v|
        yield k, v
      end
    end

    def merge(another)
      klass = if another.klass >= @klass
        @klass
      else
        another.klass
      end

      Relationships.new(klass, @relationships.merge(another.relationships))
    end
    alias | merge
  end
end
