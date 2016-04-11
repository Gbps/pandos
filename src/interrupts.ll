; ModuleID = 'src/interrupts.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i686-pc-none-elf"

%struct.IDT_entry = type { i16, i16, i8, i8, i16 }
%struct.interrupt_frame = type { i32, i32, i32, i32, i32 }
%struct.anon = type <{ i16, i8* }>

@IDT = common global [1024 x %struct.IDT_entry] zeroinitializer, align 2

; Function Attrs: naked noinline nounwind
define void @keyboard_handler(%struct.interrupt_frame* %frame) #0 {
entry:
  %frame.addr = alloca %struct.interrupt_frame*, align 4
  store %struct.interrupt_frame* %frame, %struct.interrupt_frame** %frame.addr, align 4
  call void @llvm.dbg.declare(metadata !{%struct.interrupt_frame** %frame.addr}, metadata !49), !dbg !50
  call void asm sideeffect "pusha", "~{dirflag},~{fpsr},~{flags}"() #4, !dbg !51, !srcloc !52
  call void asm sideeffect "xchg %bx, %bx", "~{dirflag},~{fpsr},~{flags}"() #4, !dbg !53, !srcloc !54
  call void asm sideeffect "popa", "~{dirflag},~{fpsr},~{flags}"() #4, !dbg !55, !srcloc !56
  call void asm sideeffect "iret", "~{dirflag},~{fpsr},~{flags}"() #4, !dbg !57, !srcloc !58
  ret void, !dbg !59
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

; Function Attrs: nounwind
define void @idt_init() #2 {
entry:
  %keyboard_address = alloca i32, align 4
  %idt_addr = alloca i32, align 4
  %idt_ptr = alloca [2 x i32], align 4
  call void @llvm.dbg.declare(metadata !{i32* %keyboard_address}, metadata !60), !dbg !62
  call void @llvm.dbg.declare(metadata !{i32* %idt_addr}, metadata !63), !dbg !64
  call void @llvm.dbg.declare(metadata !{[2 x i32]* %idt_ptr}, metadata !65), !dbg !69
  store i32 add (i32 ptrtoint (void (%struct.interrupt_frame*)* @keyboard_handler to i32), i32 6), i32* %keyboard_address, align 4, !dbg !70
  %0 = load i32* %keyboard_address, align 4, !dbg !71
  %and = and i32 %0, 65535, !dbg !71
  %conv = trunc i32 %and to i16, !dbg !71
  store i16 %conv, i16* getelementptr inbounds ([1024 x %struct.IDT_entry]* @IDT, i32 0, i32 33, i32 0), align 2, !dbg !71
  store i16 8, i16* getelementptr inbounds ([1024 x %struct.IDT_entry]* @IDT, i32 0, i32 33, i32 1), align 2, !dbg !72
  store i8 0, i8* getelementptr inbounds ([1024 x %struct.IDT_entry]* @IDT, i32 0, i32 33, i32 2), align 1, !dbg !73
  store i8 -114, i8* getelementptr inbounds ([1024 x %struct.IDT_entry]* @IDT, i32 0, i32 33, i32 3), align 1, !dbg !74
  %1 = load i32* %keyboard_address, align 4, !dbg !75
  %and1 = and i32 %1, -65536, !dbg !75
  %shr = lshr i32 %and1, 16, !dbg !75
  %conv2 = trunc i32 %shr to i16, !dbg !75
  store i16 %conv2, i16* getelementptr inbounds ([1024 x %struct.IDT_entry]* @IDT, i32 0, i32 33, i32 4), align 2, !dbg !75
  call void @outb(i16 zeroext 32, i8 zeroext 17) #5, !dbg !76
  call void @outb(i16 zeroext 160, i8 zeroext 17) #5, !dbg !77
  call void @outb(i16 zeroext 33, i8 zeroext 32) #5, !dbg !78
  call void @outb(i16 zeroext 161, i8 zeroext 40) #5, !dbg !79
  call void @outb(i16 zeroext 33, i8 zeroext 0) #5, !dbg !80
  call void @outb(i16 zeroext 161, i8 zeroext 0) #5, !dbg !81
  call void @outb(i16 zeroext 33, i8 zeroext 1) #5, !dbg !82
  call void @outb(i16 zeroext 161, i8 zeroext 1) #5, !dbg !83
  call void @outb(i16 zeroext 33, i8 zeroext -1) #5, !dbg !84
  call void @outb(i16 zeroext 161, i8 zeroext -1) #5, !dbg !85
  call void @lidt(i8* bitcast ([1024 x %struct.IDT_entry]* @IDT to i8*), i16 zeroext 1024) #5, !dbg !86
  call void @kb_init() #5, !dbg !87
  call void asm sideeffect "sti", "~{dirflag},~{fpsr},~{flags}"() #4, !dbg !88, !srcloc !89
  ret void, !dbg !90
}

; Function Attrs: inlinehint nounwind
define internal void @outb(i16 zeroext %port, i8 zeroext %val) #3 {
entry:
  %port.addr = alloca i16, align 2
  %val.addr = alloca i8, align 1
  store i16 %port, i16* %port.addr, align 2
  call void @llvm.dbg.declare(metadata !{i16* %port.addr}, metadata !91), !dbg !92
  store i8 %val, i8* %val.addr, align 1
  call void @llvm.dbg.declare(metadata !{i8* %val.addr}, metadata !93), !dbg !92
  %0 = load i8* %val.addr, align 1, !dbg !94
  %1 = load i16* %port.addr, align 2, !dbg !94
  call void asm sideeffect "outb $0, $1", "{ax},N{dx},~{dirflag},~{fpsr},~{flags}"(i8 %0, i16 %1) #4, !dbg !94, !srcloc !95
  ret void, !dbg !96
}

; Function Attrs: inlinehint nounwind
define internal void @lidt(i8* %base, i16 zeroext %size) #3 {
entry:
  %base.addr = alloca i8*, align 4
  %size.addr = alloca i16, align 2
  %IDTR = alloca %struct.anon, align 1
  store i8* %base, i8** %base.addr, align 4
  call void @llvm.dbg.declare(metadata !{i8** %base.addr}, metadata !97), !dbg !98
  store i16 %size, i16* %size.addr, align 2
  call void @llvm.dbg.declare(metadata !{i16* %size.addr}, metadata !99), !dbg !98
  call void @llvm.dbg.declare(metadata !{%struct.anon* %IDTR}, metadata !100), !dbg !106
  %length = getelementptr inbounds %struct.anon* %IDTR, i32 0, i32 0, !dbg !107
  %0 = load i16* %size.addr, align 2, !dbg !107
  store i16 %0, i16* %length, align 1, !dbg !107
  %base1 = getelementptr inbounds %struct.anon* %IDTR, i32 0, i32 1, !dbg !107
  %1 = load i8** %base.addr, align 4, !dbg !107
  store i8* %1, i8** %base1, align 1, !dbg !107
  call void asm sideeffect "lidt $0", "*m,~{dirflag},~{fpsr},~{flags}"(%struct.anon* %IDTR) #4, !dbg !108, !srcloc !109
  ret void, !dbg !110
}

; Function Attrs: nounwind
define void @kb_init() #2 {
entry:
  call void @outb(i16 zeroext 33, i8 zeroext -3) #5, !dbg !111
  ret void, !dbg !112
}

attributes #0 = { naked noinline nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { inlinehint nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }
attributes #5 = { nobuiltin }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!47}
!llvm.ident = !{!48}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"clang version 3.4 (http://llvm.org/git/clang.git 82a2911a94947e20ac4fd961b6322adf74ad9224) (http://llvm.org/git/llvm.git 52244da7f2b3def646900520668b859343b84a33)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !35, metadata !2, metadata !""} ; [ DW_TAG_compile_unit ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/interrupts.c] [DW_LANG_C99]
!1 = metadata !{metadata !"src/interrupts.c", metadata !"/home/gbps/Desktop/Projects/os_notshared/pandos"}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4, metadata !18, metadata !21, metadata !22, metadata !30}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"keyboard_handler", metadata !"keyboard_handler", metadata !"", i32 50, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (%struct.interrupt_frame*)* @keyboard_handler, null, null, metadata !2, i32 51} ; [ DW_TAG_subprogram ] [line 50] [def] [scope 51] [keyboard_handler]
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/interrupts.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{null, metadata !8}
!8 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, metadata !9} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from interrupt_frame]
!9 = metadata !{i32 786451, metadata !1, null, metadata !"interrupt_frame", i32 37, i64 160, i64 32, i32 0, i32 0, null, metadata !10, i32 0, null, null, null} ; [ DW_TAG_structure_type ] [interrupt_frame] [line 37, size 160, align 32, offset 0] [def] [from ]
!10 = metadata !{metadata !11, metadata !14, metadata !15, metadata !16, metadata !17}
!11 = metadata !{i32 786445, metadata !1, metadata !9, metadata !"ip", i32 39, i64 32, i64 32, i64 0, i32 0, metadata !12} ; [ DW_TAG_member ] [ip] [line 39, size 32, align 32, offset 0] [from uint32_t]
!12 = metadata !{i32 786454, metadata !1, null, metadata !"uint32_t", i32 42, i64 0, i64 0, i64 0, i32 0, metadata !13} ; [ DW_TAG_typedef ] [uint32_t] [line 42, size 0, align 0, offset 0] [from unsigned int]
!13 = metadata !{i32 786468, null, null, metadata !"unsigned int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [unsigned int] [line 0, size 32, align 32, offset 0, enc DW_ATE_unsigned]
!14 = metadata !{i32 786445, metadata !1, metadata !9, metadata !"cs", i32 40, i64 32, i64 32, i64 32, i32 0, metadata !12} ; [ DW_TAG_member ] [cs] [line 40, size 32, align 32, offset 32] [from uint32_t]
!15 = metadata !{i32 786445, metadata !1, metadata !9, metadata !"flags", i32 41, i64 32, i64 32, i64 64, i32 0, metadata !12} ; [ DW_TAG_member ] [flags] [line 41, size 32, align 32, offset 64] [from uint32_t]
!16 = metadata !{i32 786445, metadata !1, metadata !9, metadata !"sp", i32 42, i64 32, i64 32, i64 96, i32 0, metadata !12} ; [ DW_TAG_member ] [sp] [line 42, size 32, align 32, offset 96] [from uint32_t]
!17 = metadata !{i32 786445, metadata !1, metadata !9, metadata !"ss", i32 43, i64 32, i64 32, i64 128, i32 0, metadata !12} ; [ DW_TAG_member ] [ss] [line 43, size 32, align 32, offset 128] [from uint32_t]
!18 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"idt_init", metadata !"idt_init", metadata !"", i32 61, metadata !19, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void ()* @idt_init, null, null, metadata !2, i32 62} ; [ DW_TAG_subprogram ] [line 61] [def] [scope 62] [idt_init]
!19 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !20, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!20 = metadata !{null}
!21 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"kb_init", metadata !"kb_init", metadata !"", i32 124, metadata !19, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void ()* @kb_init, null, null, metadata !2, i32 125} ; [ DW_TAG_subprogram ] [line 124] [def] [scope 125] [kb_init]
!22 = metadata !{i32 786478, metadata !23, metadata !24, metadata !"lidt", metadata !"lidt", metadata !"", i32 12, metadata !25, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i8*, i16)* @lidt, null, null, metadata !2, i32 13} ; [ DW_TAG_subprogram ] [line 12] [local] [def] [scope 13] [lidt]
!23 = metadata !{metadata !"src/inline.c", metadata !"/home/gbps/Desktop/Projects/os_notshared/pandos"}
!24 = metadata !{i32 786473, metadata !23}        ; [ DW_TAG_file_type ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/inline.c]
!25 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !26, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!26 = metadata !{null, metadata !27, metadata !28}
!27 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from ]
!28 = metadata !{i32 786454, metadata !23, null, metadata !"uint16_t", i32 219, i64 0, i64 0, i64 0, i32 0, metadata !29} ; [ DW_TAG_typedef ] [uint16_t] [line 219, size 0, align 0, offset 0] [from unsigned short]
!29 = metadata !{i32 786468, null, null, metadata !"unsigned short", i32 0, i64 16, i64 16, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [unsigned short] [line 0, size 16, align 16, offset 0, enc DW_ATE_unsigned]
!30 = metadata !{i32 786478, metadata !23, metadata !24, metadata !"outb", metadata !"outb", metadata !"", i32 3, metadata !31, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i16, i8)* @outb, null, null, metadata !2, i32 4} ; [ DW_TAG_subprogram ] [line 3] [local] [def] [scope 4] [outb]
!31 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !32, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!32 = metadata !{null, metadata !28, metadata !33}
!33 = metadata !{i32 786454, metadata !23, null, metadata !"uint8_t", i32 238, i64 0, i64 0, i64 0, i32 0, metadata !34} ; [ DW_TAG_typedef ] [uint8_t] [line 238, size 0, align 0, offset 0] [from unsigned char]
!34 = metadata !{i32 786468, null, null, metadata !"unsigned char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 8} ; [ DW_TAG_base_type ] [unsigned char] [line 0, size 8, align 8, offset 0, enc DW_ATE_unsigned_char]
!35 = metadata !{metadata !36}
!36 = metadata !{i32 786484, i32 0, null, metadata !"IDT", metadata !"IDT", metadata !"", metadata !5, i32 34, metadata !37, i32 0, i32 1, [1024 x %struct.IDT_entry]* @IDT, null} ; [ DW_TAG_variable ] [IDT] [line 34] [def]
!37 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 65536, i64 16, i32 0, i32 0, metadata !38, metadata !45, i32 0, null, null, null} ; [ DW_TAG_array_type ] [line 0, size 65536, align 16, offset 0] [from IDT_entry]
!38 = metadata !{i32 786451, metadata !1, null, metadata !"IDT_entry", i32 25, i64 64, i64 16, i32 0, i32 0, null, metadata !39, i32 0, null, null, null} ; [ DW_TAG_structure_type ] [IDT_entry] [line 25, size 64, align 16, offset 0] [def] [from ]
!39 = metadata !{metadata !40, metadata !41, metadata !42, metadata !43, metadata !44}
!40 = metadata !{i32 786445, metadata !1, metadata !38, metadata !"offset_lowerbits", i32 27, i64 16, i64 16, i64 0, i32 0, metadata !29} ; [ DW_TAG_member ] [offset_lowerbits] [line 27, size 16, align 16, offset 0] [from unsigned short]
!41 = metadata !{i32 786445, metadata !1, metadata !38, metadata !"selector", i32 28, i64 16, i64 16, i64 16, i32 0, metadata !29} ; [ DW_TAG_member ] [selector] [line 28, size 16, align 16, offset 16] [from unsigned short]
!42 = metadata !{i32 786445, metadata !1, metadata !38, metadata !"zero", i32 29, i64 8, i64 8, i64 32, i32 0, metadata !34} ; [ DW_TAG_member ] [zero] [line 29, size 8, align 8, offset 32] [from unsigned char]
!43 = metadata !{i32 786445, metadata !1, metadata !38, metadata !"type_attr", i32 30, i64 8, i64 8, i64 40, i32 0, metadata !34} ; [ DW_TAG_member ] [type_attr] [line 30, size 8, align 8, offset 40] [from unsigned char]
!44 = metadata !{i32 786445, metadata !1, metadata !38, metadata !"offset_higherbits", i32 31, i64 16, i64 16, i64 48, i32 0, metadata !29} ; [ DW_TAG_member ] [offset_higherbits] [line 31, size 16, align 16, offset 48] [from unsigned short]
!45 = metadata !{metadata !46}
!46 = metadata !{i32 786465, i64 0, i64 1024}     ; [ DW_TAG_subrange_type ] [0, 1023]
!47 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!48 = metadata !{metadata !"clang version 3.4 (http://llvm.org/git/clang.git 82a2911a94947e20ac4fd961b6322adf74ad9224) (http://llvm.org/git/llvm.git 52244da7f2b3def646900520668b859343b84a33)"}
!49 = metadata !{i32 786689, metadata !4, metadata !"frame", metadata !5, i32 16777266, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [frame] [line 50]
!50 = metadata !{i32 50, i32 0, metadata !4, null}
!51 = metadata !{i32 52, i32 0, metadata !4, null}
!52 = metadata !{i32 1011}
!53 = metadata !{i32 54, i32 0, metadata !4, null}
!54 = metadata !{i32 1030}
!55 = metadata !{i32 57, i32 0, metadata !4, null}
!56 = metadata !{i32 1080}
!57 = metadata !{i32 58, i32 0, metadata !4, null} ; [ DW_TAG_imported_module ]
!58 = metadata !{i32 1097}
!59 = metadata !{i32 59, i32 0, metadata !4, null}
!60 = metadata !{i32 786688, metadata !18, metadata !"keyboard_address", metadata !5, i32 63, metadata !61, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [keyboard_address] [line 63]
!61 = metadata !{i32 786468, null, null, metadata !"long unsigned int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [long unsigned int] [line 0, size 32, align 32, offset 0, enc DW_ATE_unsigned]
!62 = metadata !{i32 63, i32 0, metadata !18, null}
!63 = metadata !{i32 786688, metadata !18, metadata !"idt_addr", metadata !5, i32 64, metadata !61, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [idt_addr] [line 64]
!64 = metadata !{i32 64, i32 0, metadata !18, null}
!65 = metadata !{i32 786688, metadata !18, metadata !"idt_ptr", metadata !5, i32 65, metadata !66, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [idt_ptr] [line 65]
!66 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 64, i64 32, i32 0, i32 0, metadata !61, metadata !67, i32 0, null, null, null} ; [ DW_TAG_array_type ] [line 0, size 64, align 32, offset 0] [from long unsigned int]
!67 = metadata !{metadata !68}
!68 = metadata !{i32 786465, i64 0, i64 2}        ; [ DW_TAG_subrange_type ] [0, 1]
!69 = metadata !{i32 65, i32 0, metadata !18, null}
!70 = metadata !{i32 67, i32 0, metadata !18, null}
!71 = metadata !{i32 68, i32 0, metadata !18, null}
!72 = metadata !{i32 69, i32 0, metadata !18, null}
!73 = metadata !{i32 70, i32 0, metadata !18, null}
!74 = metadata !{i32 71, i32 0, metadata !18, null}
!75 = metadata !{i32 72, i32 0, metadata !18, null}
!76 = metadata !{i32 81, i32 0, metadata !18, null}
!77 = metadata !{i32 82, i32 0, metadata !18, null}
!78 = metadata !{i32 89, i32 0, metadata !18, null}
!79 = metadata !{i32 90, i32 0, metadata !18, null}
!80 = metadata !{i32 93, i32 0, metadata !18, null}
!81 = metadata !{i32 94, i32 0, metadata !18, null}
!82 = metadata !{i32 97, i32 0, metadata !18, null}
!83 = metadata !{i32 98, i32 0, metadata !18, null}
!84 = metadata !{i32 104, i32 0, metadata !18, null}
!85 = metadata !{i32 105, i32 0, metadata !18, null}
!86 = metadata !{i32 116, i32 0, metadata !18, null}
!87 = metadata !{i32 118, i32 0, metadata !18, null}
!88 = metadata !{i32 120, i32 0, metadata !18, null}
!89 = metadata !{i32 2906}
!90 = metadata !{i32 122, i32 0, metadata !18, null}
!91 = metadata !{i32 786689, metadata !30, metadata !"port", metadata !24, i32 16777219, metadata !28, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [port] [line 3]
!92 = metadata !{i32 3, i32 0, metadata !30, null}
!93 = metadata !{i32 786689, metadata !30, metadata !"val", metadata !24, i32 33554435, metadata !33, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [val] [line 3]
!94 = metadata !{i32 5, i32 0, metadata !30, null}
!95 = metadata !{i32 36528}
!96 = metadata !{i32 10, i32 0, metadata !30, null}
!97 = metadata !{i32 786689, metadata !22, metadata !"base", metadata !24, i32 16777228, metadata !27, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [base] [line 12]
!98 = metadata !{i32 12, i32 0, metadata !22, null}
!99 = metadata !{i32 786689, metadata !22, metadata !"size", metadata !24, i32 33554444, metadata !28, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [size] [line 12]
!100 = metadata !{i32 786688, metadata !101, metadata !"IDTR", metadata !24, i32 17, metadata !102, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [IDTR] [line 17]
!101 = metadata !{i32 786443, metadata !23, metadata !22} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/inline.c]
!102 = metadata !{i32 786451, metadata !23, metadata !22, metadata !"", i32 14, i64 48, i64 8, i32 0, i32 0, null, metadata !103, i32 0, null, null, null} ; [ DW_TAG_structure_type ] [line 14, size 48, align 8, offset 0] [def] [from ]
!103 = metadata !{metadata !104, metadata !105}
!104 = metadata !{i32 786445, metadata !23, metadata !102, metadata !"length", i32 15, i64 16, i64 16, i64 0, i32 0, metadata !28} ; [ DW_TAG_member ] [length] [line 15, size 16, align 16, offset 0] [from uint16_t]
!105 = metadata !{i32 786445, metadata !23, metadata !102, metadata !"base", i32 16, i64 32, i64 32, i64 16, i32 0, metadata !27} ; [ DW_TAG_member ] [base] [line 16, size 32, align 32, offset 16] [from ]
!106 = metadata !{i32 17, i32 0, metadata !101, null}
!107 = metadata !{i32 14, i32 0, metadata !101, null}
!108 = metadata !{i32 19, i32 0, metadata !101, null}
!109 = metadata !{i32 37202}
!110 = metadata !{i32 20, i32 0, metadata !101, null}
!111 = metadata !{i32 127, i32 0, metadata !21, null}
!112 = metadata !{i32 128, i32 0, metadata !21, null}
