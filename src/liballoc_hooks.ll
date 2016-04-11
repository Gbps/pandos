; ModuleID = 'src/liballoc_hooks.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i686-pc-none-elf"

@disabled_interrupts = global i8 0, align 1

; Function Attrs: nounwind
define i32 @liballoc_lock() #0 {
entry:
  call void asm sideeffect "cli", "~{dirflag},~{fpsr},~{flags}"() #3, !dbg !22, !srcloc !23
  store i8 1, i8* @disabled_interrupts, align 1, !dbg !24
  ret i32 0, !dbg !25
}

; Function Attrs: nounwind
define i32 @liballoc_unlock() #0 {
entry:
  %0 = load i8* @disabled_interrupts, align 1, !dbg !26
  %tobool = trunc i8 %0 to i1, !dbg !26
  br i1 %tobool, label %if.then, label %if.end, !dbg !26

if.then:                                          ; preds = %entry
  call void asm sideeffect "sti", "~{dirflag},~{fpsr},~{flags}"() #3, !dbg !28, !srcloc !30
  br label %if.end, !dbg !31

if.end:                                           ; preds = %if.then, %entry
  ret i32 0, !dbg !32
}

; Function Attrs: nounwind
define i8* @liballoc_alloc(i32 %n_pages) #0 {
entry:
  %n_pages.addr = alloca i32, align 4
  store i32 %n_pages, i32* %n_pages.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %n_pages.addr}, metadata !33), !dbg !34
  %0 = load i32* %n_pages.addr, align 4, !dbg !35
  %call = call i8* @kmmap(i32 %0) #4, !dbg !35
  ret i8* %call, !dbg !35
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

declare i8* @kmmap(i32) #2

; Function Attrs: nounwind
define i32 @liballoc_free(i8* %addr, i32 %pages) #0 {
entry:
  %addr.addr = alloca i8*, align 4
  %pages.addr = alloca i32, align 4
  store i8* %addr, i8** %addr.addr, align 4
  call void @llvm.dbg.declare(metadata !{i8** %addr.addr}, metadata !36), !dbg !37
  store i32 %pages, i32* %pages.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %pages.addr}, metadata !38), !dbg !37
  %0 = load i8** %addr.addr, align 4, !dbg !39
  %1 = load i32* %pages.addr, align 4, !dbg !39
  %call = call zeroext i1 @munmap(i8* %0, i32 %1) #4, !dbg !39
  %conv = zext i1 %call to i32, !dbg !39
  %cmp = icmp eq i32 %conv, 1, !dbg !39
  %cond = select i1 %cmp, i32 0, i32 1, !dbg !39
  ret i32 %cond, !dbg !39
}

declare zeroext i1 @munmap(i8*, i32) #2

attributes #0 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }
attributes #4 = { nobuiltin }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!20}
!llvm.ident = !{!21}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"clang version 3.4 (http://llvm.org/git/clang.git 82a2911a94947e20ac4fd961b6322adf74ad9224) (http://llvm.org/git/llvm.git 52244da7f2b3def646900520668b859343b84a33)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !17, metadata !2, metadata !""} ; [ DW_TAG_compile_unit ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc_hooks.c] [DW_LANG_C99]
!1 = metadata !{metadata !"src/liballoc_hooks.c", metadata !"/home/gbps/Desktop/Projects/os_notshared/pandos"}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4, metadata !9, metadata !10, metadata !14}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"liballoc_lock", metadata !"liballoc_lock", metadata !"", i32 14, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, i32 ()* @liballoc_lock, null, null, metadata !2, i32 15} ; [ DW_TAG_subprogram ] [line 14] [def] [scope 15] [liballoc_lock]
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc_hooks.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{metadata !8}
!8 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!9 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"liballoc_unlock", metadata !"liballoc_unlock", metadata !"", i32 29, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, i32 ()* @liballoc_unlock, null, null, metadata !2, i32 30} ; [ DW_TAG_subprogram ] [line 29] [def] [scope 30] [liballoc_unlock]
!10 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"liballoc_alloc", metadata !"liballoc_alloc", metadata !"", i32 46, metadata !11, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i8* (i32)* @liballoc_alloc, null, null, metadata !2, i32 47} ; [ DW_TAG_subprogram ] [line 46] [def] [scope 47] [liballoc_alloc]
!11 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !12, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!12 = metadata !{metadata !13, metadata !8}
!13 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from ]
!14 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"liballoc_free", metadata !"liballoc_free", metadata !"", i32 59, metadata !15, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i8*, i32)* @liballoc_free, null, null, metadata !2, i32 60} ; [ DW_TAG_subprogram ] [line 59] [def] [scope 60] [liballoc_free]
!15 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !16, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!16 = metadata !{metadata !8, metadata !13, metadata !8}
!17 = metadata !{metadata !18}
!18 = metadata !{i32 786484, i32 0, null, metadata !"disabled_interrupts", metadata !"disabled_interrupts", metadata !"", metadata !5, i32 5, metadata !19, i32 0, i32 1, i8* @disabled_interrupts, null} ; [ DW_TAG_variable ] [disabled_interrupts] [line 5] [def]
!19 = metadata !{i32 786468, null, null, metadata !"_Bool", i32 0, i64 8, i64 8, i64 0, i32 0, i32 2} ; [ DW_TAG_base_type ] [_Bool] [line 0, size 8, align 8, offset 0, enc DW_ATE_boolean]
!20 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!21 = metadata !{metadata !"clang version 3.4 (http://llvm.org/git/clang.git 82a2911a94947e20ac4fd961b6322adf74ad9224) (http://llvm.org/git/llvm.git 52244da7f2b3def646900520668b859343b84a33)"}
!22 = metadata !{i32 18, i32 0, metadata !4, null}
!23 = metadata !{i32 447}
!24 = metadata !{i32 19, i32 0, metadata !4, null}
!25 = metadata !{i32 20, i32 0, metadata !4, null}
!26 = metadata !{i32 31, i32 0, metadata !27, null}
!27 = metadata !{i32 786443, metadata !1, metadata !9, i32 31, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc_hooks.c]
!28 = metadata !{i32 34, i32 0, metadata !29, null}
!29 = metadata !{i32 786443, metadata !1, metadata !27, i32 32, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc_hooks.c]
!30 = metadata !{i32 868}
!31 = metadata !{i32 35, i32 0, metadata !29, null}
!32 = metadata !{i32 36, i32 0, metadata !9, null}
!33 = metadata !{i32 786689, metadata !10, metadata !"n_pages", metadata !5, i32 16777262, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [n_pages] [line 46]
!34 = metadata !{i32 46, i32 0, metadata !10, null}
!35 = metadata !{i32 48, i32 0, metadata !10, null}
!36 = metadata !{i32 786689, metadata !14, metadata !"addr", metadata !5, i32 16777275, metadata !13, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [addr] [line 59]
!37 = metadata !{i32 59, i32 0, metadata !14, null}
!38 = metadata !{i32 786689, metadata !14, metadata !"pages", metadata !5, i32 33554491, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [pages] [line 59]
!39 = metadata !{i32 61, i32 0, metadata !14, null}
