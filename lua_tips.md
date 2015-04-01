###windows下编译
作为解释器编译
注释掉luac.c下的main即可。

###加载脚本
//script.lua
function t()
    print "hello world"
end

//console
require("script")
t()

###数据类型
**nil**

**number**
int或float 默认都是64位，在32位平台需配置成32位
ivar = 123
fvar = 3.21
布尔量

**string**
[[string]]是raw string，里面的\",",'都不会被处理
	print([[helloworld]])//>>helloworld
	print([["helloworld"]])//>>"helloworld"
	print("\"helloworld\"")//>>"helloworld"

	a = [[ a new line 
		is ok 
		" \" 'cool'
		]]
	print(a)

	output:
		a new line 
		is ok 
		" \" 'cool'
**comment**

	// single line comment
	--[[ multi 
			line
				comment ]]--
	--[**[  arr[arr2[idx]] is dirty ]**]--

**function**
written in Lua or C

**userdata** 用户自定义数据
让c数据存储在Lua对象中。
只有通过C API才能创建或修改userdata。
两种形式：1）block of memory 2)a C pointer

**table**
表

**coroutine**
interesting

###userdata

###coroutine

###table


