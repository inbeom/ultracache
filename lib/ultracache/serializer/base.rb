module Ultracache
  # Base class
  module Serializer
    class Base

      # Serializes model object. The Object should be converted into
      # a hash containing an id field and required attributes.
      #
      # @param [Hash] obj A hash containing information of an object
      #
      # @return [String] Serialized object
      def serialize(obj, &block); obj.to_s; end

      # Deserializes a string which an object is serialized into to a
      # hash.
      def deserialize(serialized_object); end
    end
  end
end
