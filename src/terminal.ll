; ModuleID = 'src/terminal.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i686-pc-none-elf"

@terminal_row = common global i32 0, align 4
@terminal_column = common global i32 0, align 4
@terminal_color = common global i8 0, align 1
@terminal_buffer = common global i16* null, align 4

; Function Attrs: nounwind
define zeroext i8 @make_color(i32 %fg, i32 %bg) #0 {
entry:
  %fg.addr = alloca i32, align 4
  %bg.addr = alloca i32, align 4
  store i32 %fg, i32* %fg.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %fg.addr}, metadata !70), !dbg !71
  store i32 %bg, i32* %bg.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %bg.addr}, metadata !72), !dbg !71
  %0 = load i32* %fg.addr, align 4, !dbg !73
  %1 = load i32* %bg.addr, align 4, !dbg !73
  %shl = shl i32 %1, 4, !dbg !73
  %or = or i32 %0, %shl, !dbg !73
  %conv = trunc i32 %or to i8, !dbg !73
  ret i8 %conv, !dbg !73
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

; Function Attrs: nounwind
define zeroext i16 @make_vgaentry(i8 signext %c, i8 zeroext %color) #0 {
entry:
  %c.addr = alloca i8, align 1
  %color.addr = alloca i8, align 1
  %c16 = alloca i16, align 2
  %color16 = alloca i16, align 2
  store i8 %c, i8* %c.addr, align 1
  call void @llvm.dbg.declare(metadata !{i8* %c.addr}, metadata !74), !dbg !75
  store i8 %color, i8* %color.addr, align 1
  call void @llvm.dbg.declare(metadata !{i8* %color.addr}, metadata !76), !dbg !75
  call void @llvm.dbg.declare(metadata !{i16* %c16}, metadata !77), !dbg !78
  %0 = load i8* %c.addr, align 1, !dbg !78
  %conv = sext i8 %0 to i16, !dbg !78
  store i16 %conv, i16* %c16, align 2, !dbg !78
  call void @llvm.dbg.declare(metadata !{i16* %color16}, metadata !79), !dbg !80
  %1 = load i8* %color.addr, align 1, !dbg !80
  %conv1 = zext i8 %1 to i16, !dbg !80
  store i16 %conv1, i16* %color16, align 2, !dbg !80
  %2 = load i16* %c16, align 2, !dbg !81
  %conv2 = zext i16 %2 to i32, !dbg !81
  %3 = load i16* %color16, align 2, !dbg !81
  %conv3 = zext i16 %3 to i32, !dbg !81
  %shl = shl i32 %conv3, 8, !dbg !81
  %or = or i32 %conv2, %shl, !dbg !81
  %conv4 = trunc i32 %or to i16, !dbg !81
  ret i16 %conv4, !dbg !81
}

; Function Attrs: nounwind
define void @terminal_initialize() #0 {
entry:
  %y = alloca i32, align 4
  %x = alloca i32, align 4
  %index = alloca i32, align 4
  store i32 0, i32* @terminal_row, align 4, !dbg !82
  store i32 0, i32* @terminal_column, align 4, !dbg !83
  %call = call zeroext i8 @make_color(i32 7, i32 0) #3, !dbg !84
  store i8 %call, i8* @terminal_color, align 1, !dbg !84
  store i16* inttoptr (i32 -1072988160 to i16*), i16** @terminal_buffer, align 4, !dbg !85
  call void @llvm.dbg.declare(metadata !{i32* %y}, metadata !86), !dbg !88
  store i32 0, i32* %y, align 4, !dbg !88
  br label %for.cond, !dbg !88

for.cond:                                         ; preds = %for.inc5, %entry
  %0 = load i32* %y, align 4, !dbg !88
  %cmp = icmp ult i32 %0, 25, !dbg !88
  br i1 %cmp, label %for.body, label %for.end7, !dbg !88

for.body:                                         ; preds = %for.cond
  call void @llvm.dbg.declare(metadata !{i32* %x}, metadata !89), !dbg !92
  store i32 0, i32* %x, align 4, !dbg !92
  br label %for.cond1, !dbg !92

for.cond1:                                        ; preds = %for.inc, %for.body
  %1 = load i32* %x, align 4, !dbg !92
  %cmp2 = icmp ult i32 %1, 80, !dbg !92
  br i1 %cmp2, label %for.body3, label %for.end, !dbg !92

for.body3:                                        ; preds = %for.cond1
  call void @llvm.dbg.declare(metadata !{i32* %index}, metadata !93), !dbg !95
  %2 = load i32* %y, align 4, !dbg !95
  %mul = mul i32 %2, 80, !dbg !95
  %3 = load i32* %x, align 4, !dbg !95
  %add = add i32 %mul, %3, !dbg !95
  store i32 %add, i32* %index, align 4, !dbg !95
  %4 = load i8* @terminal_color, align 1, !dbg !96
  %call4 = call zeroext i16 @make_vgaentry(i8 signext 32, i8 zeroext %4) #3, !dbg !96
  %5 = load i32* %index, align 4, !dbg !96
  %6 = load i16** @terminal_buffer, align 4, !dbg !96
  %arrayidx = getelementptr inbounds i16* %6, i32 %5, !dbg !96
  store i16 %call4, i16* %arrayidx, align 2, !dbg !96
  br label %for.inc, !dbg !97

for.inc:                                          ; preds = %for.body3
  %7 = load i32* %x, align 4, !dbg !92
  %inc = add i32 %7, 1, !dbg !92
  store i32 %inc, i32* %x, align 4, !dbg !92
  br label %for.cond1, !dbg !92

for.end:                                          ; preds = %for.cond1
  br label %for.inc5, !dbg !98

for.inc5:                                         ; preds = %for.end
  %8 = load i32* %y, align 4, !dbg !88
  %inc6 = add i32 %8, 1, !dbg !88
  store i32 %inc6, i32* %y, align 4, !dbg !88
  br label %for.cond, !dbg !88

for.end7:                                         ; preds = %for.cond
  ret void, !dbg !99
}

; Function Attrs: nounwind
define void @terminal_setcolor(i8 zeroext %color) #0 {
entry:
  %color.addr = alloca i8, align 1
  store i8 %color, i8* %color.addr, align 1
  call void @llvm.dbg.declare(metadata !{i8* %color.addr}, metadata !100), !dbg !101
  %0 = load i8* %color.addr, align 1, !dbg !102
  store i8 %0, i8* @terminal_color, align 1, !dbg !102
  ret void, !dbg !103
}

; Function Attrs: nounwind
define void @terminal_putentryat(i8 signext %c, i8 zeroext %color, i32 %x, i32 %y) #0 {
entry:
  %c.addr = alloca i8, align 1
  %color.addr = alloca i8, align 1
  %x.addr = alloca i32, align 4
  %y.addr = alloca i32, align 4
  %index = alloca i32, align 4
  store i8 %c, i8* %c.addr, align 1
  call void @llvm.dbg.declare(metadata !{i8* %c.addr}, metadata !104), !dbg !105
  store i8 %color, i8* %color.addr, align 1
  call void @llvm.dbg.declare(metadata !{i8* %color.addr}, metadata !106), !dbg !105
  store i32 %x, i32* %x.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %x.addr}, metadata !107), !dbg !105
  store i32 %y, i32* %y.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %y.addr}, metadata !108), !dbg !105
  call void @llvm.dbg.declare(metadata !{i32* %index}, metadata !109), !dbg !110
  %0 = load i32* %y.addr, align 4, !dbg !110
  %mul = mul i32 %0, 80, !dbg !110
  %1 = load i32* %x.addr, align 4, !dbg !110
  %add = add i32 %mul, %1, !dbg !110
  store i32 %add, i32* %index, align 4, !dbg !110
  %2 = load i8* %c.addr, align 1, !dbg !111
  %3 = load i8* %color.addr, align 1, !dbg !111
  %call = call zeroext i16 @make_vgaentry(i8 signext %2, i8 zeroext %3) #3, !dbg !111
  %4 = load i32* %index, align 4, !dbg !111
  %5 = load i16** @terminal_buffer, align 4, !dbg !111
  %arrayidx = getelementptr inbounds i16* %5, i32 %4, !dbg !111
  store i16 %call, i16* %arrayidx, align 2, !dbg !111
  ret void, !dbg !112
}

; Function Attrs: nounwind
define zeroext i1 @terminal_handlewhitespace(i8 signext %c) #0 {
entry:
  %retval = alloca i1, align 1
  %c.addr = alloca i8, align 1
  store i8 %c, i8* %c.addr, align 1
  call void @llvm.dbg.declare(metadata !{i8* %c.addr}, metadata !113), !dbg !114
  %0 = load i8* %c.addr, align 1, !dbg !115
  %conv = sext i8 %0 to i32, !dbg !115
  switch i32 %conv, label %sw.default [
    i32 10, label %sw.bb
    i32 13, label %sw.bb1
    i32 9, label %sw.bb2
  ], !dbg !115

sw.bb:                                            ; preds = %entry
  %1 = load i32* @terminal_row, align 4, !dbg !116
  %add = add i32 %1, 1, !dbg !116
  store i32 %add, i32* @terminal_row, align 4, !dbg !116
  store i32 0, i32* @terminal_column, align 4, !dbg !118
  br label %sw.epilog, !dbg !119

sw.bb1:                                           ; preds = %entry
  store i32 0, i32* @terminal_column, align 4, !dbg !120
  br label %sw.epilog, !dbg !121

sw.bb2:                                           ; preds = %entry
  %2 = load i32* @terminal_column, align 4, !dbg !122
  %add3 = add i32 %2, 5, !dbg !122
  store i32 %add3, i32* @terminal_column, align 4, !dbg !122
  br label %sw.epilog, !dbg !123

sw.default:                                       ; preds = %entry
  store i1 false, i1* %retval, !dbg !124
  br label %return, !dbg !124

sw.epilog:                                        ; preds = %sw.bb2, %sw.bb1, %sw.bb
  store i1 true, i1* %retval, !dbg !125
  br label %return, !dbg !125

return:                                           ; preds = %sw.epilog, %sw.default
  %3 = load i1* %retval, !dbg !126
  ret i1 %3, !dbg !126
}

; Function Attrs: nounwind
define void @terminal_putchar(i8 signext %c) #0 {
entry:
  %c.addr = alloca i8, align 1
  store i8 %c, i8* %c.addr, align 1
  call void @llvm.dbg.declare(metadata !{i8* %c.addr}, metadata !127), !dbg !128
  %0 = load i8* %c.addr, align 1, !dbg !129
  %call = call zeroext i1 @terminal_handlewhitespace(i8 signext %0) #3, !dbg !129
  br i1 %call, label %if.then, label %if.end, !dbg !129

if.then:                                          ; preds = %entry
  br label %if.end6, !dbg !131

if.end:                                           ; preds = %entry
  %1 = load i8* %c.addr, align 1, !dbg !133
  %2 = load i8* @terminal_color, align 1, !dbg !133
  %3 = load i32* @terminal_column, align 4, !dbg !133
  %4 = load i32* @terminal_row, align 4, !dbg !133
  call void @terminal_putentryat(i8 signext %1, i8 zeroext %2, i32 %3, i32 %4) #3, !dbg !133
  %5 = load i32* @terminal_column, align 4, !dbg !134
  %inc = add i32 %5, 1, !dbg !134
  store i32 %inc, i32* @terminal_column, align 4, !dbg !134
  %cmp = icmp eq i32 %inc, 80, !dbg !134
  br i1 %cmp, label %if.then1, label %if.end6, !dbg !134

if.then1:                                         ; preds = %if.end
  store i32 0, i32* @terminal_column, align 4, !dbg !136
  %6 = load i32* @terminal_row, align 4, !dbg !138
  %inc2 = add i32 %6, 1, !dbg !138
  store i32 %inc2, i32* @terminal_row, align 4, !dbg !138
  %cmp3 = icmp eq i32 %inc2, 25, !dbg !138
  br i1 %cmp3, label %if.then4, label %if.end5, !dbg !138

if.then4:                                         ; preds = %if.then1
  store i32 0, i32* @terminal_row, align 4, !dbg !140
  br label %if.end5, !dbg !142

if.end5:                                          ; preds = %if.then4, %if.then1
  br label %if.end6, !dbg !143

if.end6:                                          ; preds = %if.then, %if.end5, %if.end
  ret void, !dbg !144
}

; Function Attrs: nounwind
define void @terminal_writestring(i8* %data) #0 {
entry:
  %data.addr = alloca i8*, align 4
  %datalen = alloca i32, align 4
  %i = alloca i32, align 4
  store i8* %data, i8** %data.addr, align 4
  call void @llvm.dbg.declare(metadata !{i8** %data.addr}, metadata !145), !dbg !146
  call void @llvm.dbg.declare(metadata !{i32* %datalen}, metadata !147), !dbg !148
  %0 = load i8** %data.addr, align 4, !dbg !148
  %call = call i32 @strlen(i8* %0) #3, !dbg !148
  store i32 %call, i32* %datalen, align 4, !dbg !148
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !149), !dbg !151
  store i32 0, i32* %i, align 4, !dbg !151
  br label %for.cond, !dbg !151

for.cond:                                         ; preds = %for.inc, %entry
  %1 = load i32* %i, align 4, !dbg !151
  %2 = load i32* %datalen, align 4, !dbg !151
  %cmp = icmp ult i32 %1, %2, !dbg !151
  br i1 %cmp, label %for.body, label %for.end, !dbg !151

for.body:                                         ; preds = %for.cond
  %3 = load i32* %i, align 4, !dbg !152
  %4 = load i8** %data.addr, align 4, !dbg !152
  %arrayidx = getelementptr inbounds i8* %4, i32 %3, !dbg !152
  %5 = load i8* %arrayidx, align 1, !dbg !152
  call void @terminal_putchar(i8 signext %5) #3, !dbg !152
  br label %for.inc, !dbg !152

for.inc:                                          ; preds = %for.body
  %6 = load i32* %i, align 4, !dbg !151
  %inc = add i32 %6, 1, !dbg !151
  store i32 %inc, i32* %i, align 4, !dbg !151
  br label %for.cond, !dbg !151

for.end:                                          ; preds = %for.cond
  ret void, !dbg !153
}

declare i32 @strlen(i8*) #2

attributes #0 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nobuiltin }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!68}
!llvm.ident = !{!69}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"clang version 3.4 (http://llvm.org/git/clang.git 82a2911a94947e20ac4fd961b6322adf74ad9224) (http://llvm.org/git/llvm.git 52244da7f2b3def646900520668b859343b84a33)", i1 false, metadata !"", i32 0, metadata !2, metadata !22, metadata !23, metadata !59, metadata !22, metadata !""} ; [ DW_TAG_compile_unit ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/terminal.c] [DW_LANG_C99]
!1 = metadata !{metadata !"src/terminal.c", metadata !"/home/gbps/Desktop/Projects/os_notshared/pandos"}
!2 = metadata !{metadata !3}
!3 = metadata !{i32 786436, metadata !4, null, metadata !"vga_color", i32 1, i64 32, i64 32, i32 0, i32 0, null, metadata !5, i32 0, null, null, null} ; [ DW_TAG_enumeration_type ] [vga_color] [line 1, size 32, align 32, offset 0] [def] [from ]
!4 = metadata !{metadata !"src/terminal.h", metadata !"/home/gbps/Desktop/Projects/os_notshared/pandos"}
!5 = metadata !{metadata !6, metadata !7, metadata !8, metadata !9, metadata !10, metadata !11, metadata !12, metadata !13, metadata !14, metadata !15, metadata !16, metadata !17, metadata !18, metadata !19, metadata !20, metadata !21}
!6 = metadata !{i32 786472, metadata !"COLOR_BLACK", i64 0} ; [ DW_TAG_enumerator ] [COLOR_BLACK :: 0]
!7 = metadata !{i32 786472, metadata !"COLOR_BLUE", i64 1} ; [ DW_TAG_enumerator ] [COLOR_BLUE :: 1]
!8 = metadata !{i32 786472, metadata !"COLOR_GREEN", i64 2} ; [ DW_TAG_enumerator ] [COLOR_GREEN :: 2]
!9 = metadata !{i32 786472, metadata !"COLOR_CYAN", i64 3} ; [ DW_TAG_enumerator ] [COLOR_CYAN :: 3]
!10 = metadata !{i32 786472, metadata !"COLOR_RED", i64 4} ; [ DW_TAG_enumerator ] [COLOR_RED :: 4]
!11 = metadata !{i32 786472, metadata !"COLOR_MAGENTA", i64 5} ; [ DW_TAG_enumerator ] [COLOR_MAGENTA :: 5]
!12 = metadata !{i32 786472, metadata !"COLOR_BROWN", i64 6} ; [ DW_TAG_enumerator ] [COLOR_BROWN :: 6]
!13 = metadata !{i32 786472, metadata !"COLOR_LIGHT_GREY", i64 7} ; [ DW_TAG_enumerator ] [COLOR_LIGHT_GREY :: 7]
!14 = metadata !{i32 786472, metadata !"COLOR_DARK_GREY", i64 8} ; [ DW_TAG_enumerator ] [COLOR_DARK_GREY :: 8]
!15 = metadata !{i32 786472, metadata !"COLOR_LIGHT_BLUE", i64 9} ; [ DW_TAG_enumerator ] [COLOR_LIGHT_BLUE :: 9]
!16 = metadata !{i32 786472, metadata !"COLOR_LIGHT_GREEN", i64 10} ; [ DW_TAG_enumerator ] [COLOR_LIGHT_GREEN :: 10]
!17 = metadata !{i32 786472, metadata !"COLOR_LIGHT_CYAN", i64 11} ; [ DW_TAG_enumerator ] [COLOR_LIGHT_CYAN :: 11]
!18 = metadata !{i32 786472, metadata !"COLOR_LIGHT_RED", i64 12} ; [ DW_TAG_enumerator ] [COLOR_LIGHT_RED :: 12]
!19 = metadata !{i32 786472, metadata !"COLOR_LIGHT_MAGENTA", i64 13} ; [ DW_TAG_enumerator ] [COLOR_LIGHT_MAGENTA :: 13]
!20 = metadata !{i32 786472, metadata !"COLOR_LIGHT_BROWN", i64 14} ; [ DW_TAG_enumerator ] [COLOR_LIGHT_BROWN :: 14]
!21 = metadata !{i32 786472, metadata !"COLOR_WHITE", i64 15} ; [ DW_TAG_enumerator ] [COLOR_WHITE :: 15]
!22 = metadata !{i32 0}
!23 = metadata !{metadata !24, metadata !30, metadata !36, metadata !39, metadata !42, metadata !47, metadata !51, metadata !54}
!24 = metadata !{i32 786478, metadata !1, metadata !25, metadata !"make_color", metadata !"make_color", metadata !"", i32 10, metadata !26, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i8 (i32, i32)* @make_color, null, null, metadata !22, i32 10} ; [ DW_TAG_subprogram ] [line 10] [def] [make_color]
!25 = metadata !{i32 786473, metadata !1}         ; [ DW_TAG_file_type ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/terminal.c]
!26 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !27, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!27 = metadata !{metadata !28, metadata !3, metadata !3}
!28 = metadata !{i32 786454, metadata !1, null, metadata !"uint8_t", i32 238, i64 0, i64 0, i64 0, i32 0, metadata !29} ; [ DW_TAG_typedef ] [uint8_t] [line 238, size 0, align 0, offset 0] [from unsigned char]
!29 = metadata !{i32 786468, null, null, metadata !"unsigned char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 8} ; [ DW_TAG_base_type ] [unsigned char] [line 0, size 8, align 8, offset 0, enc DW_ATE_unsigned_char]
!30 = metadata !{i32 786478, metadata !1, metadata !25, metadata !"make_vgaentry", metadata !"make_vgaentry", metadata !"", i32 14, metadata !31, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i16 (i8, i8)* @make_vgaentry, null, null, metadata !22, i32 14} ; [ DW_TAG_subprogram ] [line 14] [def] [make_vgaentry]
!31 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !32, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!32 = metadata !{metadata !33, metadata !35, metadata !28}
!33 = metadata !{i32 786454, metadata !1, null, metadata !"uint16_t", i32 219, i64 0, i64 0, i64 0, i32 0, metadata !34} ; [ DW_TAG_typedef ] [uint16_t] [line 219, size 0, align 0, offset 0] [from unsigned short]
!34 = metadata !{i32 786468, null, null, metadata !"unsigned short", i32 0, i64 16, i64 16, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [unsigned short] [line 0, size 16, align 16, offset 0, enc DW_ATE_unsigned]
!35 = metadata !{i32 786468, null, null, metadata !"char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!36 = metadata !{i32 786478, metadata !1, metadata !25, metadata !"terminal_initialize", metadata !"terminal_initialize", metadata !"", i32 28, metadata !37, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, void ()* @terminal_initialize, null, null, metadata !22, i32 28} ; [ DW_TAG_subprogram ] [line 28] [def] [terminal_initialize]
!37 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !38, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!38 = metadata !{null}
!39 = metadata !{i32 786478, metadata !1, metadata !25, metadata !"terminal_setcolor", metadata !"terminal_setcolor", metadata !"", i32 41, metadata !40, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i8)* @terminal_setcolor, null, null, metadata !22, i32 41} ; [ DW_TAG_subprogram ] [line 41] [def] [terminal_setcolor]
!40 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !41, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!41 = metadata !{null, metadata !28}
!42 = metadata !{i32 786478, metadata !1, metadata !25, metadata !"terminal_putentryat", metadata !"terminal_putentryat", metadata !"", i32 45, metadata !43, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i8, i8, i32, i32)* @terminal_putentryat, null, null, metadata !22, i32 45} ; [ DW_TAG_subprogram ] [line 45] [def] [terminal_putentryat]
!43 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !44, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!44 = metadata !{null, metadata !35, metadata !28, metadata !45, metadata !45}
!45 = metadata !{i32 786454, metadata !1, null, metadata !"size_t", i32 42, i64 0, i64 0, i64 0, i32 0, metadata !46} ; [ DW_TAG_typedef ] [size_t] [line 42, size 0, align 0, offset 0] [from unsigned int]
!46 = metadata !{i32 786468, null, null, metadata !"unsigned int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [unsigned int] [line 0, size 32, align 32, offset 0, enc DW_ATE_unsigned]
!47 = metadata !{i32 786478, metadata !1, metadata !25, metadata !"terminal_handlewhitespace", metadata !"terminal_handlewhitespace", metadata !"", i32 50, metadata !48, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i1 (i8)* @terminal_handlewhitespace, null, null, metadata !22, i32 51} ; [ DW_TAG_subprogram ] [line 50] [def] [scope 51] [terminal_handlewhitespace]
!48 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !49, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!49 = metadata !{metadata !50, metadata !35}
!50 = metadata !{i32 786468, null, null, metadata !"_Bool", i32 0, i64 8, i64 8, i64 0, i32 0, i32 2} ; [ DW_TAG_base_type ] [_Bool] [line 0, size 8, align 8, offset 0, enc DW_ATE_boolean]
!51 = metadata !{i32 786478, metadata !1, metadata !25, metadata !"terminal_putchar", metadata !"terminal_putchar", metadata !"", i32 72, metadata !52, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i8)* @terminal_putchar, null, null, metadata !22, i32 73} ; [ DW_TAG_subprogram ] [line 72] [def] [scope 73] [terminal_putchar]
!52 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !53, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!53 = metadata !{null, metadata !35}
!54 = metadata !{i32 786478, metadata !1, metadata !25, metadata !"terminal_writestring", metadata !"terminal_writestring", metadata !"", i32 87, metadata !55, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i8*)* @terminal_writestring, null, null, metadata !22, i32 87} ; [ DW_TAG_subprogram ] [line 87] [def] [terminal_writestring]
!55 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !56, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!56 = metadata !{null, metadata !57}
!57 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, metadata !58} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from ]
!58 = metadata !{i32 786470, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !35} ; [ DW_TAG_const_type ] [line 0, size 0, align 0, offset 0] [from char]
!59 = metadata !{metadata !60, metadata !62, metadata !62, metadata !62, metadata !62, metadata !60, metadata !63, metadata !64, metadata !65, metadata !66}
!60 = metadata !{i32 786484, i32 0, metadata !25, metadata !"VGA_HEIGHT", metadata !"VGA_HEIGHT", metadata !"VGA_HEIGHT", metadata !25, i32 21, metadata !61, i32 1, i32 1, i32 25, null} ; [ DW_TAG_variable ] [VGA_HEIGHT] [line 21] [local] [def]
!61 = metadata !{i32 786470, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !45} ; [ DW_TAG_const_type ] [line 0, size 0, align 0, offset 0] [from size_t]
!62 = metadata !{i32 786484, i32 0, metadata !25, metadata !"VGA_WIDTH", metadata !"VGA_WIDTH", metadata !"VGA_WIDTH", metadata !25, i32 20, metadata !61, i32 1, i32 1, i32 80, null} ; [ DW_TAG_variable ] [VGA_WIDTH] [line 20] [local] [def]
!63 = metadata !{i32 786484, i32 0, null, metadata !"terminal_row", metadata !"terminal_row", metadata !"", metadata !25, i32 23, metadata !45, i32 0, i32 1, i32* @terminal_row, null} ; [ DW_TAG_variable ] [terminal_row] [line 23] [def]
!64 = metadata !{i32 786484, i32 0, null, metadata !"terminal_column", metadata !"terminal_column", metadata !"", metadata !25, i32 24, metadata !45, i32 0, i32 1, i32* @terminal_column, null} ; [ DW_TAG_variable ] [terminal_column] [line 24] [def]
!65 = metadata !{i32 786484, i32 0, null, metadata !"terminal_color", metadata !"terminal_color", metadata !"", metadata !25, i32 25, metadata !28, i32 0, i32 1, i8* @terminal_color, null} ; [ DW_TAG_variable ] [terminal_color] [line 25] [def]
!66 = metadata !{i32 786484, i32 0, null, metadata !"terminal_buffer", metadata !"terminal_buffer", metadata !"", metadata !25, i32 26, metadata !67, i32 0, i32 1, i16** @terminal_buffer, null} ; [ DW_TAG_variable ] [terminal_buffer] [line 26] [def]
!67 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, metadata !33} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from uint16_t]
!68 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!69 = metadata !{metadata !"clang version 3.4 (http://llvm.org/git/clang.git 82a2911a94947e20ac4fd961b6322adf74ad9224) (http://llvm.org/git/llvm.git 52244da7f2b3def646900520668b859343b84a33)"}
!70 = metadata !{i32 786689, metadata !24, metadata !"fg", metadata !25, i32 16777226, metadata !3, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [fg] [line 10]
!71 = metadata !{i32 10, i32 0, metadata !24, null}
!72 = metadata !{i32 786689, metadata !24, metadata !"bg", metadata !25, i32 33554442, metadata !3, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [bg] [line 10]
!73 = metadata !{i32 11, i32 0, metadata !24, null}
!74 = metadata !{i32 786689, metadata !30, metadata !"c", metadata !25, i32 16777230, metadata !35, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [c] [line 14]
!75 = metadata !{i32 14, i32 0, metadata !30, null}
!76 = metadata !{i32 786689, metadata !30, metadata !"color", metadata !25, i32 33554446, metadata !28, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [color] [line 14]
!77 = metadata !{i32 786688, metadata !30, metadata !"c16", metadata !25, i32 15, metadata !33, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [c16] [line 15]
!78 = metadata !{i32 15, i32 0, metadata !30, null}
!79 = metadata !{i32 786688, metadata !30, metadata !"color16", metadata !25, i32 16, metadata !33, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [color16] [line 16]
!80 = metadata !{i32 16, i32 0, metadata !30, null}
!81 = metadata !{i32 17, i32 0, metadata !30, null}
!82 = metadata !{i32 29, i32 0, metadata !36, null}
!83 = metadata !{i32 30, i32 0, metadata !36, null}
!84 = metadata !{i32 31, i32 0, metadata !36, null}
!85 = metadata !{i32 32, i32 0, metadata !36, null}
!86 = metadata !{i32 786688, metadata !87, metadata !"y", metadata !25, i32 33, metadata !45, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [y] [line 33]
!87 = metadata !{i32 786443, metadata !1, metadata !36, i32 33, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/terminal.c]
!88 = metadata !{i32 33, i32 0, metadata !87, null}
!89 = metadata !{i32 786688, metadata !90, metadata !"x", metadata !25, i32 34, metadata !45, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [x] [line 34]
!90 = metadata !{i32 786443, metadata !1, metadata !91, i32 34, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/terminal.c]
!91 = metadata !{i32 786443, metadata !1, metadata !87, i32 33, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/terminal.c]
!92 = metadata !{i32 34, i32 0, metadata !90, null}
!93 = metadata !{i32 786688, metadata !94, metadata !"index", metadata !25, i32 35, metadata !61, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [index] [line 35]
!94 = metadata !{i32 786443, metadata !1, metadata !90, i32 34, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/terminal.c]
!95 = metadata !{i32 35, i32 0, metadata !94, null}
!96 = metadata !{i32 36, i32 0, metadata !94, null}
!97 = metadata !{i32 37, i32 0, metadata !94, null}
!98 = metadata !{i32 38, i32 0, metadata !91, null}
!99 = metadata !{i32 39, i32 0, metadata !36, null}
!100 = metadata !{i32 786689, metadata !39, metadata !"color", metadata !25, i32 16777257, metadata !28, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [color] [line 41]
!101 = metadata !{i32 41, i32 0, metadata !39, null}
!102 = metadata !{i32 42, i32 0, metadata !39, null}
!103 = metadata !{i32 43, i32 0, metadata !39, null}
!104 = metadata !{i32 786689, metadata !42, metadata !"c", metadata !25, i32 16777261, metadata !35, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [c] [line 45]
!105 = metadata !{i32 45, i32 0, metadata !42, null}
!106 = metadata !{i32 786689, metadata !42, metadata !"color", metadata !25, i32 33554477, metadata !28, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [color] [line 45]
!107 = metadata !{i32 786689, metadata !42, metadata !"x", metadata !25, i32 50331693, metadata !45, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [x] [line 45]
!108 = metadata !{i32 786689, metadata !42, metadata !"y", metadata !25, i32 67108909, metadata !45, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [y] [line 45]
!109 = metadata !{i32 786688, metadata !42, metadata !"index", metadata !25, i32 46, metadata !61, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [index] [line 46]
!110 = metadata !{i32 46, i32 0, metadata !42, null}
!111 = metadata !{i32 47, i32 0, metadata !42, null}
!112 = metadata !{i32 48, i32 0, metadata !42, null}
!113 = metadata !{i32 786689, metadata !47, metadata !"c", metadata !25, i32 16777266, metadata !35, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [c] [line 50]
!114 = metadata !{i32 50, i32 0, metadata !47, null}
!115 = metadata !{i32 52, i32 0, metadata !47, null}
!116 = metadata !{i32 55, i32 0, metadata !117, null}
!117 = metadata !{i32 786443, metadata !1, metadata !47, i32 53, i32 0, i32 4} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/terminal.c]
!118 = metadata !{i32 56, i32 0, metadata !117, null}
!119 = metadata !{i32 57, i32 0, metadata !117, null}
!120 = metadata !{i32 59, i32 0, metadata !117, null}
!121 = metadata !{i32 60, i32 0, metadata !117, null}
!122 = metadata !{i32 62, i32 0, metadata !117, null}
!123 = metadata !{i32 63, i32 0, metadata !117, null}
!124 = metadata !{i32 65, i32 0, metadata !117, null}
!125 = metadata !{i32 69, i32 0, metadata !47, null}
!126 = metadata !{i32 71, i32 0, metadata !47, null}
!127 = metadata !{i32 786689, metadata !51, metadata !"c", metadata !25, i32 16777288, metadata !35, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [c] [line 72]
!128 = metadata !{i32 72, i32 0, metadata !51, null}
!129 = metadata !{i32 74, i32 0, metadata !130, null}
!130 = metadata !{i32 786443, metadata !1, metadata !51, i32 74, i32 0, i32 5} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/terminal.c]
!131 = metadata !{i32 76, i32 0, metadata !132, null}
!132 = metadata !{i32 786443, metadata !1, metadata !130, i32 75, i32 0, i32 6} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/terminal.c]
!133 = metadata !{i32 78, i32 0, metadata !51, null}
!134 = metadata !{i32 79, i32 0, metadata !135, null}
!135 = metadata !{i32 786443, metadata !1, metadata !51, i32 79, i32 0, i32 7} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/terminal.c]
!136 = metadata !{i32 80, i32 0, metadata !137, null}
!137 = metadata !{i32 786443, metadata !1, metadata !135, i32 79, i32 0, i32 8} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/terminal.c]
!138 = metadata !{i32 81, i32 0, metadata !139, null}
!139 = metadata !{i32 786443, metadata !1, metadata !137, i32 81, i32 0, i32 9} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/terminal.c]
!140 = metadata !{i32 82, i32 0, metadata !141, null}
!141 = metadata !{i32 786443, metadata !1, metadata !139, i32 81, i32 0, i32 10} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/terminal.c]
!142 = metadata !{i32 83, i32 0, metadata !141, null}
!143 = metadata !{i32 84, i32 0, metadata !137, null}
!144 = metadata !{i32 85, i32 0, metadata !51, null}
!145 = metadata !{i32 786689, metadata !54, metadata !"data", metadata !25, i32 16777303, metadata !57, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [data] [line 87]
!146 = metadata !{i32 87, i32 0, metadata !54, null}
!147 = metadata !{i32 786688, metadata !54, metadata !"datalen", metadata !25, i32 88, metadata !45, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [datalen] [line 88]
!148 = metadata !{i32 88, i32 0, metadata !54, null}
!149 = metadata !{i32 786688, metadata !150, metadata !"i", metadata !25, i32 89, metadata !45, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 89]
!150 = metadata !{i32 786443, metadata !1, metadata !54, i32 89, i32 0, i32 11} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/terminal.c]
!151 = metadata !{i32 89, i32 0, metadata !150, null}
!152 = metadata !{i32 90, i32 0, metadata !150, null}
!153 = metadata !{i32 91, i32 0, metadata !54, null}
