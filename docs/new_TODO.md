
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
- [ ] 添加wrapper
- [ ] 测试PPO
- [ ] 完善reset，reset代表一个episode结束，需要清空一些参数



wrapper：
1. resetWrapper：在出现文件错误后，在计算完reward后，就要调用close和reset重新设置环境。注意，observation和action space都要重置。
2. actionWrapper: 记录一个episode内的action sequence
3. rewardWrapper：记录一个episode内的reward sequence