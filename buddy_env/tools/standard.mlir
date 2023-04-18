module attributes {llvm.data_layout = ""} {
  llvm.func @free(!llvm.ptr<i8>)
  llvm.func @malloc(i64) -> !llvm.ptr<i8>
  llvm.func @printMemrefF32(i64, !llvm.ptr<i8>) attributes {sym_visibility = "private"}
  llvm.func @alloc_2d_filled_f32(%arg0: i64, %arg1: i64, %arg2: f32) -> !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> {
    %0 = llvm.mlir.constant(0 : index) : i64
    %1 = llvm.mlir.constant(1 : index) : i64
    %2 = llvm.mlir.constant(1 : index) : i64
    %3 = llvm.mul %arg1, %arg0  : i64
    %4 = llvm.mlir.null : !llvm.ptr<f32>
    %5 = llvm.getelementptr %4[%3] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %6 = llvm.ptrtoint %5 : !llvm.ptr<f32> to i64
    %7 = llvm.call @malloc(%6) : (i64) -> !llvm.ptr<i8>
    %8 = llvm.bitcast %7 : !llvm.ptr<i8> to !llvm.ptr<f32>
    %9 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %10 = llvm.insertvalue %8, %9[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %11 = llvm.insertvalue %8, %10[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %12 = llvm.mlir.constant(0 : index) : i64
    %13 = llvm.insertvalue %12, %11[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %14 = llvm.insertvalue %arg0, %13[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %15 = llvm.insertvalue %arg1, %14[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %16 = llvm.insertvalue %arg1, %15[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %17 = llvm.insertvalue %2, %16[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.br ^bb1(%0 : i64)
  ^bb1(%18: i64):  // 2 preds: ^bb0, ^bb5
    %19 = llvm.icmp "slt" %18, %arg0 : i64
    llvm.cond_br %19, ^bb2, ^bb6
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%0 : i64)
  ^bb3(%20: i64):  // 2 preds: ^bb2, ^bb4
    %21 = llvm.icmp "slt" %20, %arg1 : i64
    llvm.cond_br %21, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %22 = llvm.mul %18, %arg1  : i64
    %23 = llvm.add %22, %20  : i64
    %24 = llvm.getelementptr %8[%23] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    llvm.store %arg2, %24 : !llvm.ptr<f32>
    %25 = llvm.add %20, %1  : i64
    llvm.br ^bb3(%25 : i64)
  ^bb5:  // pred: ^bb3
    %26 = llvm.add %18, %1  : i64
    llvm.br ^bb1(%26 : i64)
  ^bb6:  // pred: ^bb1
    llvm.return %17 : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
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
    %8 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %9 = llvm.insertvalue %arg7, %8[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %10 = llvm.insertvalue %arg8, %9[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %11 = llvm.insertvalue %arg9, %10[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %12 = llvm.insertvalue %arg10, %11[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %13 = llvm.insertvalue %arg12, %12[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %14 = llvm.insertvalue %arg11, %13[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %15 = llvm.insertvalue %arg13, %14[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %16 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %17 = llvm.insertvalue %arg14, %16[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %18 = llvm.insertvalue %arg15, %17[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %19 = llvm.insertvalue %arg16, %18[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %20 = llvm.insertvalue %arg17, %19[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %21 = llvm.insertvalue %arg19, %20[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %22 = llvm.insertvalue %arg18, %21[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.insertvalue %arg20, %22[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %24 = llvm.mlir.constant(0 : index) : i64
    %25 = llvm.mlir.constant(1 : index) : i64
    %26 = llvm.extractvalue %15[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %27 = llvm.extractvalue %15[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %28 = llvm.extractvalue %23[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %29 = llvm.extractvalue %23[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.br ^bb1(%24 : i64)
  ^bb1(%30: i64):  // 2 preds: ^bb0, ^bb11
    %31 = llvm.icmp "slt" %30, %28 : i64
    llvm.cond_br %31, ^bb2, ^bb12
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%24 : i64)
  ^bb3(%32: i64):  // 2 preds: ^bb2, ^bb10
    %33 = llvm.icmp "slt" %32, %29 : i64
    llvm.cond_br %33, ^bb4, ^bb11
  ^bb4:  // pred: ^bb3
    llvm.br ^bb5(%24 : i64)
  ^bb5(%34: i64):  // 2 preds: ^bb4, ^bb9
    %35 = llvm.icmp "slt" %34, %26 : i64
    llvm.cond_br %35, ^bb6, ^bb10
  ^bb6:  // pred: ^bb5
    llvm.br ^bb7(%24 : i64)
  ^bb7(%36: i64):  // 2 preds: ^bb6, ^bb8
    %37 = llvm.icmp "slt" %36, %27 : i64
    llvm.cond_br %37, ^bb8, ^bb9
  ^bb8:  // pred: ^bb7
    %38 = llvm.add %30, %34  : i64
    %39 = llvm.add %32, %36  : i64
    %40 = llvm.extractvalue %7[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %41 = llvm.extractvalue %7[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %42 = llvm.mul %38, %41  : i64
    %43 = llvm.add %42, %39  : i64
    %44 = llvm.getelementptr %40[%43] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %45 = llvm.load %44 : !llvm.ptr<f32>
    %46 = llvm.extractvalue %15[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %47 = llvm.extractvalue %15[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %48 = llvm.mul %34, %47  : i64
    %49 = llvm.add %48, %36  : i64
    %50 = llvm.getelementptr %46[%49] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %51 = llvm.load %50 : !llvm.ptr<f32>
    %52 = llvm.extractvalue %23[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %53 = llvm.extractvalue %23[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %54 = llvm.mul %30, %53  : i64
    %55 = llvm.add %54, %32  : i64
    %56 = llvm.getelementptr %52[%55] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %57 = llvm.load %56 : !llvm.ptr<f32>
    %58 = llvm.fmul %45, %51  : f32
    %59 = llvm.fadd %57, %58  : f32
    %60 = llvm.extractvalue %23[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %61 = llvm.extractvalue %23[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %62 = llvm.mul %30, %61  : i64
    %63 = llvm.add %62, %32  : i64
    %64 = llvm.getelementptr %60[%63] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    llvm.store %59, %64 : !llvm.ptr<f32>
    %65 = llvm.add %36, %25  : i64
    llvm.br ^bb7(%65 : i64)
  ^bb9:  // pred: ^bb7
    %66 = llvm.add %34, %25  : i64
    llvm.br ^bb5(%66 : i64)
  ^bb10:  // pred: ^bb5
    %67 = llvm.add %32, %25  : i64
    llvm.br ^bb3(%67 : i64)
  ^bb11:  // pred: ^bb3
    %68 = llvm.add %30, %25  : i64
    llvm.br ^bb1(%68 : i64)
  ^bb12:  // pred: ^bb1
    llvm.return
  }
  llvm.func @main() {
    %0 = llvm.mlir.constant(10 : index) : i64
    %1 = llvm.mlir.constant(3 : index) : i64
    %2 = llvm.mlir.constant(1.000000e+00 : f32) : f32
    %3 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    %4 = llvm.mlir.constant(8 : index) : i64
    %5 = llvm.call @alloc_2d_filled_f32(%1, %1, %2) : (i64, i64, f32) -> !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %6 = llvm.call @alloc_2d_filled_f32(%0, %0, %2) : (i64, i64, f32) -> !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %7 = llvm.call @alloc_2d_filled_f32(%4, %4, %3) : (i64, i64, f32) -> !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %8 = llvm.extractvalue %6[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %9 = llvm.extractvalue %6[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %10 = llvm.extractvalue %6[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %11 = llvm.extractvalue %6[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %12 = llvm.extractvalue %6[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %13 = llvm.extractvalue %6[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %14 = llvm.extractvalue %6[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %15 = llvm.extractvalue %5[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %16 = llvm.extractvalue %5[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %17 = llvm.extractvalue %5[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %18 = llvm.extractvalue %5[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %19 = llvm.extractvalue %5[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %20 = llvm.extractvalue %5[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %21 = llvm.extractvalue %5[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %22 = llvm.extractvalue %7[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.extractvalue %7[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %24 = llvm.extractvalue %7[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %25 = llvm.extractvalue %7[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %26 = llvm.extractvalue %7[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %27 = llvm.extractvalue %7[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %28 = llvm.extractvalue %7[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @conv_2d(%8, %9, %10, %11, %12, %13, %14, %15, %16, %17, %18, %19, %20, %21, %22, %23, %24, %25, %26, %27, %28) : (!llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64, !llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64, !llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64) -> ()
    %29 = llvm.mlir.constant(1 : index) : i64
    %30 = llvm.alloca %29 x !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> : (i64) -> !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    llvm.store %7, %30 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    %31 = llvm.bitcast %30 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>> to !llvm.ptr<i8>
    %32 = llvm.mlir.constant(2 : index) : i64
    %33 = llvm.mlir.undef : !llvm.struct<(i64, ptr<i8>)>
    %34 = llvm.insertvalue %32, %33[0] : !llvm.struct<(i64, ptr<i8>)> 
    %35 = llvm.insertvalue %31, %34[1] : !llvm.struct<(i64, ptr<i8>)> 
    llvm.call @printMemrefF32(%32, %31) : (i64, !llvm.ptr<i8>) -> ()
    %36 = llvm.extractvalue %6[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %37 = llvm.bitcast %36 : !llvm.ptr<f32> to !llvm.ptr<i8>
    llvm.call @free(%37) : (!llvm.ptr<i8>) -> ()
    %38 = llvm.extractvalue %5[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %39 = llvm.bitcast %38 : !llvm.ptr<f32> to !llvm.ptr<i8>
    llvm.call @free(%39) : (!llvm.ptr<i8>) -> ()
    %40 = llvm.extractvalue %7[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %41 = llvm.bitcast %40 : !llvm.ptr<f32> to !llvm.ptr<i8>
    llvm.call @free(%41) : (!llvm.ptr<i8>) -> ()
    llvm.return
  }
}

