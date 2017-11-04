local limit_req = require "resty.limit.req"
local rate = 100 --固定平均速率 100r/s
local burst = 150 --桶上限
local error_status = 444
local nodelay = false

local lim, err = limit_req.new("limit_req_zone", rate, burst)

local key = ngx.var.binary_remote_addr .. ngx.var.uri --ip+uri限流
local delay, err = lim:incoming(key,true)
if not delay and err == "rejected" then --超出桶大小
    ngx.exit(error_status)
end

if delay >= 0.001 then 
    if nodely then --是否延迟处理
        ngx.exit(error_status)
    else
        --第二个参数返回超出设置的突发流量数
        --如设置速率为100r/s 进来153个请求
        --第二个参数为53
        local excess = err
        ngx.sleep(delay) --延迟处理
    end
end
