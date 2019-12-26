# $redis = Redis::Namespace.new("site_point", :redis => Redis.new)
$redis = Redis.new(:redis => Redis.new)