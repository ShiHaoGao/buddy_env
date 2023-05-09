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
  br label %22, !dbg !35

22:                                               ; preds = %62, %21
  %23 = phi i64 [ %63, %62 ], [ 0, %21 ]
  %24 = icmp slt i64 %23, %17, !dbg !37
  br i1 %24, label %25, label %64, !dbg !38

25:                                               ; preds = %22
  br label %26, !dbg !39

26:                                               ; preds = %60, %25
  %27 = phi i64 [ %61, %60 ], [ 0, %25 ]
  %28 = icmp slt i64 %27, %18, !dbg !40
  br i1 %28, label %29, label %62, !dbg !41

29:                                               ; preds = %26
  br label %30, !dbg !42

30:                                               ; preds = %58, %29
  %31 = phi i64 [ %59, %58 ], [ 0, %29 ]
  %32 = icmp slt i64 %31, %10, !dbg !43
  br i1 %32, label %33, label %60, !dbg !44

33:                                               ; preds = %30
  br label %34, !dbg !45

34:                                               ; preds = %37, %33
  %35 = phi i64 [ %57, %37 ], [ 0, %33 ]
  %36 = icmp slt i64 %35, %11, !dbg !46
  br i1 %36, label %37, label %58, !dbg !47

37:                                               ; preds = %34
  %38 = add i64 %23, %31, !dbg !48
  %39 = add i64 %27, %35, !dbg !49
  %40 = mul i64 %38, %5, !dbg !50
  %41 = add i64 %40, %39, !dbg !51
  %42 = getelementptr float, ptr %1, i64 %41, !dbg !52
  %43 = load float, ptr %42, align 4, !dbg !53
  %44 = mul i64 %31, %12, !dbg !54
  %45 = add i64 %44, %35, !dbg !55
  %46 = getelementptr float, ptr %8, i64 %45, !dbg !56
  %47 = load float, ptr %46, align 4, !dbg !57
  %48 = mul i64 %23, %19, !dbg !58
  %49 = add i64 %48, %27, !dbg !59
  %50 = getelementptr float, ptr %15, i64 %49, !dbg !60
  %51 = load float, ptr %50, align 4, !dbg !61
  %52 = fmul float %43, %47, !dbg !62
  %53 = fadd float %51, %52, !dbg !63
  %54 = mul i64 %23, %19, !dbg !64
  %55 = add i64 %54, %27, !dbg !65
  %56 = getelementptr float, ptr %15, i64 %55, !dbg !66
  store float %53, ptr %56, align 4, !dbg !67
  %57 = add i64 %35, 1, !dbg !68
  br label %34, !dbg !69

58:                                               ; preds = %34
  %59 = add i64 %31, 1, !dbg !70
  br label %30, !dbg !71

60:                                               ; preds = %30
  %61 = add i64 %27, 1, !dbg !72
  br label %26, !dbg !73

62:                                               ; preds = %26
  %63 = add i64 %23, 1, !dbg !74
  br label %22, !dbg !75

64:                                               ; preds = %22
  ret void, !dbg !76
}

define void @main() !dbg !77 {
  %1 = call { ptr, ptr, i64, [2 x i64], [2 x i64] } @alloc_2d_filled_f32(i64 3, i64 3, float 1.000000e+00), !dbg !78
  %2 = call { ptr, ptr, i64, [2 x i64], [2 x i64] } @alloc_2d_filled_f32(i64 10, i64 10, float 1.000000e+00), !dbg !80
  %3 = call { ptr, ptr, i64, [2 x i64], [2 x i64] } @alloc_2d_filled_f32(i64 8, i64 8, float 0.000000e+00), !dbg !81
  %4 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %2, 0, !dbg !82
  %5 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %2, 1, !dbg !83
  %6 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %2, 2, !dbg !84
  %7 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %2, 3, 0, !dbg !85
  %8 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %2, 3, 1, !dbg !86
  %9 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %2, 4, 0, !dbg !87
  %10 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %2, 4, 1, !dbg !88
  %11 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %1, 0, !dbg !89
  %12 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %1, 1, !dbg !90
  %13 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %1, 2, !dbg !91
  %14 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %1, 3, 0, !dbg !92
  %15 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %1, 3, 1, !dbg !93
  %16 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %1, 4, 0, !dbg !94
  %17 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %1, 4, 1, !dbg !95
  %18 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 0, !dbg !96
  %19 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 1, !dbg !97
  %20 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 2, !dbg !98
  %21 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 3, 0, !dbg !99
  %22 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 3, 1, !dbg !100
  %23 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 4, 0, !dbg !101
  %24 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 4, 1, !dbg !102
  call void @conv_2d(ptr %4, ptr %5, i64 %6, i64 %7, i64 %8, i64 %9, i64 %10, ptr %11, ptr %12, i64 %13, i64 %14, i64 %15, i64 %16, i64 %17, ptr %18, ptr %19, i64 %20, i64 %21, i64 %22, i64 %23, i64 %24), !dbg !103
  %25 = alloca { ptr, ptr, i64, [2 x i64], [2 x i64] }, i64 1, align 8, !dbg !104
  store { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, ptr %25, align 8, !dbg !105
  call void @printMemrefF32(i64 2, ptr %25), !dbg !106
  %26 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %2, 0, !dbg !107
  call void @free(ptr %26), !dbg !108
  %27 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %1, 0, !dbg !109
  call void @free(ptr %27), !dbg !110
  %28 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 0, !dbg !111
  call void @free(ptr %28), !dbg !112
  ret void, !dbg !113
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
!35 = !DILocation(line: 47, column: 5, scope: !36)
!36 = !DILexicalBlockFile(scope: !34, file: !4, discriminator: 0)
!37 = !DILocation(line: 49, column: 10, scope: !36)
!38 = !DILocation(line: 50, column: 5, scope: !36)
!39 = !DILocation(line: 52, column: 5, scope: !36)
!40 = !DILocation(line: 54, column: 10, scope: !36)
!41 = !DILocation(line: 55, column: 5, scope: !36)
!42 = !DILocation(line: 57, column: 5, scope: !36)
!43 = !DILocation(line: 59, column: 10, scope: !36)
!44 = !DILocation(line: 60, column: 5, scope: !36)
!45 = !DILocation(line: 62, column: 5, scope: !36)
!46 = !DILocation(line: 64, column: 10, scope: !36)
!47 = !DILocation(line: 65, column: 5, scope: !36)
!48 = !DILocation(line: 67, column: 11, scope: !36)
!49 = !DILocation(line: 68, column: 11, scope: !36)
!50 = !DILocation(line: 69, column: 11, scope: !36)
!51 = !DILocation(line: 70, column: 11, scope: !36)
!52 = !DILocation(line: 71, column: 11, scope: !36)
!53 = !DILocation(line: 72, column: 11, scope: !36)
!54 = !DILocation(line: 73, column: 11, scope: !36)
!55 = !DILocation(line: 74, column: 11, scope: !36)
!56 = !DILocation(line: 75, column: 11, scope: !36)
!57 = !DILocation(line: 76, column: 11, scope: !36)
!58 = !DILocation(line: 77, column: 11, scope: !36)
!59 = !DILocation(line: 78, column: 11, scope: !36)
!60 = !DILocation(line: 79, column: 11, scope: !36)
!61 = !DILocation(line: 80, column: 11, scope: !36)
!62 = !DILocation(line: 81, column: 11, scope: !36)
!63 = !DILocation(line: 82, column: 11, scope: !36)
!64 = !DILocation(line: 83, column: 11, scope: !36)
!65 = !DILocation(line: 84, column: 11, scope: !36)
!66 = !DILocation(line: 85, column: 11, scope: !36)
!67 = !DILocation(line: 86, column: 5, scope: !36)
!68 = !DILocation(line: 87, column: 11, scope: !36)
!69 = !DILocation(line: 88, column: 5, scope: !36)
!70 = !DILocation(line: 90, column: 11, scope: !36)
!71 = !DILocation(line: 91, column: 5, scope: !36)
!72 = !DILocation(line: 93, column: 11, scope: !36)
!73 = !DILocation(line: 94, column: 5, scope: !36)
!74 = !DILocation(line: 96, column: 11, scope: !36)
!75 = !DILocation(line: 97, column: 5, scope: !36)
!76 = !DILocation(line: 99, column: 5, scope: !36)
!77 = distinct !DISubprogram(name: "main", linkageName: "main", scope: null, file: !4, line: 101, type: !5, scopeLine: 101, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !6)
!78 = !DILocation(line: 109, column: 10, scope: !79)
!79 = !DILexicalBlockFile(scope: !77, file: !4, discriminator: 0)
!80 = !DILocation(line: 110, column: 10, scope: !79)
!81 = !DILocation(line: 111, column: 10, scope: !79)
!82 = !DILocation(line: 112, column: 11, scope: !79)
!83 = !DILocation(line: 113, column: 11, scope: !79)
!84 = !DILocation(line: 114, column: 11, scope: !79)
!85 = !DILocation(line: 115, column: 11, scope: !79)
!86 = !DILocation(line: 116, column: 11, scope: !79)
!87 = !DILocation(line: 117, column: 11, scope: !79)
!88 = !DILocation(line: 118, column: 11, scope: !79)
!89 = !DILocation(line: 119, column: 11, scope: !79)
!90 = !DILocation(line: 120, column: 11, scope: !79)
!91 = !DILocation(line: 121, column: 11, scope: !79)
!92 = !DILocation(line: 122, column: 11, scope: !79)
!93 = !DILocation(line: 123, column: 11, scope: !79)
!94 = !DILocation(line: 124, column: 11, scope: !79)
!95 = !DILocation(line: 125, column: 11, scope: !79)
!96 = !DILocation(line: 126, column: 11, scope: !79)
!97 = !DILocation(line: 127, column: 11, scope: !79)
!98 = !DILocation(line: 128, column: 11, scope: !79)
!99 = !DILocation(line: 129, column: 11, scope: !79)
!100 = !DILocation(line: 130, column: 11, scope: !79)
!101 = !DILocation(line: 131, column: 11, scope: !79)
!102 = !DILocation(line: 132, column: 11, scope: !79)
!103 = !DILocation(line: 133, column: 5, scope: !79)
!104 = !DILocation(line: 134, column: 11, scope: !79)
!105 = !DILocation(line: 135, column: 5, scope: !79)
!106 = !DILocation(line: 137, column: 5, scope: !79)
!107 = !DILocation(line: 138, column: 11, scope: !79)
!108 = !DILocation(line: 140, column: 5, scope: !79)
!109 = !DILocation(line: 141, column: 11, scope: !79)
!110 = !DILocation(line: 143, column: 5, scope: !79)
!111 = !DILocation(line: 144, column: 11, scope: !79)
!112 = !DILocation(line: 146, column: 5, scope: !79)
!113 = !DILocation(line: 147, column: 5, scope: !79)
