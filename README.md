# luadoc53zh
lua5.3 manual 翻译 @tp-mobile “提升计划”

- 翻译manual，参考了cloudwu的翻译；
- 绑定某个库到lua；

现在有一些自动绑定工具。。
tolua++
这个东西需要在编译前执行某工具预处理什么什么的。
它的意思就是会根据我们对导出接口的配置文件来自动生成代码。
然后我们将这些自动生成代码和原来自己的cpp代码一起编译。
比较可靠。

luabind
这货使用了boost的模板库，它不需要在编译前执行代码生成，而是使用了模板元编程技术。
有两个问题，1，要依赖boost，意味着对cpp11不友好；2，编译器不一定完全支持；3，编译速度很慢；

luaTinker
泡菜写的只有2个文件就能搞定的，但是功能较少，但够用就好的。
问题在于它对手动绑定而言方便了多少呢？
十分有趣。看下面代码后你会发现这个luaTinker牛逼啊。
KISS!!!

// 一个基类
struct base
{
 base() {}

 const char* is_base(){ return "this is base"; }
};

// 一个测试类
class test : public base
{
public:
 test(int val) : _test(val) {}
 ~test() {}

 const char* is_test(){ return "this is test"; }

 void ret_void() {}
 int ret_int()   { return _test;   }
 int ret_mul(int m) const { return _test * m;  }
 A get()    { return A(_test);  }
 void set(A a)   { _test = a.value;  }
 int _test;
};

int main()
{
 // 注册base类型到LUA
 lua_tinker::class_<base>("base")
  .def("is_base", &base::is_base)
  ;
 
 // 注册test类型到LUA,注册test的成员函数和成员变量
 lua_tinker::class_<test>("test")
  .inh<base>() // 注册继承类
  .def(lua_tinker::constructor<int>()) //注册构造函数
  .def("is_test", &test::is_test)           // 注册成员函数
  .def("ret_void", &test::ret_void)
  .def("ret_int", &test::ret_int)
  .def("ret_mul", &test::ret_mul)
  .def("get", &test::get)
  .def("set", &test::set)
  .def_readwrite("_test", &test::_test) // 注册成员变量
  ;

 test g_test(11);
 
 lua_tinker::decl("g_test", &g_test);
 
}

// Lua脚本
temp = test(4)  创建一个test类
print(temp._test) 打印test的_test成员

print(g_test)     
print(g_test._test) 打印g_test的成员变量_test
print(g_test:is_test()) 输出信息  
print(g_test:ret_int()) 返回g_test的成员变量_test