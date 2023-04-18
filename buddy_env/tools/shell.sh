#!/bin/zsh
# -convert-linalg-to-loops
#FLAG="-convert-linalg-to-loops -lower-affine -convert-scf-to-cf -convert-vector-to-llvm -convert-memref-to-llvm
#-convert-arith-to-llvm -convert-func-to-llvm -reconcile-unrealized-casts "
#FLAG="--use-nvgpu"
#echo $FLAG
#commond="../tools/mlir-opt ../res/linalg-conv2d.mlir $FLAG --print-op-stats 2>log1.mlir"
#sh $commond
#/usr/bin/time -h -o time_output.txt $commond
#
#./../tools/mlir-opt ../MLIRLinaly/linalg-conv2d.mlir $FLAG -o log1.mlir
#pid=$!
#echo pid
#
#echo finished!

./mlir-opt ../res/linalg-conv2d.mlir -convert-linalg-to-loops -lower-affine -convert-scf-to-cf -convert-vector-to-llvm -convert-memref-to-llvm -convert-arith-to-llvm -convert-func-to-llvm -reconcile-unrealized-casts --print-op-stats

./mlir-opt ../res/linalg-conv2d.mlir -convert-linalg-to-loops -lower-affine -convert-memref-to-llvm -convert-scf-to-cf -convert-func-to-llvm -reconcile-unrealized-casts -o tmp.mlir

#./mlir-translate ./tmp.mlir --mlir-to-llvmir -o tmp.ll