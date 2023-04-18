## day 2

### 上午：

震惊发现：
发现一种组合[0, 1, 4, 2, 6, 7]也可以将linalg-conv2d.mlir lowering 到mlir上，并且可以translate到ll中， 生成的mlir文件是一样的。

标准：
./mlir-opt ../res/linalg-conv2d.mlir -convert-linalg-to-loops -lower-affine -convert-scf-to-cf -convert-vector-to-llvm -convert-memref-to-llvm -convert-arith-to-llvm -convert-func-to-llvm -reconcile-unrealized-casts --print-op-stats

新找到的：
./mlir-opt ../res/linalg-conv2d.mlir -convert-linalg-to-loops -lower-affine -convert-memref-to-llvm -convert-scf-to-cf -convert-func-to-llvm -reconcile-unrealized-casts -o tmp.mlir

第二种组合：[7, 0, 5, 2, 1, 4, 6, 3] reward = 87