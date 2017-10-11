--[[ 
    判断table是否为空
    不能使用 if t == {} 来判断，实际上比较的是t和一个
    匿名table，结果永远为false
--]] 

function table_is_empty(t)
    if t ~= nil then
        if type(t) == 'table' and #(t) == 0 then
            return true
        end
        return false
    else
        return true
    end
end
