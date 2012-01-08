require 'json'

module Ultracache
  module Serializer
    class JsonSerializer < Serializer::Base
      def serialize(obj, &block)
        obj = block.call(obj) if block_given?
        JSON.generate(obj)
      end

      def deserialize(serialized_object)
        JSON.parse(serialized_object)
      end
    end
  end
end
