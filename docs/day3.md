## day 3


修改reward完成，重复的pass不会导致episode结束，过去的pass内容也加入obs中，让agent学习这些obs。



说一下现在的现状：
    ![img.png](img.png)
    4, 0, 6, 7 后reward不再上涨，reward=6，后续要分析一下这个参数的特征，可能陷入了局部最优。

observation:
    1. 一个38个dialect，开一个38维的向量，记录每个dialect的op数量。
    2. 最长一次能选择的passes数量，比如10个pass，所以再开一个10维的向量，记录每一次的pass是什么。

observation加入2以后，效果不好，reward只能在6左右，以前reward可以到20+。所以，observation恢复到以前的1，或者加入RNN。


新的reward设计：（reward设计的太麻烦了，人家都特别简单，但是我们这里的reward太稀疏了，没办法呀）
- 如果在一个episode中，有重复的param，那么reward -= 10
- 经过一个pass后，如果没有变化，那么rew -= 10
- 经过一个pass后，如果有变化，每个变化的dialect中，rew += 1，如果llvm变化了，额外 rew += 1（因为作用要lower到llvm上）
- 如果中间某个参数作用后，编译失败，rew -= 30
- 如果成功lowering到只剩下{llvm, builtin}dialect，并且builtin中只有1个op，为module，那么reward += 20
- 如果最终成功translate， rew += 50，反之 -= 50

action：
    离散空间的pass_len个向量。
    是否可以重复作用某个pass？



利用plt绘制训练图形，
