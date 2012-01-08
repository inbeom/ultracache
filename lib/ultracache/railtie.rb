require 'rails'

begin; require 'mongoid'; rescue LoadError; end

module Rails
  module Ultracache
    class Railtie < Rails::Railtie
      initializer 'ultracache' do |app|
        if defined? ::Mongoid
          require File.join(File.dirname(__FILE__), 'models/mongoid_extension.rb')
          ::Mongoid::Document.send :include, ::Ultracache::Models::MongoidExtension
        end
      end
    end
  end
end
