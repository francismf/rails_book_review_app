module BooksHelper

	def set_cache_objects(key,value)
		$redis.set("#{key}", Marshal.dump(value))
		$redis.expire("#{key}",1.hour.to_i)
	end

	def get_cache_objects(key)
		Marshal.load($redis.get("#{key}"))
	end
end
