; ModuleID = 'src/bitmap.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i686-pc-none-elf"

; Function Attrs: nounwind
define void @bm_set_bit(i32* %words, i32 %n) #0 {
entry:
  %words.addr = alloca i32*, align 4
  %n.addr = alloca i32, align 4
  store i32* %words, i32** %words.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32** %words.addr}, metadata !22), !dbg !23
  store i32 %n, i32* %n.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %n.addr}, metadata !24), !dbg !23
  %0 = load i32* %n.addr, align 4, !dbg !25
  %rem = srem i32 %0, 32, !dbg !25
  %shl = shl i32 1, %rem, !dbg !25
  %1 = load i32* %n.addr, align 4, !dbg !25
  %div = sdiv i32 %1, 32, !dbg !25
  %2 = load i32** %words.addr, align 4, !dbg !25
  %arrayidx = getelementptr inbounds i32* %2, i32 %div, !dbg !25
  %3 = load i32* %arrayidx, align 4, !dbg !25
  %or = or i32 %3, %shl, !dbg !25
  store i32 %or, i32* %arrayidx, align 4, !dbg !25
  ret void, !dbg !26
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

; Function Attrs: nounwind
define void @bm_clear_bit(i32* %words, i32 %n) #0 {
entry:
  %words.addr = alloca i32*, align 4
  %n.addr = alloca i32, align 4
  store i32* %words, i32** %words.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32** %words.addr}, metadata !27), !dbg !28
  store i32 %n, i32* %n.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %n.addr}, metadata !29), !dbg !28
  %0 = load i32* %n.addr, align 4, !dbg !30
  %rem = srem i32 %0, 32, !dbg !30
  %shl = shl i32 1, %rem, !dbg !30
  %neg = xor i32 %shl, -1, !dbg !30
  %1 = load i32* %n.addr, align 4, !dbg !30
  %div = sdiv i32 %1, 32, !dbg !30
  %2 = load i32** %words.addr, align 4, !dbg !30
  %arrayidx = getelementptr inbounds i32* %2, i32 %div, !dbg !30
  %3 = load i32* %arrayidx, align 4, !dbg !30
  %and = and i32 %3, %neg, !dbg !30
  store i32 %and, i32* %arrayidx, align 4, !dbg !30
  ret void, !dbg !31
}

; Function Attrs: nounwind
define i32 @bm_get_bit(i32* %words, i32 %n) #0 {
entry:
  %words.addr = alloca i32*, align 4
  %n.addr = alloca i32, align 4
  %bit = alloca i32, align 4
  store i32* %words, i32** %words.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32** %words.addr}, metadata !32), !dbg !33
  store i32 %n, i32* %n.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %n.addr}, metadata !34), !dbg !33
  call void @llvm.dbg.declare(metadata !{i32* %bit}, metadata !35), !dbg !36
  %0 = load i32* %n.addr, align 4, !dbg !36
  %div = sdiv i32 %0, 32, !dbg !36
  %1 = load i32** %words.addr, align 4, !dbg !36
  %arrayidx = getelementptr inbounds i32* %1, i32 %div, !dbg !36
  %2 = load i32* %arrayidx, align 4, !dbg !36
  %3 = load i32* %n.addr, align 4, !dbg !36
  %rem = srem i32 %3, 32, !dbg !36
  %shl = shl i32 1, %rem, !dbg !36
  %and = and i32 %2, %shl, !dbg !36
  store i32 %and, i32* %bit, align 4, !dbg !36
  %4 = load i32* %bit, align 4, !dbg !37
  %cmp = icmp ne i32 %4, 0, !dbg !37
  %conv = zext i1 %cmp to i32, !dbg !37
  ret i32 %conv, !dbg !37
}

attributes #0 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!20}
!llvm.ident = !{!21}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"clang version 3.4 (http://llvm.org/git/clang.git 82a2911a94947e20ac4fd961b6322adf74ad9224) (http://llvm.org/git/llvm.git 52244da7f2b3def646900520668b859343b84a33)", i1 false, metadata !"", i32 0, metadata !2, metadata !6, metadata !7, metadata !6, metadata !6, metadata !""} ; [ DW_TAG_compile_unit ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/bitmap.c] [DW_LANG_C99]
!1 = metadata !{metadata !"src/bitmap.c", metadata !"/home/gbps/Desktop/Projects/os_notshared/pandos"}
!2 = metadata !{metadata !3}
!3 = metadata !{i32 786436, metadata !1, null, metadata !"", i32 3, i64 32, i64 32, i32 0, i32 0, null, metadata !4, i32 0, null, null, null} ; [ DW_TAG_enumeration_type ] [line 3, size 32, align 32, offset 0] [def] [from ]
!4 = metadata !{metadata !5}
!5 = metadata !{i32 786472, metadata !"BITS_PER_WORD", i64 32} ; [ DW_TAG_enumerator ] [BITS_PER_WORD :: 32]
!6 = metadata !{i32 0}
!7 = metadata !{metadata !8, metadata !16, metadata !17}
!8 = metadata !{i32 786478, metadata !1, metadata !9, metadata !"bm_set_bit", metadata !"bm_set_bit", metadata !"", i32 7, metadata !10, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i32*, i32)* @bm_set_bit, null, null, metadata !6, i32 7} ; [ DW_TAG_subprogram ] [line 7] [def] [bm_set_bit]
!9 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/bitmap.c]
!10 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !11, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!11 = metadata !{null, metadata !12, metadata !15}
!12 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, metadata !13} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from uint32_t]
!13 = metadata !{i32 786454, metadata !1, null, metadata !"uint32_t", i32 184, i64 0, i64 0, i64 0, i32 0, metadata !14} ; [ DW_TAG_typedef ] [uint32_t] [line 184, size 0, align 0, offset 0] [from unsigned int]
!14 = metadata !{i32 786468, null, null, metadata !"unsigned int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [unsigned int] [line 0, size 32, align 32, offset 0, enc DW_ATE_unsigned]
!15 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!16 = metadata !{i32 786478, metadata !1, metadata !9, metadata !"bm_clear_bit", metadata !"bm_clear_bit", metadata !"", i32 11, metadata !10, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i32*, i32)* @bm_clear_bit, null, null, metadata !6, i32 11} ; [ DW_TAG_subprogram ] [line 11] [def] [bm_clear_bit]
!17 = metadata !{i32 786478, metadata !1, metadata !9, metadata !"bm_get_bit", metadata !"bm_get_bit", metadata !"", i32 15, metadata !18, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32*, i32)* @bm_get_bit, null, null, metadata !6, i32 15} ; [ DW_TAG_subprogram ] [line 15] [def] [bm_get_bit]
!18 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !19, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!19 = metadata !{metadata !15, metadata !12, metadata !15}
!20 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!21 = metadata !{metadata !"clang version 3.4 (http://llvm.org/git/clang.git 82a2911a94947e20ac4fd961b6322adf74ad9224) (http://llvm.org/git/llvm.git 52244da7f2b3def646900520668b859343b84a33)"}
!22 = metadata !{i32 786689, metadata !8, metadata !"words", metadata !9, i32 16777223, metadata !12, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [words] [line 7]
!23 = metadata !{i32 7, i32 0, metadata !8, null}
!24 = metadata !{i32 786689, metadata !8, metadata !"n", metadata !9, i32 33554439, metadata !15, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [n] [line 7]
!25 = metadata !{i32 8, i32 0, metadata !8, null} ; [ DW_TAG_imported_declaration ]
!26 = metadata !{i32 9, i32 0, metadata !8, null}
!27 = metadata !{i32 786689, metadata !16, metadata !"words", metadata !9, i32 16777227, metadata !12, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [words] [line 11]
!28 = metadata !{i32 11, i32 0, metadata !16, null}
!29 = metadata !{i32 786689, metadata !16, metadata !"n", metadata !9, i32 33554443, metadata !15, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [n] [line 11]
!30 = metadata !{i32 12, i32 0, metadata !16, null}
!31 = metadata !{i32 13, i32 0, metadata !16, null}
!32 = metadata !{i32 786689, metadata !17, metadata !"words", metadata !9, i32 16777231, metadata !12, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [words] [line 15]
!33 = metadata !{i32 15, i32 0, metadata !17, null}
!34 = metadata !{i32 786689, metadata !17, metadata !"n", metadata !9, i32 33554447, metadata !15, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [n] [line 15]
!35 = metadata !{i32 786688, metadata !17, metadata !"bit", metadata !9, i32 16, metadata !13, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [bit] [line 16]
!36 = metadata !{i32 16, i32 0, metadata !17, null}
!37 = metadata !{i32 17, i32 0, metadata !17, null}
