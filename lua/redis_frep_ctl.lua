--redis lua脚本 返回限流状态 0-限制 1-未限制
local redis_script = [[
    local key = KEYS[1] 
    local limit = tonumber(ARGV[1])
    local expired = tonumber(ARGV[2])
    local current = tonumber(redis.call('get', key) or 0)

    if current + 1 > limit then 
        return 0
    else
        redis.call('incr', key)
        redis.call('expire', key, expired)
        return 1
    end
]]


local function limit_by_redis_script(rule, limit_type, script_hash)
    local redis_host = context.config.redis_server.host --从全局变量中读取配置
    local redis_port = context.config.redis_server.port
    local max_idle_timeout = context.config.redis_server.max_idle_timeout
    local pool_size = context.config.redis_server.pool_size
    local con_timeout = context.config.redis_server.con_timeout
    local limit_key = rule.id .. "#" .. limit_type
    local handle = rule.handle
    local red = redis:new()    
    red:set_timeout(con_timeout)
    local ok, err = red:connect(redis_host, redis_port)
    if not ok then
        return false
    end
    if not script_hash then
        local res,err = red:eval(redis_script, 1, limit_key, handle.count, handle.period)
        if res == nil or res == false then
            ngx.log(ngx.ERR,"excute scrpit error ", err)
            return false
        elseif res == 0 then
            if handle.log == true then
                ngx.log(ngx.INFO, "[RateLimiting-Forbidden-Rule] ", rule.name,  " limit:", handle.count)
            end
            ngx.header["X-RateLimit-Remaining" .. "-" .. limit_type] = 0
            red:set_keepalive(max_idle_timeout,pool_size)
            return ngx.exit(429)
        else
            ngx.log(ngx.NOTICE,"res ",res,"err ",err)
            ngx.header["X-RateLimit-Remaining" .. "-" .. limit_type] = handle.count - res - 1
            return false
        end 
    end

end