module Ultracache
  class HasCachedQueue < Relationship
    attr_reader :fetch_by

    def initialize(name, options={})
      @fetch_by = options[:fetch_by]
      super(name, options)
    end

    def key(obj)
      "#{@self_class.to_s.underscore}:#{obj.id}:#{@name}"
    end

    # Reads caches stored in corresponding queue. Caches can be fetched by
    # their score or their rank.
    def read_cache(obj, options = {})
      k = self.key(obj)

      fetch_by = @fetch_by || options[:fetch_by]
      result = if fetch_by && fetch_by == :rank
        storage.get_queue_by_rank(k, options)
      elsif options[:per_page]
        storage.get_queue_paged(k, options)
      else
        storage.get_queue(k, options)
      end

      if options[:deserialized]
        result.map { |str| serializer.deserialize(str) }
      else
        result
      end
    end
  end
end
