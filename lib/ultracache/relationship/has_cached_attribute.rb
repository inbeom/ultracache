module Ultracache
  class HasCachedAttribute < Relationship
    def initialize(name, block, options={})
      super(name, options)
      @serializer_method = options[:serializer]
      @serializing_block = block if block_given?

      @serializer = Ultracache::Configurations.serializer
      @storage = Ultracache::Configurations.storage
    end

    def key(obj)
      "#{@self_class.to_s.underscore}:#{obj.id}:#{@name}"
    end

    # Save serialized attribute to cache. If serializer method or serialization
    # block is not given, Ultracache tries to serialize the object by
    # serializeing hash returned by its `as_json` method.
    def save_cache(obj)
      value = if @serializer_method
        @serializer.serialize(obj.send(@serializer_method))
      elsif @serializing_block
        @serializer.serialize(@serializing_block.call(obj))
      else
        @serializer.serialize(obj.as_json)
      end

      @storage.set(key(obj), value)
      value
    end

    # Read stored cache from storage. If the cache is not found, it tries to
    # save corresponding cache to storage and return its value
    def read_cache(obj, options = {})
      k = key(obj)

      @storage.get(k) || save_cache(obj)
    end

    # Destroys cache from storage
    def destroy_cache(obj)
      @storage.del(key(obj))
    end

    # Updates value of existing cache. Its behavior is same with that of
    # `save_cache`.
    def update_cache(obj)
      save_cache(obj)
    end
  end
end
