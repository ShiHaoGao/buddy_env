#map = affine_map<(d0, d1) -> (d0 + d1)>
module attributes {llvm.data_layout = ""} {
  llvm.func @printMemrefF32(i64, !llvm.ptr<i8>) attributes {sym_visibility = "private"}
  llvm.func @alloc_2d_filled_f32(%arg0: i64, %arg1: i64, %arg2: f32) -> !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> {
    %0 = builtin.unrealized_conversion_cast %arg1 : i64 to index
    %1 = builtin.unrealized_conversion_cast %arg0 : i64 to index
    %2 = llvm.mlir.constant(0 : index) : i64
    %3 = builtin.unrealized_conversion_cast %2 : i64 to index
    %4 = llvm.mlir.constant(1 : index) : i64
    %5 = builtin.unrealized_conversion_cast %4 : i64 to index
    %6 = memref.alloc(%1, %0) : memref<?x?xf32>
    %7 = builtin.unrealized_conversion_cast %6 : memref<?x?xf32> to !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    scf.for %arg3 = %3 to %1 step %5 {
      scf.for %arg4 = %3 to %0 step %5 {
        memref.store %arg2, %6[%arg3, %arg4] : memref<?x?xf32>
      }
    }
    llvm.return %7 : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
  }
  llvm.func @conv_2d(%arg0: !llvm.ptr<f32>, %arg1: !llvm.ptr<f32>, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: !llvm.ptr<f32>, %arg8: !llvm.ptr<f32>, %arg9: i64, %arg10: i64, %arg11: i64, %arg12: i64, %arg13: i64, %arg14: !llvm.ptr<f32>, %arg15: !llvm.ptr<f32>, %arg16: i64, %arg17: i64, %arg18: i64, %arg19: i64, %arg20: i64) {
    %0 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %5 = llvm.insertvalue %arg5, %4[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %6 = llvm.insertvalue %arg4, %5[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %7 = llvm.insertvalue %arg6, %6[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %8 = builtin.unrealized_conversion_cast %7 : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> to memref<?x?xf32>
    %9 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %10 = llvm.insertvalue %arg7, %9[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %11 = llvm.insertvalue %arg8, %10[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %12 = llvm.insertvalue %arg9, %11[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %13 = llvm.insertvalue %arg10, %12[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %14 = llvm.insertvalue %arg12, %13[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %15 = llvm.insertvalue %arg11, %14[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %16 = llvm.insertvalue %arg13, %15[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %17 = builtin.unrealized_conversion_cast %16 : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> to memref<?x?xf32>
    %18 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %19 = llvm.insertvalue %arg14, %18[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %20 = llvm.insertvalue %arg15, %19[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %21 = llvm.insertvalue %arg16, %20[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %22 = llvm.insertvalue %arg17, %21[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.insertvalue %arg19, %22[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %24 = llvm.insertvalue %arg18, %23[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %25 = llvm.insertvalue %arg20, %24[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %26 = builtin.unrealized_conversion_cast %25 : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> to memref<?x?xf32>
    %27 = llvm.mlir.constant(0 : index) : i64
    %28 = builtin.unrealized_conversion_cast %27 : i64 to index
    %29 = llvm.mlir.constant(1 : index) : i64
    %30 = builtin.unrealized_conversion_cast %29 : i64 to index
    %31 = memref.dim %17, %28 : memref<?x?xf32>
    %32 = memref.dim %17, %30 : memref<?x?xf32>
    %33 = memref.dim %26, %28 : memref<?x?xf32>
    %34 = memref.dim %26, %30 : memref<?x?xf32>
    scf.for %arg21 = %28 to %33 step %30 {
      scf.for %arg22 = %28 to %34 step %30 {
        scf.for %arg23 = %28 to %31 step %30 {
          scf.for %arg24 = %28 to %32 step %30 {
            %35 = affine.apply #map(%arg21, %arg23)
            %36 = affine.apply #map(%arg22, %arg24)
            %37 = memref.load %8[%35, %36] : memref<?x?xf32>
            %38 = memref.load %17[%arg23, %arg24] : memref<?x?xf32>
            %39 = memref.load %26[%arg21, %arg22] : memref<?x?xf32>
            %40 = llvm.fmul %37, %38  : f32
            %41 = llvm.fadd %39, %40  : f32
            memref.store %41, %26[%arg21, %arg22] : memref<?x?xf32>
          }
        }
      }
    }
    llvm.return
  }
  llvm.func @main() {
    %0 = llvm.mlir.constant(10 : index) : i64
    %1 = llvm.mlir.constant(3 : index) : i64
    %2 = llvm.mlir.constant(1.000000e+00 : f32) : f32
    %3 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    %4 = llvm.mlir.constant(8 : index) : i64
    %5 = llvm.call @alloc_2d_filled_f32(%1, %1, %2) : (i64, i64, f32) -> !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %6 = builtin.unrealized_conversion_cast %5 : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> to memref<?x?xf32>
    %7 = llvm.call @alloc_2d_filled_f32(%0, %0, %2) : (i64, i64, f32) -> !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %8 = builtin.unrealized_conversion_cast %7 : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> to memref<?x?xf32>
    %9 = llvm.call @alloc_2d_filled_f32(%4, %4, %3) : (i64, i64, f32) -> !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %10 = builtin.unrealized_conversion_cast %9 : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> to memref<?x?xf32>
    %11 = llvm.extractvalue %7[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %12 = llvm.extractvalue %7[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %13 = llvm.extractvalue %7[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %14 = llvm.extractvalue %7[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %15 = llvm.extractvalue %7[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %16 = llvm.extractvalue %7[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %17 = llvm.extractvalue %7[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %18 = llvm.extractvalue %5[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %19 = llvm.extractvalue %5[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %20 = llvm.extractvalue %5[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %21 = llvm.extractvalue %5[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %22 = llvm.extractvalue %5[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.extractvalue %5[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %24 = llvm.extractvalue %5[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %25 = llvm.extractvalue %9[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %26 = llvm.extractvalue %9[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %27 = llvm.extractvalue %9[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %28 = llvm.extractvalue %9[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %29 = llvm.extractvalue %9[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %30 = llvm.extractvalue %9[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %31 = llvm.extractvalue %9[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @conv_2d(%11, %12, %13, %14, %15, %16, %17, %18, %19, %20, %21, %22, %23, %24, %25, %26, %27, %28, %29, %30, %31) : (!llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64, !llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64, !llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64) -> ()
    %32 = memref.cast %10 : memref<?x?xf32> to memref<*xf32>
    %33 = builtin.unrealized_conversion_cast %32 : memref<*xf32> to !llvm.struct<(i64, ptr<i8>)>
    %34 = llvm.extractvalue %33[0] : !llvm.struct<(i64, ptr<i8>)> 
    %35 = llvm.extractvalue %33[1] : !llvm.struct<(i64, ptr<i8>)> 
    llvm.call @printMemrefF32(%34, %35) : (i64, !llvm.ptr<i8>) -> ()
    memref.dealloc %8 : memref<?x?xf32>
    memref.dealloc %6 : memref<?x?xf32>
    memref.dealloc %10 : memref<?x?xf32>
    llvm.return
  }
}

