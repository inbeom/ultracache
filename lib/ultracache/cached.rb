module Ultracache
  # This class should be included to model classes related to cache. It adds
  # primitive methods, attributes and callbacks required for caching.
  #
  # Example:
  #
  #     class Person < ActiveRecord::Base
  #       include Ultracache::Cached
  #
  #       # Cache definitions ...
  #     end
  #
  # Including this class adds a Relationships object which is stored into
  # Ultracache::Configurations. Every relationship added to the class is
  # represented by a Relationship object inside Relationships object regarding
  # the class.
  module Cached
    extend ActiveSupport::Concern

    include Macro

    included do
      extend ActiveModel::Callbacks
      define_model_callbacks :create, :update, :destroy

      after_create :save_cache
      after_update :update_cache
      after_destroy :destroy_cache

      unless Ultracache::Configurations.find_relationships(self, :strict => true)
        Ultracache::Configurations.add_relationships(self)
      end
    end

    # Read cache from storage. Cache to read is specified by the `name` parameter.
    # Relationship object should exist in Relationships related to the class.
    def read_cache(name, options={})
      relationship = self.class.relationships.find(name.to_sym)
      strings = relationship.read_cache(self, options)

      if options[:deserialized]
        return strings.map do |str|
          Ultracache::Configurations.serializer.deserialize str
        end
      else
        return strings
      end
    end

    # Save caches of all relationships assigned to the class. If `:only` option is
    # provided, only caches specified in the option are saved.
    #
    # Example
    #
    #     p = Person.find params[:id]
    #     p.save_cache # Saves all caches related to Person class
    #     p.save_cache :only => [:cached_name] # Saves cached_name only
    #
    # `save_cache` is registered as `after_save` callback for ActiveModel classes
    # which mixin `Ultracache::Cached`.
    def save_cache(options = {})
      target = self.class.relationships.keys
      target &= options[:only] if options[:only]

      target.each do |name|
        self.class.relationships[name].save_cache(self)
      end
    end

    # Remove all cache related to the object from the storage. `destroy_cache` is
    # registered as `after_destroy` callback for ActiveModel classes which mixin
    # `Ultracache::Cached`.
    def destroy_cache
      self.class.relationships.each do |name, relationship|
        relationship.destroy_cache(self)
      end
    end

    # Updates all cache related to the class, like `save_cache` does. `:only`
    # option also can be used for this method. This method is registered as
    # `after_update` callback.
    def update_cache(options = {})
      target = self.class.relationships.keys
      target &= options[:only] if options[:only]

      target.each do |name|
        self.class.relationships[name].update_cache(self)
      end
    end

    module ClassMethods
      # Finds all Relationship objects associated with the class. The relationships
      # include cache associations defined in parent classes of the caller class.
      # A new Relationships object is created as return value of this method.
      def relationships(options = {})
        rs = Ultracache::Configurations.find_relationships(self, options)
        return Ultracache::Configurations.add_relationships(self) unless rs
        rs
      end
    end
  end
end
