; ModuleID = 'src/gdt.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i686-pc-none-elf"

%struct.gdt_ptr_struct = type <{ i16, i32 }>
%struct.gdt_entry_struct = type <{ i16, i16, i8, i8, i8, i8 }>

@gdt_ptr = common global %struct.gdt_ptr_struct zeroinitializer, align 1
@gdt_entries = common global [5 x %struct.gdt_entry_struct] zeroinitializer, align 1

; Function Attrs: nounwind
define void @gdt_init() #0 {
entry:
  store i16 39, i16* getelementptr inbounds (%struct.gdt_ptr_struct* @gdt_ptr, i32 0, i32 0), align 1, !dbg !42
  store i32 ptrtoint ([5 x %struct.gdt_entry_struct]* @gdt_entries to i32), i32* getelementptr inbounds (%struct.gdt_ptr_struct* @gdt_ptr, i32 0, i32 1), align 1, !dbg !43
  call void @gdt_set_gate(i32 0, i32 0, i32 0, i8 zeroext 0, i8 zeroext 0) #3, !dbg !44
  call void @gdt_set_gate(i32 1, i32 0, i32 -1, i8 zeroext -102, i8 zeroext -49) #3, !dbg !45
  call void @gdt_set_gate(i32 2, i32 0, i32 -1, i8 zeroext -110, i8 zeroext -49) #3, !dbg !46
  call void @gdt_set_gate(i32 3, i32 0, i32 -1, i8 zeroext -6, i8 zeroext -49) #3, !dbg !47
  call void @gdt_set_gate(i32 4, i32 0, i32 -1, i8 zeroext -14, i8 zeroext -49) #3, !dbg !48
  call void @gdt_flush(i32 ptrtoint (%struct.gdt_ptr_struct* @gdt_ptr to i32)) #3, !dbg !49
  ret void, !dbg !50
}

; Function Attrs: nounwind
define internal void @gdt_set_gate(i32 %num, i32 %base, i32 %limit, i8 zeroext %access, i8 zeroext %gran) #0 {
entry:
  %num.addr = alloca i32, align 4
  %base.addr = alloca i32, align 4
  %limit.addr = alloca i32, align 4
  %access.addr = alloca i8, align 1
  %gran.addr = alloca i8, align 1
  store i32 %num, i32* %num.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %num.addr}, metadata !51), !dbg !52
  store i32 %base, i32* %base.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %base.addr}, metadata !53), !dbg !52
  store i32 %limit, i32* %limit.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %limit.addr}, metadata !54), !dbg !52
  store i8 %access, i8* %access.addr, align 1
  call void @llvm.dbg.declare(metadata !{i8* %access.addr}, metadata !55), !dbg !52
  store i8 %gran, i8* %gran.addr, align 1
  call void @llvm.dbg.declare(metadata !{i8* %gran.addr}, metadata !56), !dbg !52
  %0 = load i32* %base.addr, align 4, !dbg !57
  %and = and i32 %0, 65535, !dbg !57
  %conv = trunc i32 %and to i16, !dbg !57
  %1 = load i32* %num.addr, align 4, !dbg !57
  %arrayidx = getelementptr inbounds [5 x %struct.gdt_entry_struct]* @gdt_entries, i32 0, i32 %1, !dbg !57
  %base_low = getelementptr inbounds %struct.gdt_entry_struct* %arrayidx, i32 0, i32 1, !dbg !57
  store i16 %conv, i16* %base_low, align 1, !dbg !57
  %2 = load i32* %base.addr, align 4, !dbg !58
  %shr = lshr i32 %2, 16, !dbg !58
  %and1 = and i32 %shr, 255, !dbg !58
  %conv2 = trunc i32 %and1 to i8, !dbg !58
  %3 = load i32* %num.addr, align 4, !dbg !58
  %arrayidx3 = getelementptr inbounds [5 x %struct.gdt_entry_struct]* @gdt_entries, i32 0, i32 %3, !dbg !58
  %base_middle = getelementptr inbounds %struct.gdt_entry_struct* %arrayidx3, i32 0, i32 2, !dbg !58
  store i8 %conv2, i8* %base_middle, align 1, !dbg !58
  %4 = load i32* %base.addr, align 4, !dbg !59
  %shr4 = lshr i32 %4, 24, !dbg !59
  %and5 = and i32 %shr4, 255, !dbg !59
  %conv6 = trunc i32 %and5 to i8, !dbg !59
  %5 = load i32* %num.addr, align 4, !dbg !59
  %arrayidx7 = getelementptr inbounds [5 x %struct.gdt_entry_struct]* @gdt_entries, i32 0, i32 %5, !dbg !59
  %base_high = getelementptr inbounds %struct.gdt_entry_struct* %arrayidx7, i32 0, i32 5, !dbg !59
  store i8 %conv6, i8* %base_high, align 1, !dbg !59
  %6 = load i32* %limit.addr, align 4, !dbg !60
  %and8 = and i32 %6, 65535, !dbg !60
  %conv9 = trunc i32 %and8 to i16, !dbg !60
  %7 = load i32* %num.addr, align 4, !dbg !60
  %arrayidx10 = getelementptr inbounds [5 x %struct.gdt_entry_struct]* @gdt_entries, i32 0, i32 %7, !dbg !60
  %limit_low = getelementptr inbounds %struct.gdt_entry_struct* %arrayidx10, i32 0, i32 0, !dbg !60
  store i16 %conv9, i16* %limit_low, align 1, !dbg !60
  %8 = load i32* %limit.addr, align 4, !dbg !61
  %shr11 = lshr i32 %8, 16, !dbg !61
  %and12 = and i32 %shr11, 15, !dbg !61
  %conv13 = trunc i32 %and12 to i8, !dbg !61
  %9 = load i32* %num.addr, align 4, !dbg !61
  %arrayidx14 = getelementptr inbounds [5 x %struct.gdt_entry_struct]* @gdt_entries, i32 0, i32 %9, !dbg !61
  %granularity = getelementptr inbounds %struct.gdt_entry_struct* %arrayidx14, i32 0, i32 4, !dbg !61
  store i8 %conv13, i8* %granularity, align 1, !dbg !61
  %10 = load i8* %gran.addr, align 1, !dbg !62
  %conv15 = zext i8 %10 to i32, !dbg !62
  %and16 = and i32 %conv15, 240, !dbg !62
  %11 = load i32* %num.addr, align 4, !dbg !62
  %arrayidx17 = getelementptr inbounds [5 x %struct.gdt_entry_struct]* @gdt_entries, i32 0, i32 %11, !dbg !62
  %granularity18 = getelementptr inbounds %struct.gdt_entry_struct* %arrayidx17, i32 0, i32 4, !dbg !62
  %12 = load i8* %granularity18, align 1, !dbg !62
  %conv19 = zext i8 %12 to i32, !dbg !62
  %or = or i32 %conv19, %and16, !dbg !62
  %conv20 = trunc i32 %or to i8, !dbg !62
  store i8 %conv20, i8* %granularity18, align 1, !dbg !62
  %13 = load i8* %access.addr, align 1, !dbg !63
  %14 = load i32* %num.addr, align 4, !dbg !63
  %arrayidx21 = getelementptr inbounds [5 x %struct.gdt_entry_struct]* @gdt_entries, i32 0, i32 %14, !dbg !63
  %access22 = getelementptr inbounds %struct.gdt_entry_struct* %arrayidx21, i32 0, i32 3, !dbg !63
  store i8 %13, i8* %access22, align 1, !dbg !63
  ret void, !dbg !64
}

declare void @gdt_flush(i32) #1

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #2

attributes #0 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind readnone }
attributes #3 = { nobuiltin }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!40}
!llvm.ident = !{!41}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"clang version 3.4 (http://llvm.org/git/clang.git 82a2911a94947e20ac4fd961b6322adf74ad9224) (http://llvm.org/git/llvm.git 52244da7f2b3def646900520668b859343b84a33)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !18, metadata !2, metadata !""} ; [ DW_TAG_compile_unit ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/gdt.c] [DW_LANG_C99]
!1 = metadata !{metadata !"src/gdt.c", metadata !"/home/gbps/Desktop/Projects/os_notshared/pandos"}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4, metadata !8}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"gdt_init", metadata !"gdt_init", metadata !"", i32 14, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, void ()* @gdt_init, null, null, metadata !2, i32 15} ; [ DW_TAG_subprogram ] [line 14] [def] [scope 15] [gdt_init]
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/gdt.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{null}
!8 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"gdt_set_gate", metadata !"gdt_set_gate", metadata !"", i32 29, metadata !9, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i32, i32, i32, i8, i8)* @gdt_set_gate, null, null, metadata !2, i32 30} ; [ DW_TAG_subprogram ] [line 29] [local] [def] [scope 30] [gdt_set_gate]
!9 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !10, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!10 = metadata !{null, metadata !11, metadata !13, metadata !13, metadata !16, metadata !16}
!11 = metadata !{i32 786454, metadata !1, null, metadata !"int32_t", i32 179, i64 0, i64 0, i64 0, i32 0, metadata !12} ; [ DW_TAG_typedef ] [int32_t] [line 179, size 0, align 0, offset 0] [from int]
!12 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!13 = metadata !{i32 786454, metadata !14, null, metadata !"uint32_t", i32 184, i64 0, i64 0, i64 0, i32 0, metadata !15} ; [ DW_TAG_typedef ] [uint32_t] [line 184, size 0, align 0, offset 0] [from unsigned int]
!14 = metadata !{metadata !"src/gdt.h", metadata !"/home/gbps/Desktop/Projects/os_notshared/pandos"}
!15 = metadata !{i32 786468, null, null, metadata !"unsigned int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [unsigned int] [line 0, size 32, align 32, offset 0, enc DW_ATE_unsigned]
!16 = metadata !{i32 786454, metadata !14, null, metadata !"uint8_t", i32 238, i64 0, i64 0, i64 0, i32 0, metadata !17} ; [ DW_TAG_typedef ] [uint8_t] [line 238, size 0, align 0, offset 0] [from unsigned char]
!17 = metadata !{i32 786468, null, null, metadata !"unsigned char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 8} ; [ DW_TAG_base_type ] [unsigned char] [line 0, size 8, align 8, offset 0, enc DW_ATE_unsigned_char]
!18 = metadata !{metadata !19, metadata !34}
!19 = metadata !{i32 786484, i32 0, null, metadata !"gdt_entries", metadata !"gdt_entries", metadata !"", metadata !5, i32 10, metadata !20, i32 0, i32 1, [5 x %struct.gdt_entry_struct]* @gdt_entries, null} ; [ DW_TAG_variable ] [gdt_entries] [line 10] [def]
!20 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 320, i64 8, i32 0, i32 0, metadata !21, metadata !32, i32 0, null, null, null} ; [ DW_TAG_array_type ] [line 0, size 320, align 8, offset 0] [from gdt_entry_t]
!21 = metadata !{i32 786454, metadata !1, null, metadata !"gdt_entry_t", i32 15, i64 0, i64 0, i64 0, i32 0, metadata !22} ; [ DW_TAG_typedef ] [gdt_entry_t] [line 15, size 0, align 0, offset 0] [from gdt_entry_struct]
!22 = metadata !{i32 786451, metadata !14, null, metadata !"gdt_entry_struct", i32 6, i64 64, i64 8, i32 0, i32 0, null, metadata !23, i32 0, null, null, null} ; [ DW_TAG_structure_type ] [gdt_entry_struct] [line 6, size 64, align 8, offset 0] [def] [from ]
!23 = metadata !{metadata !24, metadata !27, metadata !28, metadata !29, metadata !30, metadata !31}
!24 = metadata !{i32 786445, metadata !14, metadata !22, metadata !"limit_low", i32 8, i64 16, i64 16, i64 0, i32 0, metadata !25} ; [ DW_TAG_member ] [limit_low] [line 8, size 16, align 16, offset 0] [from uint16_t]
!25 = metadata !{i32 786454, metadata !14, null, metadata !"uint16_t", i32 219, i64 0, i64 0, i64 0, i32 0, metadata !26} ; [ DW_TAG_typedef ] [uint16_t] [line 219, size 0, align 0, offset 0] [from unsigned short]
!26 = metadata !{i32 786468, null, null, metadata !"unsigned short", i32 0, i64 16, i64 16, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [unsigned short] [line 0, size 16, align 16, offset 0, enc DW_ATE_unsigned]
!27 = metadata !{i32 786445, metadata !14, metadata !22, metadata !"base_low", i32 9, i64 16, i64 16, i64 16, i32 0, metadata !25} ; [ DW_TAG_member ] [base_low] [line 9, size 16, align 16, offset 16] [from uint16_t]
!28 = metadata !{i32 786445, metadata !14, metadata !22, metadata !"base_middle", i32 10, i64 8, i64 8, i64 32, i32 0, metadata !16} ; [ DW_TAG_member ] [base_middle] [line 10, size 8, align 8, offset 32] [from uint8_t]
!29 = metadata !{i32 786445, metadata !14, metadata !22, metadata !"access", i32 11, i64 8, i64 8, i64 40, i32 0, metadata !16} ; [ DW_TAG_member ] [access] [line 11, size 8, align 8, offset 40] [from uint8_t]
!30 = metadata !{i32 786445, metadata !14, metadata !22, metadata !"granularity", i32 12, i64 8, i64 8, i64 48, i32 0, metadata !16} ; [ DW_TAG_member ] [granularity] [line 12, size 8, align 8, offset 48] [from uint8_t]
!31 = metadata !{i32 786445, metadata !14, metadata !22, metadata !"base_high", i32 13, i64 8, i64 8, i64 56, i32 0, metadata !16} ; [ DW_TAG_member ] [base_high] [line 13, size 8, align 8, offset 56] [from uint8_t]
!32 = metadata !{metadata !33}
!33 = metadata !{i32 786465, i64 0, i64 5}        ; [ DW_TAG_subrange_type ] [0, 4]
!34 = metadata !{i32 786484, i32 0, null, metadata !"gdt_ptr", metadata !"gdt_ptr", metadata !"", metadata !5, i32 11, metadata !35, i32 0, i32 1, %struct.gdt_ptr_struct* @gdt_ptr, null} ; [ DW_TAG_variable ] [gdt_ptr] [line 11] [def]
!35 = metadata !{i32 786454, metadata !1, null, metadata !"gdt_ptr_t", i32 22, i64 0, i64 0, i64 0, i32 0, metadata !36} ; [ DW_TAG_typedef ] [gdt_ptr_t] [line 22, size 0, align 0, offset 0] [from gdt_ptr_struct]
!36 = metadata !{i32 786451, metadata !14, null, metadata !"gdt_ptr_struct", i32 17, i64 48, i64 8, i32 0, i32 0, null, metadata !37, i32 0, null, null, null} ; [ DW_TAG_structure_type ] [gdt_ptr_struct] [line 17, size 48, align 8, offset 0] [def] [from ]
!37 = metadata !{metadata !38, metadata !39}
!38 = metadata !{i32 786445, metadata !14, metadata !36, metadata !"limit", i32 19, i64 16, i64 16, i64 0, i32 0, metadata !25} ; [ DW_TAG_member ] [limit] [line 19, size 16, align 16, offset 0] [from uint16_t]
!39 = metadata !{i32 786445, metadata !14, metadata !36, metadata !"base", i32 20, i64 32, i64 32, i64 16, i32 0, metadata !13} ; [ DW_TAG_member ] [base] [line 20, size 32, align 32, offset 16] [from uint32_t]
!40 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!41 = metadata !{metadata !"clang version 3.4 (http://llvm.org/git/clang.git 82a2911a94947e20ac4fd961b6322adf74ad9224) (http://llvm.org/git/llvm.git 52244da7f2b3def646900520668b859343b84a33)"}
!42 = metadata !{i32 16, i32 0, metadata !4, null}
!43 = metadata !{i32 17, i32 0, metadata !4, null}
!44 = metadata !{i32 19, i32 0, metadata !4, null}
!45 = metadata !{i32 20, i32 0, metadata !4, null}
!46 = metadata !{i32 21, i32 0, metadata !4, null}
!47 = metadata !{i32 22, i32 0, metadata !4, null}
!48 = metadata !{i32 23, i32 0, metadata !4, null}
!49 = metadata !{i32 25, i32 0, metadata !4, null}
!50 = metadata !{i32 26, i32 0, metadata !4, null}
!51 = metadata !{i32 786689, metadata !8, metadata !"num", metadata !5, i32 16777245, metadata !11, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [num] [line 29]
!52 = metadata !{i32 29, i32 0, metadata !8, null}
!53 = metadata !{i32 786689, metadata !8, metadata !"base", metadata !5, i32 33554461, metadata !13, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [base] [line 29]
!54 = metadata !{i32 786689, metadata !8, metadata !"limit", metadata !5, i32 50331677, metadata !13, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [limit] [line 29]
!55 = metadata !{i32 786689, metadata !8, metadata !"access", metadata !5, i32 67108893, metadata !16, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [access] [line 29]
!56 = metadata !{i32 786689, metadata !8, metadata !"gran", metadata !5, i32 83886109, metadata !16, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [gran] [line 29]
!57 = metadata !{i32 31, i32 0, metadata !8, null}
!58 = metadata !{i32 32, i32 0, metadata !8, null}
!59 = metadata !{i32 33, i32 0, metadata !8, null}
!60 = metadata !{i32 35, i32 0, metadata !8, null}
!61 = metadata !{i32 36, i32 0, metadata !8, null}
!62 = metadata !{i32 38, i32 0, metadata !8, null}
!63 = metadata !{i32 39, i32 0, metadata !8, null}
!64 = metadata !{i32 40, i32 0, metadata !8, null}
