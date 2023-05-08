
现在reward的设计，在经过一个pass之后：
1. 如果新出现一个dialect，reward += 1；如果dialect是llvm的话，再reward += 1，鼓励快速下降到llvm
2. 如果少了一个dialect，reward += 1
3. 如果这个dialect没多没少，那么如果其op有变化，那么reward += 1；如果是llvm的话，再reward += 1
4. 如果什么都没有变化，reward = -1
5. 如果执行报错的话（参数作用后报错，不能继续），reward -= 30
6. 如果最后利用mlir-translate可以执行的话，reward += 50


未来的observation设计：
`{'dialect_name' : op_num, ..., }`这种形式，
或者，如果我们可以获知dialect中有多少个op的话，就可以选取
最大的op数。（因为我们要固定大小的obs）

2023年4月16日改动

- [x] 修改info格式，加入state，表示程序状态是否正常。
- [x] 修改observation格式，加入op信息。
- [x] 添加wrapper(不需要写wrapper)
- [ ] 测试PPO
- [x] 完善reset，reset代表一个episode结束，需要清空一些参数
- [x] 修改action_space，变成一个tuple，存参数序列。这是为了限制最大长度（不需要）但是每次step中，都要用episode_pass来当参数。
- [x] 完成新的reward设计
- [x] 完成test函数测试


新的reward设计：（reward设计的太麻烦了，人家都特别简单，但是我们这里的reward太稀疏了，没办法呀）
- 如果在一个episode中，有重复的param，那么reward -= 10
- 经过一个pass后，如果没有变化，那么rew -= 10
- 经过一个pass后，如果有变化，每个变化的dialect中，rew += 1，如果llvm变化了，额外 rew += 1（因为作用要lower到llvm上）
- 如果中间某个参数作用后，编译失败，rew -= 30
- 如果成功lowering到只剩下{llvm, builtin}dialect，并且builtin中只有1个op，为module，那么reward += 20
- 如果最终成功translate， rew += 50，反之 -= 50


问题：
1. 如何设定最大的pass_step，在哪里检查这个长度
2. 如何保证pass在一个episode中不重复   通过给punish，在训练中减少重复选择param


wrapper：
1. resetWrapper：在出现文件错误后，在计算完reward后，就要调用close和reset重新设置环境。注意，observation和action space都要重置。
2. actionWrapper: 记录一个episode内的action sequence
3. uniqueActionWrapper: 在一个episode中不允许重复，重复则扣分
4. rewardWrapper：记录一个episode内的reward sequence
5. 最大步长wrapper:在到达最大步长以后，失败，fail，扣分，然后，把step中的代码看一看