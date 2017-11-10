lua_shared_dict my_limit_req_zone 100m;

access_by_lua_block{
    local limit_req = require "resty.limit.req"
    local ngx_re_find = ngx.re.find
    local rate = 1 --固定平均速率 1r/s
    local burst = 1 --桶上限
    local error_status = 444
    local nodelay = true
    
    local lim, err = limit_req.new("my_limit_req_zone", rate, burst)
    if not lim then
    local user_ip = ngx.var.binary_remote_addr
    local uri = ngx.var.uri
    if ngx.re.find(uri, "/search", 'isjo') == nil then
        return 
    end 
    local key = user_ip .. uri --ip+uri限流
    local host = ngx.var.host
    local delay, err = lim:incoming(key,true)
    if not delay and err == "rejected" then --超出桶大小
        ngx.redirect("http://"..host)
        ngx.exit(200)
    end
    
    if delay >= 0.001 then 
        if nodely then --是否延迟处理
            ngx.redirect("http://"..host)
            ngx.exit(200)
        else
            --第二个参数返回超出设置的突发流量数
            --如设置速率为100r/s 进来153个请求
            --第二个参数为53
            local excess = err
            ngx.sleep(delay) --延迟处理
        end
    end
}