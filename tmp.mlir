#map = affine_map<(d0, d1) -> (d0 + d1)>
module {
  func.func private @printMemrefF32(memref<*xf32>)
  func.func @alloc_2d_filled_f32(%arg0: index, %arg1: index, %arg2: f32) -> memref<?x?xf32> {
    %0 = llvm.mlir.constant(0 : index) : i64
    %1 = builtin.unrealized_conversion_cast %0 : i64 to index
    %2 = llvm.mlir.constant(1 : index) : i64
    %3 = builtin.unrealized_conversion_cast %2 : i64 to index
    %4 = memref.alloc(%arg0, %arg1) : memref<?x?xf32>
    scf.for %arg3 = %1 to %arg0 step %3 {
      scf.for %arg4 = %1 to %arg1 step %3 {
        memref.store %arg2, %4[%arg3, %arg4] : memref<?x?xf32>
      }
    }
    return %4 : memref<?x?xf32>
  }
  func.func @conv_2d(%arg0: memref<?x?xf32>, %arg1: memref<?x?xf32>, %arg2: memref<?x?xf32>) {
    %0 = llvm.mlir.constant(0 : index) : i64
    %1 = builtin.unrealized_conversion_cast %0 : i64 to index
    %2 = llvm.mlir.constant(1 : index) : i64
    %3 = builtin.unrealized_conversion_cast %2 : i64 to index
    %4 = memref.dim %arg1, %1 : memref<?x?xf32>
    %5 = memref.dim %arg1, %3 : memref<?x?xf32>
    %6 = memref.dim %arg2, %1 : memref<?x?xf32>
    %7 = memref.dim %arg2, %3 : memref<?x?xf32>
    scf.for %arg3 = %1 to %6 step %3 {
      scf.for %arg4 = %1 to %7 step %3 {
        scf.for %arg5 = %1 to %4 step %3 {
          scf.for %arg6 = %1 to %5 step %3 {
            %8 = affine.apply #map(%arg3, %arg5)
            %9 = affine.apply #map(%arg4, %arg6)
            %10 = memref.load %arg0[%8, %9] : memref<?x?xf32>
            %11 = memref.load %arg1[%arg5, %arg6] : memref<?x?xf32>
            %12 = memref.load %arg2[%arg3, %arg4] : memref<?x?xf32>
            %13 = llvm.fmul %10, %11  : f32
            %14 = llvm.fadd %12, %13  : f32
            memref.store %14, %arg2[%arg3, %arg4] : memref<?x?xf32>
          }
        }
      }
    }
    return
  }
  func.func @main() {
    %0 = llvm.mlir.constant(10 : index) : i64
    %1 = builtin.unrealized_conversion_cast %0 : i64 to index
    %2 = llvm.mlir.constant(3 : index) : i64
    %3 = builtin.unrealized_conversion_cast %2 : i64 to index
    %4 = llvm.mlir.constant(1.000000e+00 : f32) : f32
    %5 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    %6 = llvm.mlir.constant(8 : index) : i64
    %7 = builtin.unrealized_conversion_cast %6 : i64 to index
    %8 = call @alloc_2d_filled_f32(%3, %3, %4) : (index, index, f32) -> memref<?x?xf32>
    %9 = call @alloc_2d_filled_f32(%1, %1, %4) : (index, index, f32) -> memref<?x?xf32>
    %10 = call @alloc_2d_filled_f32(%7, %7, %5) : (index, index, f32) -> memref<?x?xf32>
    call @conv_2d(%9, %8, %10) : (memref<?x?xf32>, memref<?x?xf32>, memref<?x?xf32>) -> ()
    %11 = memref.cast %10 : memref<?x?xf32> to memref<*xf32>
    call @printMemrefF32(%11) : (memref<*xf32>) -> ()
    memref.dealloc %9 : memref<?x?xf32>
    memref.dealloc %8 : memref<?x?xf32>
    memref.dealloc %10 : memref<?x?xf32>
    return
  }
}

