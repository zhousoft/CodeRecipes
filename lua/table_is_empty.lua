--[[ 
    判断table是否为空
    不能使用 if t == {} 来判断，实际上比较的是t和一个
    匿名table，结果永远为false
    用#t的方法来判断table长度只能统计table中默认key为数字的元素个数（相当于list）
    如 t = {"a","c"="b","d"}, #t = 2
    t = {"a","b",2="c"}, #t = 2
    不要在table中用nil来删除元素，会导致#t出现奇怪问题
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
