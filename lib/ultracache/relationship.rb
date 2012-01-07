module Ultracache
  class Relationship
    attr_reader :name

    def initialize(name, options={})
      @name = name
      @self_class = options[:self_class].to_s
      @associated_class = options[:associated_class].to_s
    end

    def self_class
      @self_class.camelize.constantize
    end

    def associated_class
      @associated_class.camelize.constantize
    end

    def read_cache(obj, options = {}); end
    def save_cache(obj); end
    def destroy_cache(obj); end
    def update_cache(obj); end
  end
end
