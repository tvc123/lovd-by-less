
RAILS_GEM_VERSION = '2.1.0' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

    # Cookie sessions (limit = 4K)
    config.action_controller.session = {
        :session_key => 'TeachersWithoutBordersSocial',
        :secret      => '8e96e618f8ab81d9bc45b87acbee5d437c93d7f5ed1d7dd867e3c12e1eaf8c045e46a966ad6cb78b5bc621a5e9bf3aa984af0c498fe92c24baa3a945f2b85ad1'
    }

    config.action_controller.session_store = :active_record_store

    # Use SQL instead of Active Record's schema dumper when creating the test database.
    # This is necessary if your schema can't be completely dumped by the schema dumper, 
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Activate observers that should always be running
    # config.active_record.observers = :cacher, :garbage_collector
    config.active_record.observers = :user_observer, :user_plone_observer

    # Make Active Record use UTC-base instead of local time
    config.active_record.default_timezone = :utc

    # configure gems
    config.gem 'builder', :version => '2.1.2'
    config.gem 'will_paginate', :version => '~> 2.2.2'
    config.gem 'colored', :version => '1.1'
    config.gem 'youtube-g', :version => '0.4.1', :lib =>'youtube_g'
    config.gem 'uuidtools', :version => '1.0.3'
    config.gem 'acts_as_ferret', :version => '0.4.3'
    config.gem 'ferret', :version => '0.11.6'
    config.gem 'hpricot', :version => '0.6'
    config.gem 'mocha', :version => '0.5.6'    
    config.gem 'avatar', :version => '0.0.5'
    config.gem 'tzinfo', :veresion => '0.3.9'
    config.gem 'redgreen', :version => '1.2.2'
    config.gem 'rflickr', :lib => 'flickr'
    config.gem 'test-spec', :lib => 'test/spec', :version => '0.9.0'
    config.gem 'RedCloth', :lib => 'redcloth', :version => '3.0.4'
    config.gem 'activerecord-activesalesforce-adapter', :lib => 'active_record', :version => '2.0.0'
    
end

# load in global var here so that initializers can use them
require 'ostruct'
require 'yaml'

config = OpenStruct.new(YAML.load_file("#{RAILS_ROOT}/config/global_config.yml"))
env_config = config.send(RAILS_ENV)
config.common.update(env_config) unless env_config.nil?
::GlobalConfig = OpenStruct.new(config.common)