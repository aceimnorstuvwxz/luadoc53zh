#lua面向对象
lua在语言层面并不支持面向对象。
http://www.cnblogs.com/stephen-liu74/archive/2012/03/28/2421656.html

##面向对象的特性
成员变量，成员函数

##用table模拟class

*错误的模拟*
	account = {money=100}
	account.withdraw = function (howmuch)
		account.money = account.money - howmuch
    	print ("money left="，account.money)
	end
	account.withdraw(50) //>>50

因为这里的inner function 使用了具名的account作为一个upvalue在其closure中，所以问题来了。
如果执行：
	a = account
	account = nil
	a.withdraw(50)//error: attempt to index a nil value (global 'account')

*加强的模拟*
	account = {money=100}
	account.withdraw = function (self, howmuch)
		self.money = self.money - howmuch
		print ("money left=", self.money)
	end
	account.withdraw(account,10) //money left=90
	a = account
	account = nil
	a.withdraw(a,10) //money left=80

*syntactic sugar*
	a:withdraw(10) //money left=70

*进一步加强*
上面在类方法定义时，还是需要显式地传入self作为首参数。
而实际上table::method的方法依旧在method定义时有效。
	account = {money = 100}
	function account:withdraw(howmuch)
		self.money = self.money - howmuch
		print ([[money left]], self.money)
	end

因此，模拟类的成员方法一定是standalone的，对任何非作为参数传入的值的使用都要格外小心。

总之，如果以.来调用函数，那么要加入self，如果以":"来调用函数，self是隐含的。函数定义时也有类似效果。

///////////////////////////////////
 Lua中的table就是一种对象，但是如果直接使用仍然会存在大量的问题，见如下代码：

1 Account = {balance = 0}
2 function Account.withdraw(v)
3     Account.balance = Account.balance - v
4 end
5 --下面是测试调用函数
6 Account.withdraw(100.00)
    在上面的withdraw函数内部依赖了全局变量Account，一旦该变量发生改变，将会导致withdraw不再能正常的工作，如：

1 a = Account; Account = nil
2 a.withdraw(100.00)  --将会导致访问空nil的错误。
    这种行为明显的违反了面向对象封装性和实例独立性。要解决这一问题，我们需要给withdraw函数在添加一个参数self，他等价于Java/C++中的this，见如下修改：

1 function Account.withdraw(self,v)
2     self.balance = self.balance - v
3 end
4 --下面是基于修改后代码的调用：
5 a1 = Account; Account = nil
6 a1.withdraw(a1,100.00)  --正常工作。
    针对上述问题，Lua提供了一种更为便利的语法，即将点(.)替换为冒号(:)，这样可以在定义和调用时均隐藏self参数，如:

1 function Account:withdraw(v)
2     self.balance = self.balance - v
3 end
4 --调用代码可改为：
5 a:withdraw(100.00)

    1. 类：
    Lua在语言上并没有提供面向对象的支持，因此想实现该功能，我们只能通过table来模拟，见如下代码及关键性注释：

复制代码
 1 --[[
 2 在这段代码中，我们可以将Account视为class的声明，如Java中的：
 3 public class Account 
 4 {
 5     public float balance = 0;
 6     public Account(Account o);
 7     public void deposite(float f);
 8 }
 9 --]]
10 --这里balance是一个公有的成员变量。
11 Account = {balance = 0}
12 
13 --new可以视为构造函数
14 function Account:new(o)
15     o = o or {} --如果参数中没有提供table，则创建一个空的。
16     --将新对象实例的metatable指向Account表(类)，这样就可以将其视为模板了。
17     setmetatable(o,self)
18     --在将Account的__index字段指向自己，以便新对象在访问Account的函数和字段时，可被直接重定向。
19     self.__index = self
20     --最后返回构造后的对象实例
21     return o
22 end
23 
24 --deposite被视为Account类的公有成员函数
25 function Account:deposit(v)
26     --这里的self表示对象实例本身
27     self.balance = self.balance + v
28 end
29 
30 --下面的代码创建两个Account的对象实例
31 
32 --通过Account的new方法构造基于该类的示例对象。
33 a = Account:new()
34 --[[
35 这里需要具体解释一下，此时由于table a中并没有deposite字段，因此需要重定向到Account，
36 同时调用Account的deposite方法。在Account.deposite方法中，由于self(a对象)并没有balance
37 字段，因此在执行self.balance + v时，也需要重定向访问Account中的balance字段，其缺省值为0。
38 在得到计算结果后，再将该结果直接赋值给a.balance。此后a对象就拥有了自己的balance字段和值。
39 下次再调用该方法，balance字段的值将完全来自于a对象，而无需在重定向到Account了。
40 --]]
41 a:deposit(100.00)
42 print(a.balance) --输出100
43 
44 b = Account:new()
45 b:deposit(200.00)
46 print(b.balance) --输出200
复制代码

    2. 继承：
    继承也是面向对象中一个非常重要的概念，在Lua中我们仍然可以像模拟类那样来进一步实现面向对象中的继承机制，见如下代码及关键性注释：

复制代码
 1 --需要说明的是，这段代码仅提供和继承相关的注释，和类相关的注释在上面的代码中已经给出。
 2 Account = {balance = 0}
 3 
 4 function Account:new(o)
 5     o = o or {}
 6     setmetatable(o,self)
 7     self.__index = self
 8     return o
 9 end
10 
11 function Account:deposit(v)
12     self.balance = self.balance + v
13 end
14 
15 function Account:withdraw(v)
16     if v > self.balance then
17         error("Insufficient funds")
18     end
19     self.balance = self.balance - v
20 end
21 
22 --下面将派生出一个Account的子类，以使客户可以实现透支的功能。
23 SpecialAccount = Account:new()  --此时SpecialAccount仍然为Account的一个对象实例
24 
25 --派生类SpecialAccount扩展出的方法。
26 --下面这些SpecialAccount中的方法代码(getLimit/withdraw)，一定要位于SpecialAccount被Account构造之后。
27 function SpecialAccount:getLimit()
28     --此时的self将为对象实例。
29     return self.limit or 0
30 end
31 
32 --SpecialAccount将为Account的子类，下面的方法withdraw可以视为SpecialAccount
33 --重写的Account中的withdraw方法，以实现自定义的功能。
34 function SpecialAccount:withdraw(v)
35     --此时的self将为对象实例。
36     if v - self.balance >= self:getLimit() then
37         error("Insufficient funds")
38     end
39     self.balance = self.balance - v
40 end
41 
42 --在执行下面的new方法时，table s的元表已经是SpecialAccount了，而不再是Account。
43 s = SpecialAccount:new{limit = 1000.00}
44 --在调用下面的deposit方法时，由于table s和SpecialAccount均未提供该方法，因此访问的仍然是
45 --Account的deposit方法。
46 s:deposit(100)
47 
48 
49 --此时的withdraw方法将不再是Account中的withdraw方法，而是SpecialAccount中的该方法。
50 --这是因为Lua先在SpecialAccount(即s的元表)中找到了该方法。
51 s:withdraw(200.00)
52 print(s.balance) --输出-100