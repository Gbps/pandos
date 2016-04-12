; ModuleID = 'src/kernel.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i686-pc-none-elf"

@.str = private unnamed_addr constant [22 x i8] c"Hello, kernel World!\0A\00", align 1

; Function Attrs: nounwind
define void @kernel_main() #0 {
entry:
  %test_mem = alloca i8*, align 4
  %test_mem_2 = alloca i8*, align 4
  call void asm sideeffect "xchg %bx, %bx", "~{dirflag},~{fpsr},~{flags}"() #3, !dbg !10, !srcloc !11
  call void bitcast (void (...)* @gdt_init to void ()*)() #4, !dbg !12
  call void @idt_init() #4, !dbg !13
  call void bitcast (void (...)* @terminal_initialize to void ()*)() #4, !dbg !14
  call void @terminal_writestring(i8* getelementptr inbounds ([22 x i8]* @.str, i32 0, i32 0)) #4, !dbg !15
  call void @llvm.dbg.declare(metadata !{i8** %test_mem}, metadata !16), !dbg !18
  %call = call i8* @kmalloc(i32 10) #4, !dbg !18
  store i8* %call, i8** %test_mem, align 4, !dbg !18
  call void @llvm.dbg.declare(metadata !{i8** %test_mem_2}, metadata !19), !dbg !20
  %call1 = call i8* @kmalloc(i32 10) #4, !dbg !20
  store i8* %call1, i8** %test_mem_2, align 4, !dbg !20
  %0 = load i8** %test_mem, align 4, !dbg !21
  call void @kfree(i8* %0) #4, !dbg !21
  %1 = load i8** %test_mem_2, align 4, !dbg !22
  call void @kfree(i8* %1) #4, !dbg !22
  %call2 = call i8* @kmalloc(i32 10) #4, !dbg !23
  store i8* %call2, i8** %test_mem, align 4, !dbg !23
  %call3 = call i8* @kmalloc(i32 10) #4, !dbg !24
  store i8* %call3, i8** %test_mem_2, align 4, !dbg !24
  %2 = load i8** %test_mem, align 4, !dbg !25
  call void @terminal_writestring(i8* %2) #4, !dbg !25
  br label %while.body, !dbg !26

while.body:                                       ; preds = %entry, %while.body
  call void asm sideeffect "hlt", "~{dirflag},~{fpsr},~{flags}"() #3, !dbg !27, !srcloc !29
  br label %while.body, !dbg !30

return:                                           ; No predecessors!
  ret void, !dbg !31
}

declare void @gdt_init(...) #1

declare void @idt_init() #1

declare void @terminal_initialize(...) #1

declare void @terminal_writestring(i8*) #1

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #2

declare i8* @kmalloc(i32) #1

declare void @kfree(i8*) #1

attributes #0 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind readnone }
attributes #3 = { nounwind }
attributes #4 = { nobuiltin }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!8}
!llvm.ident = !{!9}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"clang version 3.4 (http://llvm.org/git/clang.git 82a2911a94947e20ac4fd961b6322adf74ad9224) (http://llvm.org/git/llvm.git 52244da7f2b3def646900520668b859343b84a33)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !2, metadata !2, metadata !""} ; [ DW_TAG_compile_unit ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c] [DW_LANG_C99]
!1 = metadata !{metadata !"src/kernel.c", metadata !"/home/gbps/Desktop/Projects/os_notshared/pandos"}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"kernel_main", metadata !"kernel_main", metadata !"", i32 13, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, void ()* @kernel_main, null, null, metadata !2, i32 14} ; [ DW_TAG_subprogram ] [line 13] [def] [scope 14] [kernel_main]
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{null}
!8 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!9 = metadata !{metadata !"clang version 3.4 (http://llvm.org/git/clang.git 82a2911a94947e20ac4fd961b6322adf74ad9224) (http://llvm.org/git/llvm.git 52244da7f2b3def646900520668b859343b84a33)"}
!10 = metadata !{i32 15, i32 0, metadata !4, null}
!11 = metadata !{i32 237}
!12 = metadata !{i32 17, i32 0, metadata !4, null}
!13 = metadata !{i32 19, i32 0, metadata !4, null}
!14 = metadata !{i32 22, i32 0, metadata !4, null}
!15 = metadata !{i32 24, i32 0, metadata !4, null}
!16 = metadata !{i32 786688, metadata !4, metadata !"test_mem", metadata !5, i32 26, metadata !17, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [test_mem] [line 26]
!17 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from ]
!18 = metadata !{i32 26, i32 0, metadata !4, null}
!19 = metadata !{i32 786688, metadata !4, metadata !"test_mem_2", metadata !5, i32 27, metadata !17, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [test_mem_2] [line 27]
!20 = metadata !{i32 27, i32 0, metadata !4, null}
!21 = metadata !{i32 29, i32 0, metadata !4, null}
!22 = metadata !{i32 30, i32 0, metadata !4, null}
!23 = metadata !{i32 32, i32 0, metadata !4, null}
!24 = metadata !{i32 33, i32 0, metadata !4, null}
!25 = metadata !{i32 35, i32 0, metadata !4, null}
!26 = metadata !{i32 37, i32 0, metadata !4, null}
!27 = metadata !{i32 40, i32 0, metadata !28, null}
!28 = metadata !{i32 786443, metadata !1, metadata !4, i32 38, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!29 = metadata !{i32 736}
!30 = metadata !{i32 41, i32 0, metadata !28, null}
!31 = metadata !{i32 42, i32 0, metadata !4, null}
