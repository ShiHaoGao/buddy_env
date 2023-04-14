## TODO

- 将observation获取的方式换成神经网络（因为我们也不知道得到什么信息好一点）
- 全部加上type hints
- 如何输出全部的dialects，因为我想要拿到全部的dialect，然后做成list作为observation

对于observation的处理：
1. 首先建立一个dict，存储所有dialect的名称和下标。
2. observation中，存一个一个数值数组，对应  
3. 可以写一个wrapper来处理对应关系，env环境中，直接输出最容易得到的observation

observation:


现在的问题是：
一、observation应该如何设计

`{'dialect_name':'llvm', 'ops':[('op_name', 'op_num'), ..., () ]}`

1. 一种是像上面那样，获取dialects和op和对应的数量，但是有一点，就是gym中space是静态长度，不能增减。（想要动态增减）
2. 只获取dialect，这样只需要开一个固定大小的映射数组，映射dialect名称。

二、reward的设计问题
1. 以前的想法是：只要mlir文件有变化就奖励
2. 前几天的想法是：如果dialect数有减少，就奖励；变多了就惩罚
3. 现在的想法是：如果dialect数变少了，有奖励；经过一个step，新出现llvm的op就奖励（原因是：最重要把代码lowering到
llvm dialect上。）（但是，需要observation能够获得相应的信息）
4. 一些新的想法：
算reward需要用op，而observation，只需要dialect name即可
这就意味着，我可以在info中，给出各个op及其数量。
而observation中只需要给出dialect就可以啦！

三、action的设计问题
这个还算好办，把参数空间的所有参数都load进来，开一个Discrete静态离散数组，映射每一个参数。



- [x] 看看gym的info, 可以用info来表示op，那么observation中就可以不出现op（虽然我觉得observation中最好能有op的信息）
- [ ] 看看Tianshou中的环境有什么变化吗。（写报告，就用atari写个例子）
- [ ] 看看compilerGym中有什么新的思路。（写报告）

四、设计方案
observation中只包括dialect的集合，在info中来包含一个可变dict，用来表示{'op':3, ... , }


```json5
{
  'affine': {'apply': '1'}, 'arith': {'addf': '1', 'constant': '8', 'mulf': '1'}, 'builtin': {'module': '1'}, 
 'func': {'call': '5', 'func': '4', 'return': '3'}, 'linalg': {'conv_2d': '1', 'yield': '1'},  
 'memref': {'alloc': '1', 'cast': '1', 'dealloc': '3', 'store': '1'}, 'scf': {'for': '2', 'yield': '2'}
}

```
{'affine': {'apply': '1'}, 'arith': {'addf': '1', 'constant': '8', 'mulf': '1'}, 'builtin': {'module': '1'}, 'func': {'call': '5', 'func': '4', 'return': '3'}, 'linalg': {'conv_2d': '1', 'yield': '1'}, 'memref': {'alloc': '1', 'cast': '1', 'dealloc': '3', 'store': '1'}, 'scf': {'for': '2', 'yield': '2'}}


更新设计方案：
暂定目标是lowering到llvm dialect上，
所以，reward的设计应该体现上面一点，因此
1. 记录上一状态的信息，

-----------------------------------------------------------------------------------


## TODO:
1. 引入CompilerGym，用它的namedDiscrete描述action_space
2. observation中我想了想，还是要带着op的信息，但是没有固定长度十分的难受，有没有一种能获取某个dialect的所有op的操作？
3. 如果要带op的信息，那么就需要开一个二维数组，表示某个dialect的某个op出现的次数。
4. reward的计算很是麻烦，要指引其lowering到llvm(现阶段)，后期加入计算时间当权重。

## 进度：
1. 环境基本上能完成，完全按照gym的API接口，但是reward的设计十分难搞
2. RL算法的实现（rainbow DQN）已经大致了解，随时可以完成。但是打算用Tianshou这个开源RL框架。


## 问题：
1. 环境的搭建问题：
现在已经熟悉了gym的API，又看了CompilerGym中的描述，发现CompilerGym中对于mlir的支持还在生产中，所以，我打算，
利用CompilerGym中对于gym的包装，创建一个环境

2. observation的问题：
究竟需要从文本中取得什么信息，什么信息是关键的？
现阶段还只是采用从mlir文本中抓取相关dialect和op。
我觉得以后可以通过神经网络自动提取出observation，但是这又是一个难题。（可能这个网络得需要和整个模型一块训练）
或者手写一个能识别出控制流图的程序。observation应该怎么设计呢？？

3. reward的计算问题
有了dialect和其对应的op和数量，那应该怎么设计reward呢？
现在的想法是，要lowering到llvm上，所以：
   1. 只要新出现了llvm的op，就给正reward；
   2. 没有新出现llvm的op，但是整个mlir文件有变化，给一个小的正reward；
   3. 最后，能够运行给一个大的正reward。
   4. 不符合以上情况就给父reward。

-------------------------------------------------------------------------

1. 把self.test函数写完，测试是否能运行。可以用一个已经转换好的mlir看看最大reward是多大。
2. 写一个Tianshou的例子
3. 看一下CompilerGym，用一下这个CompilerGym（这个优先级不高）
4. 用Tianshou配合一下我这个环境
5. 再过一下gym的教程，看看有什么漏的地方
6. wrapper看看怎么设计一下（借助CompilerGym和Tianshou中的wrapper）


现在reward的设计，在经过一个pass之后：
1. 如果新出现一个dialect，reward += 1；如果dialect是llvm的话，再reward += 1，鼓励快速下降到llvm
2. 如果少了一个dialect，reward += 1
3. 如果这个dialect没多没少，那么如果其op有变化，那么reward += 1；如果是llvm的话，再reward += 1
4. 如果什么都没有变化，reward = -1
5. 如果执行报错的话（参数作用后报错，不能继续），reward -= 30
6. 如果最后利用mlir-translate可以执行的话，reward += 50



写wrapper：
1. 记录所有action的wrapper，
2. 记录所有reward的wrapper
3. 检查action，不可以有重复action的wrapper。如果有重复直接扣大分。