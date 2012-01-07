Ultracache
==========

Ultracache provides model-level interfaces for better abstraction of
your cached data. You can organize and store/fetch cached data easily
through the provided interfaces. You can boost up the response time of
your actions through appropriate caching of persisted data.

Ultracache uses a conventional key-value store as its backend. Currently
it only supports Redis, but we are planning to include other storages
like Memcached into our feature set.

Installation
------------

Add Ultracache to your `Gemfile`.

    gem 'ultracache'

Or, install Ultracache manually with Rubygems.


Configurations
--------------

Generate an initializer for Ultracache in
`config/initializers/ultracache.rb`.

    # config/initializers/ultracache.rb

    Ultracache.config do |config|
      config.storage = Ultracache::Storage::Redis.new(:urls => ['localhost'])
      config.serializer = Ultracache::Serializer::JsonSerializer.new
    end

Usage
-----

Ultracache associates cache with your model objects. Model objects can
have cached attributes or queues of other cached models. You can decide
appropriate method for caching which meets your requirements.

### Cached Attributes

You need to mixin `Ultracache::Cached` module into your model objects to
which you want to associate your cache.

Cached attributes is the simplest form to associate caches with your
models. Here's an example:

    class Person
      include Ultracache::Cached

      has_cached_attribute :cached_colleagues do |obj|
        obj.colleagues.as_json(:with_contact => true)
      end
    end

Keep in mind that return value of presented block is serialized to
a string by the serailizer specified in configurations. If block is not
presented, Ultracache tries to serialize the object with `as_json`
method.

    class Person
      include Ultracache::Cached

      has_cached_attribute :serialized_string # Objects are serialized with Person#as_json
    end

Cached attributes are useful when cost to generate the desired data is
high, like JSON serializations. Once we have noticed severe performance
degradation caused by plain JSON serializations.

### Cached Queues

Cached queue is suitable when your actions require collection of
objects, like the most index actions. Like `has_many` relationship of
ActiveRecord, cached queues are made from a relationship of two model
classes.

    class Person
      include Ultracache::Cached

      has_cached_queue :notifications
    end

    class Notification
      include Ultracache::Cached

      cached_queue_in :person do |obj|
        {
          :id => obj.id,
          :content => obj.content
        }
      end
    end

Cached queues are especially useful when cost to fetch additional data
from your persistent storage is significantly high. Queuries including
referenced relationships of MongoDB or heavy join operations fit for
this type of concerns.

    p = Person.find params[:id]
    notifications = p.notifications

Note that entries in queues are stored as string. If you want to fetch
or modify part of the model objects, you need to deserialize them. 

    p = Person.find params[:id]
    notifications = p.notifications :deserialized => true
    
    notifications.first['content'] # Content cached in your queue previously

### Keeping them with Integrity

Lifecycle of caches generated by Ultracache are synchronized with it of
model objects.  Ultracache adds `save_cache`, `update_cache`,
`destroy_cache` methods to models which include Ultracache::Cached.
These methods are registered as ActiveModel callbacks semantically
corresponding to each method.

By default, contents of cached attributes are updated along with status
of model objects they belong to. On the other hand, you can decide
whether entries in cached queues are updated or not.

Further Documentations
----------------------

Refer comments in source files for more detailed information. We are
preparing detailed documentations which will be published soon.