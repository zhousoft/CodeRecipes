--[[
    lua 循环中实现continue
    注意：5.1版本只在luajit中可以使用
    luajit跟进了lua5.2的一些特性，支持goto和::tables::机制，见http://luajit.org/extensions.html#lua52
]]--

for i=1,3 do
	if i<=2 then 
		print(i)
		goto continue
	end
	::continue::
	print('end')
end