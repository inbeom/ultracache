require 'active_support/json'

module Ultracache
  module Serializer
    class ActiveSupportJsonSerializer
      def serialize(obj, &block)
        obj = block.call(obj) if block_given?
        obj.to_json
      end

      def deserialize(serialized_object)
        ActiveSupport::JSON.decode(serialized_object)
      end
    end
  end
end
