require 'active_model'
require 'active_support/core_ext'
require 'json'

require 'ultracache/configurations'
require 'ultracache/storage/redis'
require 'ultracache/serializer/base'
require 'ultracache/serializer/json_serializer'
require 'ultracache/serializer/active_support_json_serializer'
require 'ultracache/macro'
require 'ultracache/cached'
require 'ultracache/relationships'
require 'ultracache/relationship'
require 'ultracache/relationship/belongs_as_cached_queue'
require 'ultracache/relationship/has_cached_queue'
require 'ultracache/relationship/has_cached_attribute'

if defined?(Rails)
  require "ultracache/railtie"
end

module Ultracache
  class << self
    def config
      yield Configurations
    end

    alias :configuration :config
  end
end
