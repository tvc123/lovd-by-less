require 'ostruct'
require 'yaml'

config = OpenStruct.new(YAML.load_file("#{RAILS_ROOT}/config/global_config.yml"))
env_config = config.send(RAILS_ENV)
config.common.update(env_config) unless env_config.nil?
::GlobalConfig = OpenStruct.new(config.common)