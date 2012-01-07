$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

MODELS = File.join(File.dirname(__FILE__), "models")
$LOAD_PATH.unshift(MODELS)

require "mongoid"
require "ultracache"
require "rspec"

Dir[ File.join(MODELS, "*.rb") ].sort.each { |file| require File.basename(file) }

def to_proc(&block)
  block
end
