module Ultracache
  module Macro
    extend ActiveSupport::Concern

    module ClassMethods
      def cached_queue_in(another, options={}, &block)
        name = options[:as] ? options[:as] : self.to_s.underscore
        relationship = BelongsAsCachedQueue.new name, block, :self_class => self,
          :need_update => options[:need_update], :unless => options[:unless],
          :associated_class => another

        self.relationships(:strict => true).add(relationship)
      end

      def has_cached_queue(another, options={})
        name = options[:as] ? options[:as] : another
        relationship = HasCachedQueue.new name, :self_class => self,
          :associated_class => options[:class] ? options[:class] : another

        self.relationships(:strict => true).add(relationship)

        define_method name do |*options|
          read_cache(name, options.first || {})
        end
      end

      def has_cached_attribute(name, options={}, &block)
        relationship = HasCachedAttribute.new name, block, :self_class => self,
          :serializer => options[:serializer]

        rs = self.relationships(:strict => true)
        self.relationships(:strict => true).add(relationship)

        define_method name do |*options|
          read_cache(name, options.first || {})
        end
      end
    end
  end
end
