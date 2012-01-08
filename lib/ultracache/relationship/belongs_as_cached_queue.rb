module Ultracache
  class BelongsAsCachedQueue < Relationship
    def initialize(name, block, options={})
      super(name, options)
      @serializer_block = block
      @alias = options[:as]
      @need_update = options[:need_update]
      @unless = options[:unless]
    end

    # Saves serialized form of object into cache queue which the object
    # has a relationship to.
    #
    # The first parameter, `obj`, is the object which will be stored into
    # cache queue. `storage` parameter is 
    #
    # @return Serialized form of the object
    def save_cache(obj)
      return if @unless && obj.send(@unless)

      value = if @serializer_block
        @serializer_block.call obj
      else
        serializer.serialize(obj.as_json)
      end

      storage.put_queue(key(obj), score_of(obj), value)
    end

    # Destroys serialized cache from associated cache queue. In some cases
    # like caching serialized documents of MongoDB, two or more cached objects
    # may have the same score with other documents. To remove cache we want to
    # delete only, we should deal with this problem.
    #
    # If two or more documents are fetched with the computed score,
    # `destroy_cache` deserializes the cached documents in order to find one
    # cache having the same identifier.
    def destroy_cache(obj)
      score = score_of(obj)
      key = key(obj)

      docs = storage.get_queue(key, :from => score, :to => score)

      if docs.count == 1
        # Only one document is fetched from queue, and it is okay to remove
        storage.remove_from_queue_by_range(key, :from => score, :to => score)
      elsif docs.count > 1
        # We should deserialize fetched documents to find the document having
        # the same id with `obj`
        docs.each do |doc|
          deserialized = serializer.deserialize(doc)
          _id = deserialized["id"]
          _id = deserialized["_id"] unless _id

          if _id == obj.id
            storage.remove_from_queue(key, doc)
          end
        end
      end
    end

    # Updates object cache in queue. To update cache, we should destroy the
    # document and regenerate it with updated information.
    def update_cache(obj)
      return unless @need_update
      delete_cache(obj)
      save_cache(obj)
    end

    # Returns key of cache queue which cache of the object will be stored into
    def key(obj)
      associated = @associated_class.to_s.underscore

      namespace = @name
      parent_id = obj.send("#{associated}_id")

      "#{@associated_class.to_s.underscore}:#{parent_id}:#{namespace}"
    end

    protected
      def score_of(obj)
        obj.respond_to?(:cached_queue_score) ? obj.cached_queue_score : obj.id
      end
  end
end

