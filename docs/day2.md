## day 2

### 上午：

震惊发现：
发现一种组合[0, 1, 4, 2, 6, 7]也可以将linalg-conv2d.mlir lowering 到mlir上，并且可以translate到ll中， 生成的mlir文件是一样的。

标准：
./mlir-opt ../res/linalg-conv2d.mlir -convert-linalg-to-loops -lower-affine -convert-scf-to-cf -convert-vector-to-llvm -convert-memref-to-llvm -convert-arith-to-llvm -convert-func-to-llvm -reconcile-unrealized-casts --print-op-stats

新找到的：
./mlir-opt ../res/linalg-conv2d.mlir -convert-linalg-to-loops -lower-affine -convert-memref-to-llvm -convert-scf-to-cf -convert-func-to-llvm -reconcile-unrealized-casts -o tmp.mlir

第二种组合：[7, 0, 5, 2, 1, 4, 6, 3] reward = 87



### 下午 

master分支已经可以测试运行，而且reward确实在升高

新建分支 change_info: 
    主要修改内容为，提取feature的时候，不需要记录op的名字，只需要记录dialect对应的op的数量。
    所以，相应的修改了info的'features'属性的内容，这样在_get_obs_and_info的时候，也可以少做一些运算。

下一步任务：
修改observation：
    增加过去的所有选择过的pass index为observation。

修改reward:
    让pass可以重复，但是要给punish。
    
改完后测试。

看看imitation learning