REDIS_CONFIG = YAML.load( File.open( Rails.root.join("config/redis.yml") ) ).symbolize_keys
dflt = REDIS_CONFIG[:default].symbolize_keys
cnfg = dflt.merge(REDIS_CONFIG[Rails.env.to_sym].symbolize_keys) if REDIS_CONFIG[Rails.env.to_sym]
$redis = Redis.new(cnfg)
$redis_ns = Redis::Namespace.new(cnfg[:namespace], redis: $redis) if cnfg[:namespace] == "think_linkapp_test"
$redis_ns.flushdb if Rails.env == "test"