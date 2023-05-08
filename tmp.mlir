#map = affine_map<(d0, d1) -> (d0 + d1 - 1)>
module {
  func.func private @printMemrefF32(memref<*xf32>)
  func.func @alloc_2d_filled_f32(%arg0: index, %arg1: index, %arg2: f32) -> memref<?x?xf32> {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %0 = memref.alloc(%arg0, %arg1) : memref<?x?xf32>
    scf.for %arg3 = %c0 to %arg0 step %c1 {
      scf.for %arg4 = %c0 to %arg1 step %c1 {
        memref.store %arg2, %0[%arg3, %arg4] : memref<?x?xf32>
      }
    }
    return %0 : memref<?x?xf32>
  }
  func.func @conv_2d(%arg0: memref<?x?xf32>, %arg1: memref<?x?xf32>, %arg2: memref<?x?xf32>) {
    linalg.conv_2d ins(%arg0, %arg1 : memref<?x?xf32>, memref<?x?xf32>) outs(%arg2 : memref<?x?xf32>)
    return
  }
  func.func @main() {
    %c2 = arith.constant 2 : index
    %c3 = arith.constant 3 : index
    %cst = arith.constant 1.000000e+00 : f32
    %cst_0 = arith.constant 0.000000e+00 : f32
    %c3_1 = arith.constant 3 : index
    %c8 = arith.constant 8 : index
    %0 = affine.apply #map(%c8, %c3_1)
    %1 = call @alloc_2d_filled_f32(%c3_1, %c3_1, %cst) : (index, index, f32) -> memref<?x?xf32>
    %2 = call @alloc_2d_filled_f32(%0, %0, %cst) : (index, index, f32) -> memref<?x?xf32>
    %3 = call @alloc_2d_filled_f32(%c8, %c8, %cst_0) : (index, index, f32) -> memref<?x?xf32>
    call @conv_2d(%2, %1, %3) : (memref<?x?xf32>, memref<?x?xf32>, memref<?x?xf32>) -> ()
    %4 = memref.cast %3 : memref<?x?xf32> to memref<*xf32>
    call @printMemrefF32(%4) : (memref<*xf32>) -> ()
    memref.dealloc %2 : memref<?x?xf32>
    memref.dealloc %1 : memref<?x?xf32>
    memref.dealloc %3 : memref<?x?xf32>
    return
  }
}

