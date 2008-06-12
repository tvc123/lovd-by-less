
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
  config.active_record.observers = :user_observer
  
  # Make Active Record use UTC-base instead of local time
  config.active_record.default_timezone = :utc
    
end

