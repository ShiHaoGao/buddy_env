; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

declare ptr @malloc(i64)

declare void @free(ptr)

declare void @printMemrefF32(i64, ptr)

define { ptr, ptr, i64, [2 x i64], [2 x i64] } @alloc_2d_filled_f32(i64 %0, i64 %1, float %2) !dbg !3 {
  %4 = mul i64 %1, %0, !dbg !7
  %5 = getelementptr float, ptr null, i64 %4, !dbg !9
  %6 = ptrtoint ptr %5 to i64, !dbg !10
  %7 = call ptr @malloc(i64 %6), !dbg !11
  %8 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } undef, ptr %7, 0, !dbg !12
  %9 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %8, ptr %7, 1, !dbg !13
  %10 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %9, i64 0, 2, !dbg !14
  %11 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %10, i64 %0, 3, 0, !dbg !15
  %12 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %11, i64 %1, 3, 1, !dbg !16
  %13 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, i64 %1, 4, 0, !dbg !17
  %14 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %13, i64 1, 4, 1, !dbg !18
  br label %15, !dbg !19

15:                                               ; preds = %27, %3
  %16 = phi i64 [ %28, %27 ], [ 0, %3 ]
  %17 = icmp slt i64 %16, %0, !dbg !20
  br i1 %17, label %18, label %29, !dbg !21

18:                                               ; preds = %15
  br label %19, !dbg !22

19:                                               ; preds = %22, %18
  %20 = phi i64 [ %26, %22 ], [ 0, %18 ]
  %21 = icmp slt i64 %20, %1, !dbg !23
  br i1 %21, label %22, label %27, !dbg !24

22:                                               ; preds = %19
  %23 = mul i64 %16, %1, !dbg !25
  %24 = add i64 %23, %20, !dbg !26
  %25 = getelementptr float, ptr %7, i64 %24, !dbg !27
  store float %2, ptr %25, align 4, !dbg !28
  %26 = add i64 %20, 1, !dbg !29
  br label %19, !dbg !30

27:                                               ; preds = %19
  %28 = add i64 %16, 1, !dbg !31
  br label %15, !dbg !32

29:                                               ; preds = %15
  ret { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, !dbg !33
}

define void @conv_2d(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6, ptr %7, ptr %8, i64 %9, i64 %10, i64 %11, i64 %12, i64 %13, ptr %14, ptr %15, i64 %16, i64 %17, i64 %18, i64 %19, i64 %20) !dbg !34 {
  %22 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } undef, ptr %7, 0, !dbg !35
  %23 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, ptr %8, 1, !dbg !37
  %24 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %23, i64 %9, 2, !dbg !38
  %25 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, i64 %10, 3, 0, !dbg !39
  %26 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %25, i64 %12, 4, 0, !dbg !40
  %27 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %26, i64 %11, 3, 1, !dbg !41
  %28 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } undef, ptr %14, 0, !dbg !42
  %29 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %28, ptr %15, 1, !dbg !43
  %30 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, i64 %16, 2, !dbg !44
  %31 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %30, i64 %17, 3, 0, !dbg !45
  %32 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %31, i64 %19, 4, 0, !dbg !46
  %33 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, i64 %18, 3, 1, !dbg !47
  %34 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %27, 3, !dbg !48
  %35 = alloca [2 x i64], i64 1, align 8, !dbg !49
  store [2 x i64] %34, ptr %35, align 4, !dbg !50
  %36 = getelementptr [2 x i64], ptr %35, i32 0, i32 0, !dbg !51
  %37 = load i64, ptr %36, align 4, !dbg !52
  %38 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %27, 3, !dbg !53
  %39 = alloca [2 x i64], i64 1, align 8, !dbg !54
  store [2 x i64] %38, ptr %39, align 4, !dbg !55
  %40 = getelementptr [2 x i64], ptr %39, i32 0, i32 1, !dbg !56
  %41 = load i64, ptr %40, align 4, !dbg !57
  %42 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %33, 3, !dbg !58
  %43 = alloca [2 x i64], i64 1, align 8, !dbg !59
  store [2 x i64] %42, ptr %43, align 4, !dbg !60
  %44 = getelementptr [2 x i64], ptr %43, i32 0, i32 0, !dbg !61
  %45 = load i64, ptr %44, align 4, !dbg !62
  %46 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %33, 3, !dbg !63
  %47 = alloca [2 x i64], i64 1, align 8, !dbg !64
  store [2 x i64] %46, ptr %47, align 4, !dbg !65
  %48 = getelementptr [2 x i64], ptr %47, i32 0, i32 1, !dbg !66
  %49 = load i64, ptr %48, align 4, !dbg !67
  br label %50, !dbg !68

50:                                               ; preds = %90, %21
  %51 = phi i64 [ %91, %90 ], [ 0, %21 ]
  %52 = icmp slt i64 %51, %45, !dbg !69
  br i1 %52, label %53, label %92, !dbg !70

53:                                               ; preds = %50
  br label %54, !dbg !71

54:                                               ; preds = %88, %53
  %55 = phi i64 [ %89, %88 ], [ 0, %53 ]
  %56 = icmp slt i64 %55, %49, !dbg !72
  br i1 %56, label %57, label %90, !dbg !73

57:                                               ; preds = %54
  br label %58, !dbg !74

58:                                               ; preds = %86, %57
  %59 = phi i64 [ %87, %86 ], [ 0, %57 ]
  %60 = icmp slt i64 %59, %37, !dbg !75
  br i1 %60, label %61, label %88, !dbg !76

61:                                               ; preds = %58
  br label %62, !dbg !77

62:                                               ; preds = %65, %61
  %63 = phi i64 [ %85, %65 ], [ 0, %61 ]
  %64 = icmp slt i64 %63, %41, !dbg !78
  br i1 %64, label %65, label %86, !dbg !79

65:                                               ; preds = %62
  %66 = add i64 %51, %59, !dbg !80
  %67 = add i64 %55, %63, !dbg !81
  %68 = mul i64 %66, %5, !dbg !82
  %69 = add i64 %68, %67, !dbg !83
  %70 = getelementptr float, ptr %1, i64 %69, !dbg !84
  %71 = load float, ptr %70, align 4, !dbg !85
  %72 = mul i64 %59, %12, !dbg !86
  %73 = add i64 %72, %63, !dbg !87
  %74 = getelementptr float, ptr %8, i64 %73, !dbg !88
  %75 = load float, ptr %74, align 4, !dbg !89
  %76 = mul i64 %51, %19, !dbg !90
  %77 = add i64 %76, %55, !dbg !91
  %78 = getelementptr float, ptr %15, i64 %77, !dbg !92
  %79 = load float, ptr %78, align 4, !dbg !93
  %80 = fmul float %71, %75, !dbg !94
  %81 = fadd float %79, %80, !dbg !95
  %82 = mul i64 %51, %19, !dbg !96
  %83 = add i64 %82, %55, !dbg !97
  %84 = getelementptr float, ptr %15, i64 %83, !dbg !98
  store float %81, ptr %84, align 4, !dbg !99
  %85 = add i64 %63, 1, !dbg !100
  br label %62, !dbg !101

86:                                               ; preds = %62
  %87 = add i64 %59, 1, !dbg !102
  br label %58, !dbg !103

88:                                               ; preds = %58
  %89 = add i64 %55, 1, !dbg !104
  br label %54, !dbg !105

90:                                               ; preds = %54
  %91 = add i64 %51, 1, !dbg !106
  br label %50, !dbg !107

92:                                               ; preds = %50
  ret void, !dbg !108
}

define void @main() !dbg !109 {
  %1 = call { ptr, ptr, i64, [2 x i64], [2 x i64] } @alloc_2d_filled_f32(i64 3, i64 3, float 1.000000e+00), !dbg !110
  %2 = call { ptr, ptr, i64, [2 x i64], [2 x i64] } @alloc_2d_filled_f32(i64 10, i64 10, float 1.000000e+00), !dbg !112
  %3 = call { ptr, ptr, i64, [2 x i64], [2 x i64] } @alloc_2d_filled_f32(i64 8, i64 8, float 0.000000e+00), !dbg !113
  %4 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %2, 0, !dbg !114
  %5 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %2, 1, !dbg !115
  %6 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %2, 2, !dbg !116
  %7 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %2, 3, 0, !dbg !117
  %8 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %2, 3, 1, !dbg !118
  %9 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %2, 4, 0, !dbg !119
  %10 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %2, 4, 1, !dbg !120
  %11 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %1, 0, !dbg !121
  %12 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %1, 1, !dbg !122
  %13 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %1, 2, !dbg !123
  %14 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %1, 3, 0, !dbg !124
  %15 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %1, 3, 1, !dbg !125
  %16 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %1, 4, 0, !dbg !126
  %17 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %1, 4, 1, !dbg !127
  %18 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 0, !dbg !128
  %19 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 1, !dbg !129
  %20 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 2, !dbg !130
  %21 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 3, 0, !dbg !131
  %22 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 3, 1, !dbg !132
  %23 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 4, 0, !dbg !133
  %24 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 4, 1, !dbg !134
  call void @conv_2d(ptr %4, ptr %5, i64 %6, i64 %7, i64 %8, i64 %9, i64 %10, ptr %11, ptr %12, i64 %13, i64 %14, i64 %15, i64 %16, i64 %17, ptr %18, ptr %19, i64 %20, i64 %21, i64 %22, i64 %23, i64 %24), !dbg !135
  %25 = alloca { ptr, ptr, i64, [2 x i64], [2 x i64] }, i64 1, align 8, !dbg !136
  store { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, ptr %25, align 8, !dbg !137
  call void @printMemrefF32(i64 2, ptr %25), !dbg !138
  %26 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %2, 0, !dbg !139
  call void @free(ptr %26), !dbg !140
  %27 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %1, 0, !dbg !141
  call void @free(ptr %27), !dbg !142
  %28 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 0, !dbg !143
  call void @free(ptr %28), !dbg !144
  ret void, !dbg !145
}

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2}

!0 = distinct !DICompileUnit(language: DW_LANG_C, file: !1, producer: "mlir", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!1 = !DIFile(filename: "LLVMDialectModule", directory: "/")
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = distinct !DISubprogram(name: "alloc_2d_filled_f32", linkageName: "alloc_2d_filled_f32", scope: null, file: !4, line: 5, type: !5, scopeLine: 5, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !6)
!4 = !DIFile(filename: "./tmp.mlir", directory: "/Users/gaoshihao/Documents/buddy-auto-lowering-tool")
!5 = !DISubroutineType(types: !6)
!6 = !{}
!7 = !DILocation(line: 8, column: 10, scope: !8)
!8 = !DILexicalBlockFile(scope: !3, file: !4, discriminator: 0)
!9 = !DILocation(line: 10, column: 10, scope: !8)
!10 = !DILocation(line: 11, column: 10, scope: !8)
!11 = !DILocation(line: 12, column: 10, scope: !8)
!12 = !DILocation(line: 15, column: 10, scope: !8)
!13 = !DILocation(line: 16, column: 11, scope: !8)
!14 = !DILocation(line: 17, column: 11, scope: !8)
!15 = !DILocation(line: 18, column: 11, scope: !8)
!16 = !DILocation(line: 19, column: 11, scope: !8)
!17 = !DILocation(line: 20, column: 11, scope: !8)
!18 = !DILocation(line: 21, column: 11, scope: !8)
!19 = !DILocation(line: 22, column: 5, scope: !8)
!20 = !DILocation(line: 24, column: 11, scope: !8)
!21 = !DILocation(line: 25, column: 5, scope: !8)
!22 = !DILocation(line: 27, column: 5, scope: !8)
!23 = !DILocation(line: 29, column: 11, scope: !8)
!24 = !DILocation(line: 30, column: 5, scope: !8)
!25 = !DILocation(line: 32, column: 11, scope: !8)
!26 = !DILocation(line: 33, column: 11, scope: !8)
!27 = !DILocation(line: 34, column: 11, scope: !8)
!28 = !DILocation(line: 35, column: 5, scope: !8)
!29 = !DILocation(line: 36, column: 11, scope: !8)
!30 = !DILocation(line: 37, column: 5, scope: !8)
!31 = !DILocation(line: 39, column: 11, scope: !8)
!32 = !DILocation(line: 40, column: 5, scope: !8)
!33 = !DILocation(line: 42, column: 5, scope: !8)
!34 = distinct !DISubprogram(name: "conv_2d", linkageName: "conv_2d", scope: null, file: !4, line: 44, type: !5, scopeLine: 44, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !6)
!35 = !DILocation(line: 48, column: 10, scope: !36)
!36 = !DILexicalBlockFile(scope: !34, file: !4, discriminator: 0)
!37 = !DILocation(line: 49, column: 10, scope: !36)
!38 = !DILocation(line: 50, column: 10, scope: !36)
!39 = !DILocation(line: 51, column: 10, scope: !36)
!40 = !DILocation(line: 52, column: 10, scope: !36)
!41 = !DILocation(line: 53, column: 10, scope: !36)
!42 = !DILocation(line: 55, column: 11, scope: !36)
!43 = !DILocation(line: 56, column: 11, scope: !36)
!44 = !DILocation(line: 57, column: 11, scope: !36)
!45 = !DILocation(line: 58, column: 11, scope: !36)
!46 = !DILocation(line: 59, column: 11, scope: !36)
!47 = !DILocation(line: 60, column: 11, scope: !36)
!48 = !DILocation(line: 61, column: 11, scope: !36)
!49 = !DILocation(line: 62, column: 11, scope: !36)
!50 = !DILocation(line: 63, column: 5, scope: !36)
!51 = !DILocation(line: 64, column: 11, scope: !36)
!52 = !DILocation(line: 65, column: 11, scope: !36)
!53 = !DILocation(line: 66, column: 11, scope: !36)
!54 = !DILocation(line: 67, column: 11, scope: !36)
!55 = !DILocation(line: 68, column: 5, scope: !36)
!56 = !DILocation(line: 69, column: 11, scope: !36)
!57 = !DILocation(line: 70, column: 11, scope: !36)
!58 = !DILocation(line: 71, column: 11, scope: !36)
!59 = !DILocation(line: 72, column: 11, scope: !36)
!60 = !DILocation(line: 73, column: 5, scope: !36)
!61 = !DILocation(line: 74, column: 11, scope: !36)
!62 = !DILocation(line: 75, column: 11, scope: !36)
!63 = !DILocation(line: 76, column: 11, scope: !36)
!64 = !DILocation(line: 77, column: 11, scope: !36)
!65 = !DILocation(line: 78, column: 5, scope: !36)
!66 = !DILocation(line: 79, column: 11, scope: !36)
!67 = !DILocation(line: 80, column: 11, scope: !36)
!68 = !DILocation(line: 81, column: 5, scope: !36)
!69 = !DILocation(line: 83, column: 11, scope: !36)
!70 = !DILocation(line: 84, column: 5, scope: !36)
!71 = !DILocation(line: 86, column: 5, scope: !36)
!72 = !DILocation(line: 88, column: 11, scope: !36)
!73 = !DILocation(line: 89, column: 5, scope: !36)
!74 = !DILocation(line: 91, column: 5, scope: !36)
!75 = !DILocation(line: 93, column: 11, scope: !36)
!76 = !DILocation(line: 94, column: 5, scope: !36)
!77 = !DILocation(line: 96, column: 5, scope: !36)
!78 = !DILocation(line: 98, column: 11, scope: !36)
!79 = !DILocation(line: 99, column: 5, scope: !36)
!80 = !DILocation(line: 101, column: 11, scope: !36)
!81 = !DILocation(line: 102, column: 11, scope: !36)
!82 = !DILocation(line: 103, column: 11, scope: !36)
!83 = !DILocation(line: 104, column: 11, scope: !36)
!84 = !DILocation(line: 105, column: 11, scope: !36)
!85 = !DILocation(line: 106, column: 11, scope: !36)
!86 = !DILocation(line: 107, column: 11, scope: !36)
!87 = !DILocation(line: 108, column: 11, scope: !36)
!88 = !DILocation(line: 109, column: 11, scope: !36)
!89 = !DILocation(line: 110, column: 11, scope: !36)
!90 = !DILocation(line: 111, column: 11, scope: !36)
!91 = !DILocation(line: 112, column: 11, scope: !36)
!92 = !DILocation(line: 113, column: 11, scope: !36)
!93 = !DILocation(line: 114, column: 11, scope: !36)
!94 = !DILocation(line: 115, column: 11, scope: !36)
!95 = !DILocation(line: 116, column: 11, scope: !36)
!96 = !DILocation(line: 117, column: 11, scope: !36)
!97 = !DILocation(line: 118, column: 11, scope: !36)
!98 = !DILocation(line: 119, column: 11, scope: !36)
!99 = !DILocation(line: 120, column: 5, scope: !36)
!100 = !DILocation(line: 121, column: 11, scope: !36)
!101 = !DILocation(line: 122, column: 5, scope: !36)
!102 = !DILocation(line: 124, column: 11, scope: !36)
!103 = !DILocation(line: 125, column: 5, scope: !36)
!104 = !DILocation(line: 127, column: 11, scope: !36)
!105 = !DILocation(line: 128, column: 5, scope: !36)
!106 = !DILocation(line: 130, column: 11, scope: !36)
!107 = !DILocation(line: 131, column: 5, scope: !36)
!108 = !DILocation(line: 133, column: 5, scope: !36)
!109 = distinct !DISubprogram(name: "main", linkageName: "main", scope: null, file: !4, line: 135, type: !5, scopeLine: 135, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !6)
!110 = !DILocation(line: 143, column: 10, scope: !111)
!111 = !DILexicalBlockFile(scope: !109, file: !4, discriminator: 0)
!112 = !DILocation(line: 144, column: 10, scope: !111)
!113 = !DILocation(line: 145, column: 10, scope: !111)
!114 = !DILocation(line: 146, column: 11, scope: !111)
!115 = !DILocation(line: 147, column: 11, scope: !111)
!116 = !DILocation(line: 148, column: 11, scope: !111)
!117 = !DILocation(line: 149, column: 11, scope: !111)
!118 = !DILocation(line: 150, column: 11, scope: !111)
!119 = !DILocation(line: 151, column: 11, scope: !111)
!120 = !DILocation(line: 152, column: 11, scope: !111)
!121 = !DILocation(line: 153, column: 11, scope: !111)
!122 = !DILocation(line: 154, column: 11, scope: !111)
!123 = !DILocation(line: 155, column: 11, scope: !111)
!124 = !DILocation(line: 156, column: 11, scope: !111)
!125 = !DILocation(line: 157, column: 11, scope: !111)
!126 = !DILocation(line: 158, column: 11, scope: !111)
!127 = !DILocation(line: 159, column: 11, scope: !111)
!128 = !DILocation(line: 160, column: 11, scope: !111)
!129 = !DILocation(line: 161, column: 11, scope: !111)
!130 = !DILocation(line: 162, column: 11, scope: !111)
!131 = !DILocation(line: 163, column: 11, scope: !111)
!132 = !DILocation(line: 164, column: 11, scope: !111)
!133 = !DILocation(line: 165, column: 11, scope: !111)
!134 = !DILocation(line: 166, column: 11, scope: !111)
!135 = !DILocation(line: 167, column: 5, scope: !111)
!136 = !DILocation(line: 168, column: 11, scope: !111)
!137 = !DILocation(line: 169, column: 5, scope: !111)
!138 = !DILocation(line: 171, column: 5, scope: !111)
!139 = !DILocation(line: 172, column: 11, scope: !111)
!140 = !DILocation(line: 174, column: 5, scope: !111)
!141 = !DILocation(line: 175, column: 11, scope: !111)
!142 = !DILocation(line: 177, column: 5, scope: !111)
!143 = !DILocation(line: 178, column: 11, scope: !111)
!144 = !DILocation(line: 180, column: 5, scope: !111)
!145 = !DILocation(line: 181, column: 5, scope: !111)
