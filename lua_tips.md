###windows�±���
��Ϊ����������
ע�͵�luac.c�µ�main���ɡ�

###���ؽű�
//script.lua
function t()
    print "hello world"
end

//console
require("script")
t()

###��������
**nil**

**number**
int��float Ĭ�϶���64λ����32λƽ̨�����ó�32λ
ivar = 123
fvar = 3.21
������

**string**
[[string]]��raw string�������\",",'�����ᱻ����
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

**userdata** �û��Զ�������
��c���ݴ洢��Lua�����С�
ֻ��ͨ��C API���ܴ������޸�userdata��
������ʽ��1��block of memory 2)a C pointer

**table**
��

**coroutine**
interesting

###userdata

###coroutine

###table


