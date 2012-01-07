module Ultracache
  # This class contains configurations for Ultracache. Proper configurations
  # should be set before caching objects and attributes you need.
  #
  # Put configurations for your Rails project into initializer:
  #
  #     # config/initializers/ultracache.rb
  #     Ultracache.config do |config|
  #       config.storage = Ultracache::Storage::Redis.new
  #       config.serializer = Ultracache::Serializer::JsonSerializer.new
  #     end
  #
  # Configurable attributes include `storage` and `serializer` for now.
  class Configurations
    class << self
      # Setter for storage handler of Ultracache.
      def storage=(storage)
        @storage = storage
      end

      # Getter for storage handler of Ultracache.
      def storage
        @storage
      end

      # Setter for serializer of Ultracache.
      # `Ultracache::Serializer::JsonSerializer` is set as default value.
      def serializer=(serializer)
        @serializer = serializer
      end

      # Getter for serializer of Ultracache.
      def serializer
        @serializer
      end

      def relationships_container
        @relationships ||= Hash.new
      end

      def add_relationships(klass)
        unless relationships_container[klass]
          rs = Relationships.new(klass)
          relationships_container[klass] = rs
          rs
        else
          nil
        end
      end

      def find_relationships(klass, options = {})
        rs_set = []

        relationships_container.each do |k, rs|
          if klass == k
            return rs if options[:strict]
            rs_set << rs
          end
        end

        return nil if options[:strict]

        relationships_container.each do |k, rs|
          if klass <= k
            rs_set << rs
          end
        end

        if rs_set.empty?
          nil
        else
          rs_set.inject(Relationships.new(klass)) do |base, rs|
            base.merge(rs)
          end
        end
      end
    end
  end
end
