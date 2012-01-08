require 'redis'
require 'redis/distributed'
require 'json'

module Ultracache
  module Storage
    class Redis
      def initialize(options = {})
        @urls = options[:urls] || ['redis://localhost:6379/1']
      end

      def connection
        @connection ||= ::Redis::Distributed.new(@urls)
      end

      def set(id, doc)
        connection.set(id, doc)
      end

      def get(id)
        connection.get(id)
      end

      def multi_get(*ids)
        connection.mget(ids)
      end

      def del(id)
        connection.del(id)
      end

      def get_queue(id, opts={})
        connection.zrevrangebyscore(id, opts[:to] || "+inf", opts[:from] || "-inf")
      end

      def get_queue_paged(id, opts={})
        per_page = opts[:per_page] || 20
        page = opts[:page] || 1
        offset = per_page.to_i * (page.to_i - 1)

        connection.zrevrangebyscore(id, opts[:to] || "+inf", opts[:from] || "-inf", :limit => [offset, per_page])
      end

      def remove_from_queue_by_range(id, opts={})
        connection.zremrangebyscore(id, opts[:from], opts[:to])
      end

      def remove_from_queue(id, val)
        connection.zrem(id, val)
      end

      def get_queue_by_rank(id, opts={})
        connection.zrevrange(id, opts[:from] || 0, opts[:to] || -1)
      end

      def put_queue(id, key, entry)
        connection.zadd(id, key, entry)
      end
    end
  end
end
