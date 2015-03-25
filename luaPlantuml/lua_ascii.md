###需求
ascii图形小，可直接嵌入到纯文本中，在各种拷贝复制中不易丢失。
这里用Lua实现一种绘制ascii图形的工具。
现在网上能够找到的：
在线Ascii画图工具：http://www.asciiflow.com/
本地Ascii画图工具：http://www.jave.de/
本地：ASCII Art Maker
它们都是要用鼠标去组合给定的组件来构建的图形，最后再输出为ascii的图形。
而lua的gui绑定不好用，我希望软件不依赖任何gui绑定，只是用Lua标准中的东西，这样拿到脚本后可以直接使用，而不用安装任何sdk，而lua的标准库中又没有gui，所以决定不使用gui。同时不使用gui也有另一个原因，就是用鼠标拖动组合的图形的方式虽然上手容易直观，但是产生的图形容易杂乱无章。

我们将设计和使用一种文本格式（基于json）。这种格式的关键是简洁，同时能够满足定义原理图、流程图、结构图。
然后，用lua实现对这种文本格式的解析和ascii图形绘制，这货叫做lascii。
而后，实现一个简单的边写边预览的工具，lasc
最后，将此格式整合到markdown中去，使得能够直接在markdown文本中编辑图形元信息；

最最后，实现一个可以使用lua来编辑扩展工具的文本编辑器，含有markdown和lascii。

补充：现有的高级的开源的以图形描述语言为基础的画图工具**plantuml**【AWESOME】
（UML）(plantuml.jar, PlantUML_Language_Reference_Guide.pdf)
http://zhuanlan.zhihu.com/prattle/19900327
http://plantuml.sourceforge.net/

"满足定义原理图、流程图、结构图、类图"？
实际上是满足UML绘制。学习UML的原理有助于提高设计的表达能力。

为了省事，直接使用plantuml的描述语言，可以只支持其中的一小部分(我最常用到的activity graph)，但是结构上要支持扩展。
这样的好处就是，在图形源文件解析和图形绘制能够参考plantuml的实现，同时，源文件在以后既可以生成ascii图形又可以生成PNG。
而且没有了学习和推广的负担。




