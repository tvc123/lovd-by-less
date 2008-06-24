# fire up starling server with:
#
#  starling -d -P tmp/pids/starling.pid -q tmp/starling
#
require 'memcache'
STARLING = MemCache.new(GlobalConfig.starling_server)
