
from sys import argv 
import json
import types

def space_str(layer):
    lua_str = ""
    for i in range(0,layer):
        lua_str += '\t'
    return lua_str

def dic_to_lua_str(data,layer=0):

    d_type = type(data)
    if  d_type is types.StringTypes or d_type is str or d_type is types.UnicodeType:
        return "'" + data + "'"
    elif d_type is types.BooleanType:
        if data:
            return 'true'
        else:
            return 'false'
    elif d_type is types.IntType or d_type is types.LongType or d_type is types.FloatType:
        return str(data)
    elif d_type is types.ListType:
        lua_str = "{\n"
        lua_str += space_str(layer+1)
        for i in range(0,len(data)):
            lua_str += dic_to_lua_str(data[i],layer+1)
            if i < len(data)-1:
                lua_str += ','
        lua_str += '\n'
        lua_str += space_str(layer)
        lua_str +=  '}'
        return lua_str
    elif d_type is types.DictType:
        lua_str = ''
        lua_str += "\n"
        lua_str += space_str(layer)
        lua_str += "{\n"
        data_len = len(data)
        data_count = 0
        for k,v in data.items():
            data_count += 1
            lua_str += space_str(layer+1)
            if type(k) is types.IntType:
                lua_str += "['" + str(k) + "']"
            else:
                lua_str += "['" + k + "']" 
            lua_str += ' = '
            try:
                lua_str += dic_to_lua_str(v,layer +1)
                if data_count < data_len:
                    lua_str += ',\n'

            except Exception, e:
                print 'error in ',k,v
                raise
        lua_str += '\n'
        lua_str += space_str(layer)
        lua_str += '}'
        return lua_str
    else:
        print d_type , 'is error'
        return None

def main():
    file = argv[1]
    with open(file) as conf_file:
        content = conf_file.read()
        config = json.loads(content)

    table_content = dic_to_lua_str(config)
    table = "local _M = {}\n _M = "
    table += table_content
    table += "\n\nreturn _M"
    print(table)

if __name__ == '__main__':
    main()
