; ModuleID = 'src/kernel.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i686-pc-none-elf"

@terminal_row = common global i32 0, align 4
@terminal_column = common global i32 0, align 4
@terminal_color = common global i8 0, align 1
@terminal_buffer = common global i16* null, align 4
@.str = private unnamed_addr constant [22 x i8] c"Hello, kernel World!\0A\00", align 1

; Function Attrs: nounwind readnone
define zeroext i8 @make_color(i32 %fg, i32 %bg) #0 {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fg}, i64 0, metadata !30), !dbg !109
  tail call void @llvm.dbg.value(metadata !{i32 %bg}, i64 0, metadata !31), !dbg !109
  %shl = shl i32 %bg, 4, !dbg !110
  %or = or i32 %shl, %fg, !dbg !110
  %conv = trunc i32 %or to i8, !dbg !110
  ret i8 %conv, !dbg !110
}

; Function Attrs: nounwind readnone
define zeroext i16 @make_vgaentry(i8 signext %c, i8 zeroext %color) #0 {
entry:
  tail call void @llvm.dbg.value(metadata !{i8 %c}, i64 0, metadata !39), !dbg !111
  tail call void @llvm.dbg.value(metadata !{i8 %color}, i64 0, metadata !40), !dbg !111
  %conv = sext i8 %c to i16, !dbg !112
  tail call void @llvm.dbg.value(metadata !{i8 %c}, i64 0, metadata !41), !dbg !112
  %conv3 = zext i8 %color to i16, !dbg !113
  %shl = shl nuw i16 %conv3, 8, !dbg !113
  %or = or i16 %shl, %conv, !dbg !113
  ret i16 %or, !dbg !113
}

; Function Attrs: nounwind readonly
define i32 @strlen(i8* nocapture readonly %str) #1 {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %str}, i64 0, metadata !51), !dbg !114
  tail call void @llvm.dbg.value(metadata !21, i64 0, metadata !52), !dbg !115
  br label %while.cond, !dbg !116

while.cond:                                       ; preds = %while.cond, %entry
  %ret.0 = phi i32 [ 0, %entry ], [ %inc, %while.cond ]
  %arrayidx = getelementptr inbounds i8* %str, i32 %ret.0, !dbg !116
  %0 = load i8* %arrayidx, align 1, !dbg !116, !tbaa !117
  %cmp = icmp eq i8 %0, 0, !dbg !116
  %inc = add i32 %ret.0, 1, !dbg !120
  tail call void @llvm.dbg.value(metadata !{i32 %inc}, i64 0, metadata !52), !dbg !120
  br i1 %cmp, label %while.end, label %while.cond, !dbg !116

while.end:                                        ; preds = %while.cond
  ret i32 %ret.0, !dbg !121
}

; Function Attrs: nounwind
define void @terminal_initialize() #2 {
entry:
  store i32 0, i32* @terminal_row, align 4, !dbg !122, !tbaa !123
  store i32 0, i32* @terminal_column, align 4, !dbg !125, !tbaa !123
  tail call void @llvm.dbg.value(metadata !126, i64 0, metadata !127), !dbg !129
  tail call void @llvm.dbg.value(metadata !21, i64 0, metadata !130), !dbg !129
  store i8 7, i8* @terminal_color, align 1, !dbg !128, !tbaa !117
  store i16* inttoptr (i32 -1072988160 to i16*), i16** @terminal_buffer, align 4, !dbg !131, !tbaa !132
  tail call void @llvm.dbg.value(metadata !21, i64 0, metadata !57), !dbg !134
  br label %for.cond1.preheader, !dbg !134

for.cond1.preheader:                              ; preds = %for.inc5, %entry
  %y.012 = phi i32 [ 0, %entry ], [ %inc6, %for.inc5 ]
  %mul = mul i32 %y.012, 80, !dbg !135
  br label %for.body3, !dbg !136

for.body3:                                        ; preds = %for.body3, %for.cond1.preheader
  %x.011 = phi i32 [ 0, %for.cond1.preheader ], [ %inc, %for.body3 ]
  %add = add i32 %x.011, %mul, !dbg !135
  tail call void @llvm.dbg.value(metadata !{i32 %add}, i64 0, metadata !62), !dbg !135
  %0 = load i8* @terminal_color, align 1, !dbg !137, !tbaa !117
  tail call void @llvm.dbg.value(metadata !138, i64 0, metadata !139), !dbg !140
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !141), !dbg !140
  tail call void @llvm.dbg.value(metadata !138, i64 0, metadata !142), !dbg !143
  %conv3.i = zext i8 %0 to i16, !dbg !144
  %shl.i = shl nuw i16 %conv3.i, 8, !dbg !144
  %or.i = or i16 %shl.i, 32, !dbg !144
  %arrayidx = getelementptr inbounds i16* inttoptr (i32 -1072988160 to i16*), i32 %add, !dbg !137
  store i16 %or.i, i16* %arrayidx, align 2, !dbg !137, !tbaa !145
  %inc = add i32 %x.011, 1, !dbg !136
  tail call void @llvm.dbg.value(metadata !{i32 %inc}, i64 0, metadata !59), !dbg !136
  %exitcond = icmp eq i32 %inc, 80, !dbg !136
  br i1 %exitcond, label %for.inc5, label %for.body3, !dbg !136

for.inc5:                                         ; preds = %for.body3
  %inc6 = add i32 %y.012, 1, !dbg !134
  tail call void @llvm.dbg.value(metadata !{i32 %inc6}, i64 0, metadata !57), !dbg !134
  %exitcond13 = icmp eq i32 %inc6, 25, !dbg !134
  br i1 %exitcond13, label %for.end7, label %for.cond1.preheader, !dbg !134

for.end7:                                         ; preds = %for.inc5
  ret void, !dbg !147
}

; Function Attrs: nounwind
define void @terminal_setcolor(i8 zeroext %color) #2 {
entry:
  tail call void @llvm.dbg.value(metadata !{i8 %color}, i64 0, metadata !69), !dbg !148
  store i8 %color, i8* @terminal_color, align 1, !dbg !149, !tbaa !117
  ret void, !dbg !150
}

; Function Attrs: nounwind
define void @terminal_putentryat(i8 signext %c, i8 zeroext %color, i32 %x, i32 %y) #2 {
entry:
  tail call void @llvm.dbg.value(metadata !{i8 %c}, i64 0, metadata !74), !dbg !151
  tail call void @llvm.dbg.value(metadata !{i8 %color}, i64 0, metadata !75), !dbg !151
  tail call void @llvm.dbg.value(metadata !{i32 %x}, i64 0, metadata !76), !dbg !151
  tail call void @llvm.dbg.value(metadata !{i32 %y}, i64 0, metadata !77), !dbg !151
  %mul = mul i32 %y, 80, !dbg !152
  %add = add i32 %mul, %x, !dbg !152
  tail call void @llvm.dbg.value(metadata !{i32 %add}, i64 0, metadata !78), !dbg !152
  tail call void @llvm.dbg.value(metadata !{i8 %c}, i64 0, metadata !153), !dbg !155
  tail call void @llvm.dbg.value(metadata !{i8 %color}, i64 0, metadata !156), !dbg !155
  %conv.i = sext i8 %c to i16, !dbg !157
  tail call void @llvm.dbg.value(metadata !{i8 %c}, i64 0, metadata !158), !dbg !157
  %conv3.i = zext i8 %color to i16, !dbg !159
  %shl.i = shl nuw i16 %conv3.i, 8, !dbg !159
  %or.i = or i16 %shl.i, %conv.i, !dbg !159
  %0 = load i16** @terminal_buffer, align 4, !dbg !154, !tbaa !132
  %arrayidx = getelementptr inbounds i16* %0, i32 %add, !dbg !154
  store i16 %or.i, i16* %arrayidx, align 2, !dbg !154, !tbaa !145
  ret void, !dbg !160
}

; Function Attrs: nounwind
define zeroext i1 @terminal_handlewhitespace(i8 signext %c) #2 {
entry:
  tail call void @llvm.dbg.value(metadata !{i8 %c}, i64 0, metadata !84), !dbg !161
  %conv = sext i8 %c to i32, !dbg !162
  switch i32 %conv, label %return [
    i32 10, label %sw.bb
    i32 13, label %sw.bb1
    i32 9, label %sw.bb2
  ], !dbg !162

sw.bb:                                            ; preds = %entry
  %0 = load i32* @terminal_row, align 4, !dbg !163, !tbaa !123
  %add = add i32 %0, 1, !dbg !163
  store i32 %add, i32* @terminal_row, align 4, !dbg !163, !tbaa !123
  br label %return, !dbg !165

sw.bb1:                                           ; preds = %entry
  store i32 0, i32* @terminal_column, align 4, !dbg !166, !tbaa !123
  br label %return, !dbg !167

sw.bb2:                                           ; preds = %entry
  %1 = load i32* @terminal_column, align 4, !dbg !168, !tbaa !123
  %add3 = add i32 %1, 5, !dbg !168
  store i32 %add3, i32* @terminal_column, align 4, !dbg !168, !tbaa !123
  br label %return, !dbg !169

return:                                           ; preds = %sw.bb, %sw.bb1, %sw.bb2, %entry
  %retval.0 = phi i1 [ false, %entry ], [ true, %sw.bb2 ], [ true, %sw.bb1 ], [ true, %sw.bb ]
  ret i1 %retval.0, !dbg !170
}

; Function Attrs: nounwind
define void @terminal_putchar(i8 signext %c) #2 {
entry:
  tail call void @llvm.dbg.value(metadata !{i8 %c}, i64 0, metadata !89), !dbg !171
  tail call void @llvm.dbg.value(metadata !{i8 %c}, i64 0, metadata !172), !dbg !175
  %conv.i = sext i8 %c to i32, !dbg !176
  switch i32 %conv.i, label %if.end [
    i32 10, label %sw.bb.i
    i32 13, label %sw.bb1.i
    i32 9, label %sw.bb2.i
  ], !dbg !176

sw.bb.i:                                          ; preds = %entry
  %0 = load i32* @terminal_row, align 4, !dbg !177, !tbaa !123
  %add.i = add i32 %0, 1, !dbg !177
  store i32 %add.i, i32* @terminal_row, align 4, !dbg !177, !tbaa !123
  br label %if.end6, !dbg !178

sw.bb1.i:                                         ; preds = %entry
  store i32 0, i32* @terminal_column, align 4, !dbg !179, !tbaa !123
  br label %if.end6, !dbg !180

sw.bb2.i:                                         ; preds = %entry
  %1 = load i32* @terminal_column, align 4, !dbg !181, !tbaa !123
  %add3.i = add i32 %1, 5, !dbg !181
  store i32 %add3.i, i32* @terminal_column, align 4, !dbg !181, !tbaa !123
  br label %if.end6, !dbg !182

if.end:                                           ; preds = %entry
  %2 = load i8* @terminal_color, align 1, !dbg !183, !tbaa !117
  %3 = load i32* @terminal_column, align 4, !dbg !183, !tbaa !123
  %4 = load i32* @terminal_row, align 4, !dbg !183, !tbaa !123
  tail call void @llvm.dbg.value(metadata !{i8 %c}, i64 0, metadata !184), !dbg !185
  tail call void @llvm.dbg.value(metadata !{i8 %2}, i64 0, metadata !186), !dbg !185
  tail call void @llvm.dbg.value(metadata !{i32 %3}, i64 0, metadata !187), !dbg !185
  tail call void @llvm.dbg.value(metadata !{i32 %4}, i64 0, metadata !188), !dbg !185
  %mul.i = mul i32 %4, 80, !dbg !189
  %add.i8 = add i32 %mul.i, %3, !dbg !189
  tail call void @llvm.dbg.value(metadata !{i32 %add.i8}, i64 0, metadata !190), !dbg !189
  tail call void @llvm.dbg.value(metadata !{i8 %c}, i64 0, metadata !191), !dbg !193
  tail call void @llvm.dbg.value(metadata !{i8 %2}, i64 0, metadata !194), !dbg !193
  %conv.i.i = sext i8 %c to i16, !dbg !195
  tail call void @llvm.dbg.value(metadata !{i8 %c}, i64 0, metadata !196), !dbg !195
  %conv3.i.i = zext i8 %2 to i16, !dbg !197
  %shl.i.i = shl nuw i16 %conv3.i.i, 8, !dbg !197
  %or.i.i = or i16 %shl.i.i, %conv.i.i, !dbg !197
  %5 = load i16** @terminal_buffer, align 4, !dbg !192, !tbaa !132
  %arrayidx.i = getelementptr inbounds i16* %5, i32 %add.i8, !dbg !192
  store i16 %or.i.i, i16* %arrayidx.i, align 2, !dbg !192, !tbaa !145
  %inc = add i32 %3, 1, !dbg !198
  store i32 %inc, i32* @terminal_column, align 4, !dbg !198, !tbaa !123
  %cmp = icmp eq i32 %inc, 80, !dbg !198
  br i1 %cmp, label %if.then1, label %if.end6, !dbg !198

if.then1:                                         ; preds = %if.end
  store i32 0, i32* @terminal_column, align 4, !dbg !200, !tbaa !123
  %inc2 = add i32 %4, 1, !dbg !202
  %cmp3 = icmp eq i32 %inc2, 25, !dbg !202
  %.inc2 = select i1 %cmp3, i32 0, i32 %inc2, !dbg !202
  store i32 %.inc2, i32* @terminal_row, align 4, !dbg !204, !tbaa !123
  br label %if.end6, !dbg !206

if.end6:                                          ; preds = %sw.bb.i, %sw.bb1.i, %sw.bb2.i, %if.then1, %if.end
  ret void, !dbg !207
}

; Function Attrs: nounwind
define void @terminal_writestring(i8* nocapture readonly %data) #2 {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %data}, i64 0, metadata !94), !dbg !208
  tail call void @llvm.dbg.value(metadata !{i8* %data}, i64 0, metadata !209), !dbg !211
  tail call void @llvm.dbg.value(metadata !21, i64 0, metadata !212), !dbg !213
  br label %while.cond.i, !dbg !214

while.cond.i:                                     ; preds = %while.cond.i, %entry
  %indvars.iv = phi i32 [ %indvars.iv.next, %while.cond.i ], [ 0, %entry ]
  %arrayidx.i = getelementptr inbounds i8* %data, i32 %indvars.iv, !dbg !214
  %0 = load i8* %arrayidx.i, align 1, !dbg !214, !tbaa !117
  %cmp.i = icmp eq i8 %0, 0, !dbg !214
  %indvars.iv.next = add i32 %indvars.iv, 1, !dbg !214
  tail call void @llvm.dbg.value(metadata !{i32 %indvars.iv.next}, i64 0, metadata !212), !dbg !215
  br i1 %cmp.i, label %for.cond.preheader, label %while.cond.i, !dbg !214

for.cond.preheader:                               ; preds = %while.cond.i
  %cmp6 = icmp eq i32 %indvars.iv, 0, !dbg !216
  br i1 %cmp6, label %for.end, label %for.body, !dbg !216

for.body:                                         ; preds = %for.cond.preheader, %terminal_putchar.exit
  %i.07 = phi i32 [ %inc, %terminal_putchar.exit ], [ 0, %for.cond.preheader ]
  %arrayidx = getelementptr inbounds i8* %data, i32 %i.07, !dbg !217
  %1 = load i8* %arrayidx, align 1, !dbg !217, !tbaa !117
  tail call void @llvm.dbg.value(metadata !{i8 %1}, i64 0, metadata !218), !dbg !219
  tail call void @llvm.dbg.value(metadata !{i8 %1}, i64 0, metadata !220), !dbg !222
  %conv.i.i = sext i8 %1 to i32, !dbg !223
  switch i32 %conv.i.i, label %if.end.i [
    i32 10, label %sw.bb.i.i
    i32 13, label %sw.bb1.i.i
    i32 9, label %sw.bb2.i.i
  ], !dbg !223

sw.bb.i.i:                                        ; preds = %for.body
  %2 = load i32* @terminal_row, align 4, !dbg !224, !tbaa !123
  %add.i.i = add i32 %2, 1, !dbg !224
  store i32 %add.i.i, i32* @terminal_row, align 4, !dbg !224, !tbaa !123
  br label %terminal_putchar.exit, !dbg !225

sw.bb1.i.i:                                       ; preds = %for.body
  store i32 0, i32* @terminal_column, align 4, !dbg !226, !tbaa !123
  br label %terminal_putchar.exit, !dbg !227

sw.bb2.i.i:                                       ; preds = %for.body
  %3 = load i32* @terminal_column, align 4, !dbg !228, !tbaa !123
  %add3.i.i = add i32 %3, 5, !dbg !228
  store i32 %add3.i.i, i32* @terminal_column, align 4, !dbg !228, !tbaa !123
  br label %terminal_putchar.exit, !dbg !229

if.end.i:                                         ; preds = %for.body
  %4 = load i8* @terminal_color, align 1, !dbg !230, !tbaa !117
  %5 = load i32* @terminal_column, align 4, !dbg !230, !tbaa !123
  %6 = load i32* @terminal_row, align 4, !dbg !230, !tbaa !123
  tail call void @llvm.dbg.value(metadata !{i8 %1}, i64 0, metadata !231), !dbg !232
  tail call void @llvm.dbg.value(metadata !{i8 %4}, i64 0, metadata !233), !dbg !232
  tail call void @llvm.dbg.value(metadata !{i32 %5}, i64 0, metadata !234), !dbg !232
  tail call void @llvm.dbg.value(metadata !{i32 %6}, i64 0, metadata !235), !dbg !232
  %mul.i.i = mul i32 %6, 80, !dbg !236
  %add.i8.i = add i32 %mul.i.i, %5, !dbg !236
  tail call void @llvm.dbg.value(metadata !{i32 %add.i8.i}, i64 0, metadata !237), !dbg !236
  tail call void @llvm.dbg.value(metadata !{i8 %1}, i64 0, metadata !238), !dbg !240
  tail call void @llvm.dbg.value(metadata !{i8 %4}, i64 0, metadata !241), !dbg !240
  %conv.i.i.i = sext i8 %1 to i16, !dbg !242
  tail call void @llvm.dbg.value(metadata !{i8 %1}, i64 0, metadata !243), !dbg !242
  %conv3.i.i.i = zext i8 %4 to i16, !dbg !244
  %shl.i.i.i = shl nuw i16 %conv3.i.i.i, 8, !dbg !244
  %or.i.i.i = or i16 %shl.i.i.i, %conv.i.i.i, !dbg !244
  %7 = load i16** @terminal_buffer, align 4, !dbg !239, !tbaa !132
  %arrayidx.i.i = getelementptr inbounds i16* %7, i32 %add.i8.i, !dbg !239
  store i16 %or.i.i.i, i16* %arrayidx.i.i, align 2, !dbg !239, !tbaa !145
  %inc.i4 = add i32 %5, 1, !dbg !245
  store i32 %inc.i4, i32* @terminal_column, align 4, !dbg !245, !tbaa !123
  %cmp.i5 = icmp eq i32 %inc.i4, 80, !dbg !245
  br i1 %cmp.i5, label %if.then1.i, label %terminal_putchar.exit, !dbg !245

if.then1.i:                                       ; preds = %if.end.i
  store i32 0, i32* @terminal_column, align 4, !dbg !246, !tbaa !123
  %inc2.i = add i32 %6, 1, !dbg !247
  %cmp3.i = icmp eq i32 %inc2.i, 25, !dbg !247
  %.inc2.i = select i1 %cmp3.i, i32 0, i32 %inc2.i, !dbg !247
  store i32 %.inc2.i, i32* @terminal_row, align 4, !dbg !248, !tbaa !123
  br label %terminal_putchar.exit, !dbg !249

terminal_putchar.exit:                            ; preds = %sw.bb.i.i, %sw.bb1.i.i, %sw.bb2.i.i, %if.end.i, %if.then1.i
  %inc = add i32 %i.07, 1, !dbg !216
  tail call void @llvm.dbg.value(metadata !{i32 %inc}, i64 0, metadata !96), !dbg !216
  %exitcond = icmp eq i32 %inc, %indvars.iv, !dbg !216
  br i1 %exitcond, label %for.end, label %for.body, !dbg !216

for.end:                                          ; preds = %terminal_putchar.exit, %for.cond.preheader
  ret void, !dbg !250
}

; Function Attrs: nounwind
define void @kernel_main() #2 {
entry:
  store i32 0, i32* @terminal_row, align 4, !dbg !251, !tbaa !123
  store i32 0, i32* @terminal_column, align 4, !dbg !253, !tbaa !123
  tail call void @llvm.dbg.value(metadata !126, i64 0, metadata !254), !dbg !256
  tail call void @llvm.dbg.value(metadata !21, i64 0, metadata !257), !dbg !256
  store i8 7, i8* @terminal_color, align 1, !dbg !255, !tbaa !117
  store i16* inttoptr (i32 -1072988160 to i16*), i16** @terminal_buffer, align 4, !dbg !258, !tbaa !132
  tail call void @llvm.dbg.value(metadata !21, i64 0, metadata !259), !dbg !260
  br label %for.cond1.preheader.i, !dbg !260

for.cond1.preheader.i:                            ; preds = %for.inc5.i, %entry
  %y.012.i = phi i32 [ 0, %entry ], [ %inc6.i, %for.inc5.i ]
  %mul.i = mul i32 %y.012.i, 80, !dbg !261
  br label %for.body3.i, !dbg !262

for.body3.i:                                      ; preds = %for.body3.i, %for.cond1.preheader.i
  %x.011.i = phi i32 [ 0, %for.cond1.preheader.i ], [ %inc.i, %for.body3.i ]
  %add.i = add i32 %x.011.i, %mul.i, !dbg !261
  tail call void @llvm.dbg.value(metadata !{i32 %add.i}, i64 0, metadata !263), !dbg !261
  %0 = load i8* @terminal_color, align 1, !dbg !264, !tbaa !117
  tail call void @llvm.dbg.value(metadata !138, i64 0, metadata !265), !dbg !266
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !267), !dbg !266
  tail call void @llvm.dbg.value(metadata !138, i64 0, metadata !268), !dbg !269
  %conv3.i.i = zext i8 %0 to i16, !dbg !270
  %shl.i.i = shl nuw i16 %conv3.i.i, 8, !dbg !270
  %or.i.i = or i16 %shl.i.i, 32, !dbg !270
  %arrayidx.i = getelementptr inbounds i16* inttoptr (i32 -1072988160 to i16*), i32 %add.i, !dbg !264
  store i16 %or.i.i, i16* %arrayidx.i, align 2, !dbg !264, !tbaa !145
  %inc.i = add i32 %x.011.i, 1, !dbg !262
  tail call void @llvm.dbg.value(metadata !{i32 %inc.i}, i64 0, metadata !271), !dbg !262
  %exitcond.i = icmp eq i32 %inc.i, 80, !dbg !262
  br i1 %exitcond.i, label %for.inc5.i, label %for.body3.i, !dbg !262

for.inc5.i:                                       ; preds = %for.body3.i
  %inc6.i = add i32 %y.012.i, 1, !dbg !260
  tail call void @llvm.dbg.value(metadata !{i32 %inc6.i}, i64 0, metadata !259), !dbg !260
  %exitcond13.i = icmp eq i32 %inc6.i, 25, !dbg !260
  br i1 %exitcond13.i, label %for.body.i, label %for.cond1.preheader.i, !dbg !260

for.body.i:                                       ; preds = %for.inc5.i, %terminal_putchar.exit.i
  %1 = phi i32 [ %5, %terminal_putchar.exit.i ], [ 0, %for.inc5.i ]
  %2 = phi i32 [ %6, %terminal_putchar.exit.i ], [ 0, %for.inc5.i ]
  %i.07.i = phi i32 [ %inc.i2, %terminal_putchar.exit.i ], [ 0, %for.inc5.i ]
  %arrayidx.i1 = getelementptr inbounds [22 x i8]* @.str, i32 0, i32 %i.07.i, !dbg !272
  %3 = load i8* %arrayidx.i1, align 1, !dbg !272, !tbaa !117
  tail call void @llvm.dbg.value(metadata !{i8 %3}, i64 0, metadata !274), !dbg !275
  tail call void @llvm.dbg.value(metadata !{i8 %3}, i64 0, metadata !276), !dbg !278
  %conv.i.i.i = sext i8 %3 to i32, !dbg !279
  switch i32 %conv.i.i.i, label %if.end.i.i [
    i32 10, label %sw.bb.i.i.i
    i32 13, label %sw.bb1.i.i.i
    i32 9, label %sw.bb2.i.i.i
  ], !dbg !279

sw.bb.i.i.i:                                      ; preds = %for.body.i
  %add.i.i.i = add i32 %1, 1, !dbg !280
  store i32 %add.i.i.i, i32* @terminal_row, align 4, !dbg !280, !tbaa !123
  br label %terminal_putchar.exit.i, !dbg !281

sw.bb1.i.i.i:                                     ; preds = %for.body.i
  store i32 0, i32* @terminal_column, align 4, !dbg !282, !tbaa !123
  br label %terminal_putchar.exit.i, !dbg !283

sw.bb2.i.i.i:                                     ; preds = %for.body.i
  %add3.i.i.i = add i32 %2, 5, !dbg !284
  store i32 %add3.i.i.i, i32* @terminal_column, align 4, !dbg !284, !tbaa !123
  br label %terminal_putchar.exit.i, !dbg !285

if.end.i.i:                                       ; preds = %for.body.i
  %4 = load i8* @terminal_color, align 1, !dbg !286, !tbaa !117
  tail call void @llvm.dbg.value(metadata !{i8 %3}, i64 0, metadata !287), !dbg !288
  tail call void @llvm.dbg.value(metadata !{i8 %4}, i64 0, metadata !289), !dbg !288
  tail call void @llvm.dbg.value(metadata !{i32 %2}, i64 0, metadata !290), !dbg !288
  tail call void @llvm.dbg.value(metadata !{i32 %1}, i64 0, metadata !291), !dbg !288
  %mul.i.i.i = mul i32 %1, 80, !dbg !292
  %add.i8.i.i = add i32 %mul.i.i.i, %2, !dbg !292
  tail call void @llvm.dbg.value(metadata !{i32 %add.i8.i.i}, i64 0, metadata !293), !dbg !292
  tail call void @llvm.dbg.value(metadata !{i8 %3}, i64 0, metadata !294), !dbg !296
  tail call void @llvm.dbg.value(metadata !{i8 %4}, i64 0, metadata !297), !dbg !296
  %conv.i.i.i.i = sext i8 %3 to i16, !dbg !298
  tail call void @llvm.dbg.value(metadata !{i8 %3}, i64 0, metadata !299), !dbg !298
  %conv3.i.i.i.i = zext i8 %4 to i16, !dbg !300
  %shl.i.i.i.i = shl nuw i16 %conv3.i.i.i.i, 8, !dbg !300
  %or.i.i.i.i = or i16 %shl.i.i.i.i, %conv.i.i.i.i, !dbg !300
  %arrayidx.i.i.i = getelementptr inbounds i16* inttoptr (i32 -1072988160 to i16*), i32 %add.i8.i.i, !dbg !295
  store i16 %or.i.i.i.i, i16* %arrayidx.i.i.i, align 2, !dbg !295, !tbaa !145
  %inc.i4.i = add i32 %2, 1, !dbg !301
  store i32 %inc.i4.i, i32* @terminal_column, align 4, !dbg !301, !tbaa !123
  %cmp.i5.i = icmp eq i32 %inc.i4.i, 80, !dbg !301
  br i1 %cmp.i5.i, label %if.then1.i.i, label %terminal_putchar.exit.i, !dbg !301

if.then1.i.i:                                     ; preds = %if.end.i.i
  store i32 0, i32* @terminal_column, align 4, !dbg !302, !tbaa !123
  %inc2.i.i = add i32 %1, 1, !dbg !303
  %cmp3.i.i = icmp eq i32 %inc2.i.i, 25, !dbg !303
  %.inc2.i.i = select i1 %cmp3.i.i, i32 0, i32 %inc2.i.i, !dbg !303
  store i32 %.inc2.i.i, i32* @terminal_row, align 4, !dbg !304, !tbaa !123
  br label %terminal_putchar.exit.i, !dbg !305

terminal_putchar.exit.i:                          ; preds = %if.then1.i.i, %if.end.i.i, %sw.bb2.i.i.i, %sw.bb1.i.i.i, %sw.bb.i.i.i
  %5 = phi i32 [ %.inc2.i.i, %if.then1.i.i ], [ %1, %if.end.i.i ], [ %1, %sw.bb2.i.i.i ], [ %1, %sw.bb1.i.i.i ], [ %add.i.i.i, %sw.bb.i.i.i ]
  %6 = phi i32 [ 0, %if.then1.i.i ], [ %inc.i4.i, %if.end.i.i ], [ %add3.i.i.i, %sw.bb2.i.i.i ], [ 0, %sw.bb1.i.i.i ], [ %2, %sw.bb.i.i.i ]
  %inc.i2 = add i32 %i.07.i, 1, !dbg !306
  tail call void @llvm.dbg.value(metadata !{i32 %inc.i2}, i64 0, metadata !307), !dbg !306
  %exitcond.i3 = icmp eq i32 %inc.i2, 21, !dbg !306
  br i1 %exitcond.i3, label %terminal_writestring.exit, label %for.body.i, !dbg !306

terminal_writestring.exit:                        ; preds = %terminal_putchar.exit.i
  ret void, !dbg !308
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata) #3

attributes #0 = { nounwind readnone "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readonly "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind readnone }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!107}
!llvm.ident = !{!108}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"clang version 3.4 (http://llvm.org/git/clang.git 82a2911a94947e20ac4fd961b6322adf74ad9224) (http://llvm.org/git/llvm.git 52244da7f2b3def646900520668b859343b84a33)", i1 true, metadata !"", i32 0, metadata !2, metadata !21, metadata !22, metadata !99, metadata !21, metadata !""} ; [ DW_TAG_compile_unit ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c] [DW_LANG_C99]
!1 = metadata !{metadata !"src/kernel.c", metadata !"/home/gbps/Desktop/Projects/os_notshared/pandos"}
!2 = metadata !{metadata !3}
!3 = metadata !{i32 786436, metadata !1, null, metadata !"vga_color", i32 18, i64 32, i64 32, i32 0, i32 0, null, metadata !4, i32 0, null, null, null} ; [ DW_TAG_enumeration_type ] [vga_color] [line 18, size 32, align 32, offset 0] [def] [from ]
!4 = metadata !{metadata !5, metadata !6, metadata !7, metadata !8, metadata !9, metadata !10, metadata !11, metadata !12, metadata !13, metadata !14, metadata !15, metadata !16, metadata !17, metadata !18, metadata !19, metadata !20}
!5 = metadata !{i32 786472, metadata !"COLOR_BLACK", i64 0} ; [ DW_TAG_enumerator ] [COLOR_BLACK :: 0]
!6 = metadata !{i32 786472, metadata !"COLOR_BLUE", i64 1} ; [ DW_TAG_enumerator ] [COLOR_BLUE :: 1]
!7 = metadata !{i32 786472, metadata !"COLOR_GREEN", i64 2} ; [ DW_TAG_enumerator ] [COLOR_GREEN :: 2]
!8 = metadata !{i32 786472, metadata !"COLOR_CYAN", i64 3} ; [ DW_TAG_enumerator ] [COLOR_CYAN :: 3]
!9 = metadata !{i32 786472, metadata !"COLOR_RED", i64 4} ; [ DW_TAG_enumerator ] [COLOR_RED :: 4]
!10 = metadata !{i32 786472, metadata !"COLOR_MAGENTA", i64 5} ; [ DW_TAG_enumerator ] [COLOR_MAGENTA :: 5]
!11 = metadata !{i32 786472, metadata !"COLOR_BROWN", i64 6} ; [ DW_TAG_enumerator ] [COLOR_BROWN :: 6]
!12 = metadata !{i32 786472, metadata !"COLOR_LIGHT_GREY", i64 7} ; [ DW_TAG_enumerator ] [COLOR_LIGHT_GREY :: 7]
!13 = metadata !{i32 786472, metadata !"COLOR_DARK_GREY", i64 8} ; [ DW_TAG_enumerator ] [COLOR_DARK_GREY :: 8]
!14 = metadata !{i32 786472, metadata !"COLOR_LIGHT_BLUE", i64 9} ; [ DW_TAG_enumerator ] [COLOR_LIGHT_BLUE :: 9]
!15 = metadata !{i32 786472, metadata !"COLOR_LIGHT_GREEN", i64 10} ; [ DW_TAG_enumerator ] [COLOR_LIGHT_GREEN :: 10]
!16 = metadata !{i32 786472, metadata !"COLOR_LIGHT_CYAN", i64 11} ; [ DW_TAG_enumerator ] [COLOR_LIGHT_CYAN :: 11]
!17 = metadata !{i32 786472, metadata !"COLOR_LIGHT_RED", i64 12} ; [ DW_TAG_enumerator ] [COLOR_LIGHT_RED :: 12]
!18 = metadata !{i32 786472, metadata !"COLOR_LIGHT_MAGENTA", i64 13} ; [ DW_TAG_enumerator ] [COLOR_LIGHT_MAGENTA :: 13]
!19 = metadata !{i32 786472, metadata !"COLOR_LIGHT_BROWN", i64 14} ; [ DW_TAG_enumerator ] [COLOR_LIGHT_BROWN :: 14]
!20 = metadata !{i32 786472, metadata !"COLOR_WHITE", i64 15} ; [ DW_TAG_enumerator ] [COLOR_WHITE :: 15]
!21 = metadata !{i32 0}
!22 = metadata !{metadata !23, metadata !32, metadata !43, metadata !53, metadata !65, metadata !70, metadata !79, metadata !85, metadata !90, metadata !98}
!23 = metadata !{i32 786478, metadata !1, metadata !24, metadata !"make_color", metadata !"make_color", metadata !"", i32 37, metadata !25, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8 (i32, i32)* @make_color, null, null, metadata !29, i32 37} ; [ DW_TAG_subprogram ] [line 37] [def] [make_color]
!24 = metadata !{i32 786473, metadata !1}         ; [ DW_TAG_file_type ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!25 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !26, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!26 = metadata !{metadata !27, metadata !3, metadata !3}
!27 = metadata !{i32 786454, metadata !1, null, metadata !"uint8_t", i32 238, i64 0, i64 0, i64 0, i32 0, metadata !28} ; [ DW_TAG_typedef ] [uint8_t] [line 238, size 0, align 0, offset 0] [from unsigned char]
!28 = metadata !{i32 786468, null, null, metadata !"unsigned char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 8} ; [ DW_TAG_base_type ] [unsigned char] [line 0, size 8, align 8, offset 0, enc DW_ATE_unsigned_char]
!29 = metadata !{metadata !30, metadata !31}
!30 = metadata !{i32 786689, metadata !23, metadata !"fg", metadata !24, i32 16777253, metadata !3, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [fg] [line 37]
!31 = metadata !{i32 786689, metadata !23, metadata !"bg", metadata !24, i32 33554469, metadata !3, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [bg] [line 37]
!32 = metadata !{i32 786478, metadata !1, metadata !24, metadata !"make_vgaentry", metadata !"make_vgaentry", metadata !"", i32 41, metadata !33, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i16 (i8, i8)* @make_vgaentry, null, null, metadata !38, i32 41} ; [ DW_TAG_subprogram ] [line 41] [def] [make_vgaentry]
!33 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !34, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!34 = metadata !{metadata !35, metadata !37, metadata !27}
!35 = metadata !{i32 786454, metadata !1, null, metadata !"uint16_t", i32 219, i64 0, i64 0, i64 0, i32 0, metadata !36} ; [ DW_TAG_typedef ] [uint16_t] [line 219, size 0, align 0, offset 0] [from unsigned short]
!36 = metadata !{i32 786468, null, null, metadata !"unsigned short", i32 0, i64 16, i64 16, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [unsigned short] [line 0, size 16, align 16, offset 0, enc DW_ATE_unsigned]
!37 = metadata !{i32 786468, null, null, metadata !"char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!38 = metadata !{metadata !39, metadata !40, metadata !41, metadata !42}
!39 = metadata !{i32 786689, metadata !32, metadata !"c", metadata !24, i32 16777257, metadata !37, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [c] [line 41]
!40 = metadata !{i32 786689, metadata !32, metadata !"color", metadata !24, i32 33554473, metadata !27, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [color] [line 41]
!41 = metadata !{i32 786688, metadata !32, metadata !"c16", metadata !24, i32 42, metadata !35, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [c16] [line 42]
!42 = metadata !{i32 786688, metadata !32, metadata !"color16", metadata !24, i32 43, metadata !35, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [color16] [line 43]
!43 = metadata !{i32 786478, metadata !1, metadata !24, metadata !"strlen", metadata !"strlen", metadata !"", i32 47, metadata !44, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*)* @strlen, null, null, metadata !50, i32 47} ; [ DW_TAG_subprogram ] [line 47] [def] [strlen]
!44 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !45, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!45 = metadata !{metadata !46, metadata !48}
!46 = metadata !{i32 786454, metadata !1, null, metadata !"size_t", i32 42, i64 0, i64 0, i64 0, i32 0, metadata !47} ; [ DW_TAG_typedef ] [size_t] [line 42, size 0, align 0, offset 0] [from unsigned int]
!47 = metadata !{i32 786468, null, null, metadata !"unsigned int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [unsigned int] [line 0, size 32, align 32, offset 0, enc DW_ATE_unsigned]
!48 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, metadata !49} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from ]
!49 = metadata !{i32 786470, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !37} ; [ DW_TAG_const_type ] [line 0, size 0, align 0, offset 0] [from char]
!50 = metadata !{metadata !51, metadata !52}
!51 = metadata !{i32 786689, metadata !43, metadata !"str", metadata !24, i32 16777263, metadata !48, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [str] [line 47]
!52 = metadata !{i32 786688, metadata !43, metadata !"ret", metadata !24, i32 48, metadata !46, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [ret] [line 48]
!53 = metadata !{i32 786478, metadata !1, metadata !24, metadata !"terminal_initialize", metadata !"terminal_initialize", metadata !"", i32 62, metadata !54, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 true, void ()* @terminal_initialize, null, null, metadata !56, i32 62} ; [ DW_TAG_subprogram ] [line 62] [def] [terminal_initialize]
!54 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !55, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!55 = metadata !{null}
!56 = metadata !{metadata !57, metadata !59, metadata !62}
!57 = metadata !{i32 786688, metadata !58, metadata !"y", metadata !24, i32 67, metadata !46, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [y] [line 67]
!58 = metadata !{i32 786443, metadata !1, metadata !53, i32 67, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!59 = metadata !{i32 786688, metadata !60, metadata !"x", metadata !24, i32 68, metadata !46, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [x] [line 68]
!60 = metadata !{i32 786443, metadata !1, metadata !61, i32 68, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!61 = metadata !{i32 786443, metadata !1, metadata !58, i32 67, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!62 = metadata !{i32 786688, metadata !63, metadata !"index", metadata !24, i32 69, metadata !64, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [index] [line 69]
!63 = metadata !{i32 786443, metadata !1, metadata !60, i32 68, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!64 = metadata !{i32 786470, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !46} ; [ DW_TAG_const_type ] [line 0, size 0, align 0, offset 0] [from size_t]
!65 = metadata !{i32 786478, metadata !1, metadata !24, metadata !"terminal_setcolor", metadata !"terminal_setcolor", metadata !"", i32 75, metadata !66, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, void (i8)* @terminal_setcolor, null, null, metadata !68, i32 75} ; [ DW_TAG_subprogram ] [line 75] [def] [terminal_setcolor]
!66 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !67, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!67 = metadata !{null, metadata !27}
!68 = metadata !{metadata !69}
!69 = metadata !{i32 786689, metadata !65, metadata !"color", metadata !24, i32 16777291, metadata !27, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [color] [line 75]
!70 = metadata !{i32 786478, metadata !1, metadata !24, metadata !"terminal_putentryat", metadata !"terminal_putentryat", metadata !"", i32 79, metadata !71, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, void (i8, i8, i32, i32)* @terminal_putentryat, null, null, metadata !73, i32 79} ; [ DW_TAG_subprogram ] [line 79] [def] [terminal_putentryat]
!71 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !72, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!72 = metadata !{null, metadata !37, metadata !27, metadata !46, metadata !46}
!73 = metadata !{metadata !74, metadata !75, metadata !76, metadata !77, metadata !78}
!74 = metadata !{i32 786689, metadata !70, metadata !"c", metadata !24, i32 16777295, metadata !37, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [c] [line 79]
!75 = metadata !{i32 786689, metadata !70, metadata !"color", metadata !24, i32 33554511, metadata !27, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [color] [line 79]
!76 = metadata !{i32 786689, metadata !70, metadata !"x", metadata !24, i32 50331727, metadata !46, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [x] [line 79]
!77 = metadata !{i32 786689, metadata !70, metadata !"y", metadata !24, i32 67108943, metadata !46, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [y] [line 79]
!78 = metadata !{i32 786688, metadata !70, metadata !"index", metadata !24, i32 80, metadata !64, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [index] [line 80]
!79 = metadata !{i32 786478, metadata !1, metadata !24, metadata !"terminal_handlewhitespace", metadata !"terminal_handlewhitespace", metadata !"", i32 84, metadata !80, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i1 (i8)* @terminal_handlewhitespace, null, null, metadata !83, i32 85} ; [ DW_TAG_subprogram ] [line 84] [def] [scope 85] [terminal_handlewhitespace]
!80 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !81, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!81 = metadata !{metadata !82, metadata !37}
!82 = metadata !{i32 786468, null, null, metadata !"_Bool", i32 0, i64 8, i64 8, i64 0, i32 0, i32 2} ; [ DW_TAG_base_type ] [_Bool] [line 0, size 8, align 8, offset 0, enc DW_ATE_boolean]
!83 = metadata !{metadata !84}
!84 = metadata !{i32 786689, metadata !79, metadata !"c", metadata !24, i32 16777300, metadata !37, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [c] [line 84]
!85 = metadata !{i32 786478, metadata !1, metadata !24, metadata !"terminal_putchar", metadata !"terminal_putchar", metadata !"", i32 105, metadata !86, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, void (i8)* @terminal_putchar, null, null, metadata !88, i32 106} ; [ DW_TAG_subprogram ] [line 105] [def] [scope 106] [terminal_putchar]
!86 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !87, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!87 = metadata !{null, metadata !37}
!88 = metadata !{metadata !89}
!89 = metadata !{i32 786689, metadata !85, metadata !"c", metadata !24, i32 16777321, metadata !37, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [c] [line 105]
!90 = metadata !{i32 786478, metadata !1, metadata !24, metadata !"terminal_writestring", metadata !"terminal_writestring", metadata !"", i32 120, metadata !91, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, void (i8*)* @terminal_writestring, null, null, metadata !93, i32 120} ; [ DW_TAG_subprogram ] [line 120] [def] [terminal_writestring]
!91 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !92, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!92 = metadata !{null, metadata !48}
!93 = metadata !{metadata !94, metadata !95, metadata !96}
!94 = metadata !{i32 786689, metadata !90, metadata !"data", metadata !24, i32 16777336, metadata !48, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [data] [line 120]
!95 = metadata !{i32 786688, metadata !90, metadata !"datalen", metadata !24, i32 121, metadata !46, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [datalen] [line 121]
!96 = metadata !{i32 786688, metadata !97, metadata !"i", metadata !24, i32 122, metadata !46, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 122]
!97 = metadata !{i32 786443, metadata !1, metadata !90, i32 122, i32 0, i32 11} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!98 = metadata !{i32 786478, metadata !1, metadata !24, metadata !"kernel_main", metadata !"kernel_main", metadata !"", i32 129, metadata !54, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 true, void ()* @kernel_main, null, null, metadata !21, i32 129} ; [ DW_TAG_subprogram ] [line 129] [def] [kernel_main]
!99 = metadata !{metadata !100, metadata !101, metadata !101, metadata !101, metadata !101, metadata !100, metadata !102, metadata !103, metadata !104, metadata !105}
!100 = metadata !{i32 786484, i32 0, metadata !24, metadata !"VGA_HEIGHT", metadata !"VGA_HEIGHT", metadata !"VGA_HEIGHT", metadata !24, i32 55, metadata !64, i32 1, i32 1, i32 25, null} ; [ DW_TAG_variable ] [VGA_HEIGHT] [line 55] [local] [def]
!101 = metadata !{i32 786484, i32 0, metadata !24, metadata !"VGA_WIDTH", metadata !"VGA_WIDTH", metadata !"VGA_WIDTH", metadata !24, i32 54, metadata !64, i32 1, i32 1, i32 80, null} ; [ DW_TAG_variable ] [VGA_WIDTH] [line 54] [local] [def]
!102 = metadata !{i32 786484, i32 0, null, metadata !"terminal_row", metadata !"terminal_row", metadata !"", metadata !24, i32 57, metadata !46, i32 0, i32 1, i32* @terminal_row, null} ; [ DW_TAG_variable ] [terminal_row] [line 57] [def]
!103 = metadata !{i32 786484, i32 0, null, metadata !"terminal_column", metadata !"terminal_column", metadata !"", metadata !24, i32 58, metadata !46, i32 0, i32 1, i32* @terminal_column, null} ; [ DW_TAG_variable ] [terminal_column] [line 58] [def]
!104 = metadata !{i32 786484, i32 0, null, metadata !"terminal_color", metadata !"terminal_color", metadata !"", metadata !24, i32 59, metadata !27, i32 0, i32 1, i8* @terminal_color, null} ; [ DW_TAG_variable ] [terminal_color] [line 59] [def]
!105 = metadata !{i32 786484, i32 0, null, metadata !"terminal_buffer", metadata !"terminal_buffer", metadata !"", metadata !24, i32 60, metadata !106, i32 0, i32 1, i16** @terminal_buffer, null} ; [ DW_TAG_variable ] [terminal_buffer] [line 60] [def]
!106 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, metadata !35} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from uint16_t]
!107 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!108 = metadata !{metadata !"clang version 3.4 (http://llvm.org/git/clang.git 82a2911a94947e20ac4fd961b6322adf74ad9224) (http://llvm.org/git/llvm.git 52244da7f2b3def646900520668b859343b84a33)"}
!109 = metadata !{i32 37, i32 0, metadata !23, null}
!110 = metadata !{i32 38, i32 0, metadata !23, null}
!111 = metadata !{i32 41, i32 0, metadata !32, null}
!112 = metadata !{i32 42, i32 0, metadata !32, null}
!113 = metadata !{i32 44, i32 0, metadata !32, null}
!114 = metadata !{i32 47, i32 0, metadata !43, null}
!115 = metadata !{i32 48, i32 0, metadata !43, null}
!116 = metadata !{i32 49, i32 0, metadata !43, null}
!117 = metadata !{metadata !118, metadata !118, i64 0}
!118 = metadata !{metadata !"omnipotent char", metadata !119, i64 0}
!119 = metadata !{metadata !"Simple C/C++ TBAA"}
!120 = metadata !{i32 50, i32 0, metadata !43, null}
!121 = metadata !{i32 51, i32 0, metadata !43, null}
!122 = metadata !{i32 63, i32 0, metadata !53, null}
!123 = metadata !{metadata !124, metadata !124, i64 0}
!124 = metadata !{metadata !"int", metadata !118, i64 0}
!125 = metadata !{i32 64, i32 0, metadata !53, null}
!126 = metadata !{i32 7}
!127 = metadata !{i32 786689, metadata !23, metadata !"fg", metadata !24, i32 16777253, metadata !3, i32 0, metadata !128} ; [ DW_TAG_arg_variable ] [fg] [line 37]
!128 = metadata !{i32 65, i32 0, metadata !53, null}
!129 = metadata !{i32 37, i32 0, metadata !23, metadata !128}
!130 = metadata !{i32 786689, metadata !23, metadata !"bg", metadata !24, i32 33554469, metadata !3, i32 0, metadata !128} ; [ DW_TAG_arg_variable ] [bg] [line 37]
!131 = metadata !{i32 66, i32 0, metadata !53, null}
!132 = metadata !{metadata !133, metadata !133, i64 0}
!133 = metadata !{metadata !"any pointer", metadata !118, i64 0}
!134 = metadata !{i32 67, i32 0, metadata !58, null}
!135 = metadata !{i32 69, i32 0, metadata !63, null}
!136 = metadata !{i32 68, i32 0, metadata !60, null}
!137 = metadata !{i32 70, i32 0, metadata !63, null}
!138 = metadata !{i8 32}
!139 = metadata !{i32 786689, metadata !32, metadata !"c", metadata !24, i32 16777257, metadata !37, i32 0, metadata !137} ; [ DW_TAG_arg_variable ] [c] [line 41]
!140 = metadata !{i32 41, i32 0, metadata !32, metadata !137}
!141 = metadata !{i32 786689, metadata !32, metadata !"color", metadata !24, i32 33554473, metadata !27, i32 0, metadata !137} ; [ DW_TAG_arg_variable ] [color] [line 41]
!142 = metadata !{i32 786688, metadata !32, metadata !"c16", metadata !24, i32 42, metadata !35, i32 0, metadata !137} ; [ DW_TAG_auto_variable ] [c16] [line 42]
!143 = metadata !{i32 42, i32 0, metadata !32, metadata !137}
!144 = metadata !{i32 44, i32 0, metadata !32, metadata !137}
!145 = metadata !{metadata !146, metadata !146, i64 0}
!146 = metadata !{metadata !"short", metadata !118, i64 0}
!147 = metadata !{i32 73, i32 0, metadata !53, null}
!148 = metadata !{i32 75, i32 0, metadata !65, null}
!149 = metadata !{i32 76, i32 0, metadata !65, null}
!150 = metadata !{i32 77, i32 0, metadata !65, null}
!151 = metadata !{i32 79, i32 0, metadata !70, null}
!152 = metadata !{i32 80, i32 0, metadata !70, null}
!153 = metadata !{i32 786689, metadata !32, metadata !"c", metadata !24, i32 16777257, metadata !37, i32 0, metadata !154} ; [ DW_TAG_arg_variable ] [c] [line 41]
!154 = metadata !{i32 81, i32 0, metadata !70, null}
!155 = metadata !{i32 41, i32 0, metadata !32, metadata !154}
!156 = metadata !{i32 786689, metadata !32, metadata !"color", metadata !24, i32 33554473, metadata !27, i32 0, metadata !154} ; [ DW_TAG_arg_variable ] [color] [line 41]
!157 = metadata !{i32 42, i32 0, metadata !32, metadata !154}
!158 = metadata !{i32 786688, metadata !32, metadata !"c16", metadata !24, i32 42, metadata !35, i32 0, metadata !154} ; [ DW_TAG_auto_variable ] [c16] [line 42]
!159 = metadata !{i32 44, i32 0, metadata !32, metadata !154}
!160 = metadata !{i32 82, i32 0, metadata !70, null}
!161 = metadata !{i32 84, i32 0, metadata !79, null}
!162 = metadata !{i32 86, i32 0, metadata !79, null}
!163 = metadata !{i32 89, i32 0, metadata !164, null}
!164 = metadata !{i32 786443, metadata !1, metadata !79, i32 87, i32 0, i32 4} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!165 = metadata !{i32 90, i32 0, metadata !164, null}
!166 = metadata !{i32 92, i32 0, metadata !164, null}
!167 = metadata !{i32 93, i32 0, metadata !164, null}
!168 = metadata !{i32 95, i32 0, metadata !164, null}
!169 = metadata !{i32 96, i32 0, metadata !164, null}
!170 = metadata !{i32 104, i32 0, metadata !79, null}
!171 = metadata !{i32 105, i32 0, metadata !85, null}
!172 = metadata !{i32 786689, metadata !79, metadata !"c", metadata !24, i32 16777300, metadata !37, i32 0, metadata !173} ; [ DW_TAG_arg_variable ] [c] [line 84]
!173 = metadata !{i32 107, i32 0, metadata !174, null}
!174 = metadata !{i32 786443, metadata !1, metadata !85, i32 107, i32 0, i32 5} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!175 = metadata !{i32 84, i32 0, metadata !79, metadata !173}
!176 = metadata !{i32 86, i32 0, metadata !79, metadata !173}
!177 = metadata !{i32 89, i32 0, metadata !164, metadata !173}
!178 = metadata !{i32 90, i32 0, metadata !164, metadata !173}
!179 = metadata !{i32 92, i32 0, metadata !164, metadata !173}
!180 = metadata !{i32 93, i32 0, metadata !164, metadata !173}
!181 = metadata !{i32 95, i32 0, metadata !164, metadata !173}
!182 = metadata !{i32 96, i32 0, metadata !164, metadata !173}
!183 = metadata !{i32 111, i32 0, metadata !85, null}
!184 = metadata !{i32 786689, metadata !70, metadata !"c", metadata !24, i32 16777295, metadata !37, i32 0, metadata !183} ; [ DW_TAG_arg_variable ] [c] [line 79]
!185 = metadata !{i32 79, i32 0, metadata !70, metadata !183}
!186 = metadata !{i32 786689, metadata !70, metadata !"color", metadata !24, i32 33554511, metadata !27, i32 0, metadata !183} ; [ DW_TAG_arg_variable ] [color] [line 79]
!187 = metadata !{i32 786689, metadata !70, metadata !"x", metadata !24, i32 50331727, metadata !46, i32 0, metadata !183} ; [ DW_TAG_arg_variable ] [x] [line 79]
!188 = metadata !{i32 786689, metadata !70, metadata !"y", metadata !24, i32 67108943, metadata !46, i32 0, metadata !183} ; [ DW_TAG_arg_variable ] [y] [line 79]
!189 = metadata !{i32 80, i32 0, metadata !70, metadata !183}
!190 = metadata !{i32 786688, metadata !70, metadata !"index", metadata !24, i32 80, metadata !64, i32 0, metadata !183} ; [ DW_TAG_auto_variable ] [index] [line 80]
!191 = metadata !{i32 786689, metadata !32, metadata !"c", metadata !24, i32 16777257, metadata !37, i32 0, metadata !192} ; [ DW_TAG_arg_variable ] [c] [line 41]
!192 = metadata !{i32 81, i32 0, metadata !70, metadata !183}
!193 = metadata !{i32 41, i32 0, metadata !32, metadata !192}
!194 = metadata !{i32 786689, metadata !32, metadata !"color", metadata !24, i32 33554473, metadata !27, i32 0, metadata !192} ; [ DW_TAG_arg_variable ] [color] [line 41]
!195 = metadata !{i32 42, i32 0, metadata !32, metadata !192}
!196 = metadata !{i32 786688, metadata !32, metadata !"c16", metadata !24, i32 42, metadata !35, i32 0, metadata !192} ; [ DW_TAG_auto_variable ] [c16] [line 42]
!197 = metadata !{i32 44, i32 0, metadata !32, metadata !192}
!198 = metadata !{i32 112, i32 0, metadata !199, null}
!199 = metadata !{i32 786443, metadata !1, metadata !85, i32 112, i32 0, i32 7} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!200 = metadata !{i32 113, i32 0, metadata !201, null}
!201 = metadata !{i32 786443, metadata !1, metadata !199, i32 112, i32 0, i32 8} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!202 = metadata !{i32 114, i32 0, metadata !203, null}
!203 = metadata !{i32 786443, metadata !1, metadata !201, i32 114, i32 0, i32 9} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!204 = metadata !{i32 115, i32 0, metadata !205, null}
!205 = metadata !{i32 786443, metadata !1, metadata !203, i32 114, i32 0, i32 10} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!206 = metadata !{i32 117, i32 0, metadata !201, null}
!207 = metadata !{i32 118, i32 0, metadata !85, null}
!208 = metadata !{i32 120, i32 0, metadata !90, null}
!209 = metadata !{i32 786689, metadata !43, metadata !"str", metadata !24, i32 16777263, metadata !48, i32 0, metadata !210} ; [ DW_TAG_arg_variable ] [str] [line 47]
!210 = metadata !{i32 121, i32 0, metadata !90, null}
!211 = metadata !{i32 47, i32 0, metadata !43, metadata !210}
!212 = metadata !{i32 786688, metadata !43, metadata !"ret", metadata !24, i32 48, metadata !46, i32 0, metadata !210} ; [ DW_TAG_auto_variable ] [ret] [line 48]
!213 = metadata !{i32 48, i32 0, metadata !43, metadata !210}
!214 = metadata !{i32 49, i32 0, metadata !43, metadata !210}
!215 = metadata !{i32 50, i32 0, metadata !43, metadata !210}
!216 = metadata !{i32 122, i32 0, metadata !97, null}
!217 = metadata !{i32 123, i32 0, metadata !97, null}
!218 = metadata !{i32 786689, metadata !85, metadata !"c", metadata !24, i32 16777321, metadata !37, i32 0, metadata !217} ; [ DW_TAG_arg_variable ] [c] [line 105]
!219 = metadata !{i32 105, i32 0, metadata !85, metadata !217}
!220 = metadata !{i32 786689, metadata !79, metadata !"c", metadata !24, i32 16777300, metadata !37, i32 0, metadata !221} ; [ DW_TAG_arg_variable ] [c] [line 84]
!221 = metadata !{i32 107, i32 0, metadata !174, metadata !217}
!222 = metadata !{i32 84, i32 0, metadata !79, metadata !221}
!223 = metadata !{i32 86, i32 0, metadata !79, metadata !221}
!224 = metadata !{i32 89, i32 0, metadata !164, metadata !221}
!225 = metadata !{i32 90, i32 0, metadata !164, metadata !221}
!226 = metadata !{i32 92, i32 0, metadata !164, metadata !221}
!227 = metadata !{i32 93, i32 0, metadata !164, metadata !221}
!228 = metadata !{i32 95, i32 0, metadata !164, metadata !221}
!229 = metadata !{i32 96, i32 0, metadata !164, metadata !221}
!230 = metadata !{i32 111, i32 0, metadata !85, metadata !217}
!231 = metadata !{i32 786689, metadata !70, metadata !"c", metadata !24, i32 16777295, metadata !37, i32 0, metadata !230} ; [ DW_TAG_arg_variable ] [c] [line 79]
!232 = metadata !{i32 79, i32 0, metadata !70, metadata !230}
!233 = metadata !{i32 786689, metadata !70, metadata !"color", metadata !24, i32 33554511, metadata !27, i32 0, metadata !230} ; [ DW_TAG_arg_variable ] [color] [line 79]
!234 = metadata !{i32 786689, metadata !70, metadata !"x", metadata !24, i32 50331727, metadata !46, i32 0, metadata !230} ; [ DW_TAG_arg_variable ] [x] [line 79]
!235 = metadata !{i32 786689, metadata !70, metadata !"y", metadata !24, i32 67108943, metadata !46, i32 0, metadata !230} ; [ DW_TAG_arg_variable ] [y] [line 79]
!236 = metadata !{i32 80, i32 0, metadata !70, metadata !230}
!237 = metadata !{i32 786688, metadata !70, metadata !"index", metadata !24, i32 80, metadata !64, i32 0, metadata !230} ; [ DW_TAG_auto_variable ] [index] [line 80]
!238 = metadata !{i32 786689, metadata !32, metadata !"c", metadata !24, i32 16777257, metadata !37, i32 0, metadata !239} ; [ DW_TAG_arg_variable ] [c] [line 41]
!239 = metadata !{i32 81, i32 0, metadata !70, metadata !230}
!240 = metadata !{i32 41, i32 0, metadata !32, metadata !239}
!241 = metadata !{i32 786689, metadata !32, metadata !"color", metadata !24, i32 33554473, metadata !27, i32 0, metadata !239} ; [ DW_TAG_arg_variable ] [color] [line 41]
!242 = metadata !{i32 42, i32 0, metadata !32, metadata !239}
!243 = metadata !{i32 786688, metadata !32, metadata !"c16", metadata !24, i32 42, metadata !35, i32 0, metadata !239} ; [ DW_TAG_auto_variable ] [c16] [line 42]
!244 = metadata !{i32 44, i32 0, metadata !32, metadata !239}
!245 = metadata !{i32 112, i32 0, metadata !199, metadata !217}
!246 = metadata !{i32 113, i32 0, metadata !201, metadata !217}
!247 = metadata !{i32 114, i32 0, metadata !203, metadata !217}
!248 = metadata !{i32 115, i32 0, metadata !205, metadata !217}
!249 = metadata !{i32 117, i32 0, metadata !201, metadata !217}
!250 = metadata !{i32 124, i32 0, metadata !90, null}
!251 = metadata !{i32 63, i32 0, metadata !53, metadata !252}
!252 = metadata !{i32 131, i32 0, metadata !98, null}
!253 = metadata !{i32 64, i32 0, metadata !53, metadata !252}
!254 = metadata !{i32 786689, metadata !23, metadata !"fg", metadata !24, i32 16777253, metadata !3, i32 0, metadata !255} ; [ DW_TAG_arg_variable ] [fg] [line 37]
!255 = metadata !{i32 65, i32 0, metadata !53, metadata !252}
!256 = metadata !{i32 37, i32 0, metadata !23, metadata !255}
!257 = metadata !{i32 786689, metadata !23, metadata !"bg", metadata !24, i32 33554469, metadata !3, i32 0, metadata !255} ; [ DW_TAG_arg_variable ] [bg] [line 37]
!258 = metadata !{i32 66, i32 0, metadata !53, metadata !252}
!259 = metadata !{i32 786688, metadata !58, metadata !"y", metadata !24, i32 67, metadata !46, i32 0, metadata !252} ; [ DW_TAG_auto_variable ] [y] [line 67]
!260 = metadata !{i32 67, i32 0, metadata !58, metadata !252}
!261 = metadata !{i32 69, i32 0, metadata !63, metadata !252}
!262 = metadata !{i32 68, i32 0, metadata !60, metadata !252}
!263 = metadata !{i32 786688, metadata !63, metadata !"index", metadata !24, i32 69, metadata !64, i32 0, metadata !252} ; [ DW_TAG_auto_variable ] [index] [line 69]
!264 = metadata !{i32 70, i32 0, metadata !63, metadata !252}
!265 = metadata !{i32 786689, metadata !32, metadata !"c", metadata !24, i32 16777257, metadata !37, i32 0, metadata !264} ; [ DW_TAG_arg_variable ] [c] [line 41]
!266 = metadata !{i32 41, i32 0, metadata !32, metadata !264}
!267 = metadata !{i32 786689, metadata !32, metadata !"color", metadata !24, i32 33554473, metadata !27, i32 0, metadata !264} ; [ DW_TAG_arg_variable ] [color] [line 41]
!268 = metadata !{i32 786688, metadata !32, metadata !"c16", metadata !24, i32 42, metadata !35, i32 0, metadata !264} ; [ DW_TAG_auto_variable ] [c16] [line 42]
!269 = metadata !{i32 42, i32 0, metadata !32, metadata !264}
!270 = metadata !{i32 44, i32 0, metadata !32, metadata !264}
!271 = metadata !{i32 786688, metadata !60, metadata !"x", metadata !24, i32 68, metadata !46, i32 0, metadata !252} ; [ DW_TAG_auto_variable ] [x] [line 68]
!272 = metadata !{i32 123, i32 0, metadata !97, metadata !273}
!273 = metadata !{i32 137, i32 0, metadata !98, null}
!274 = metadata !{i32 786689, metadata !85, metadata !"c", metadata !24, i32 16777321, metadata !37, i32 0, metadata !272} ; [ DW_TAG_arg_variable ] [c] [line 105]
!275 = metadata !{i32 105, i32 0, metadata !85, metadata !272}
!276 = metadata !{i32 786689, metadata !79, metadata !"c", metadata !24, i32 16777300, metadata !37, i32 0, metadata !277} ; [ DW_TAG_arg_variable ] [c] [line 84]
!277 = metadata !{i32 107, i32 0, metadata !174, metadata !272}
!278 = metadata !{i32 84, i32 0, metadata !79, metadata !277}
!279 = metadata !{i32 86, i32 0, metadata !79, metadata !277}
!280 = metadata !{i32 89, i32 0, metadata !164, metadata !277}
!281 = metadata !{i32 90, i32 0, metadata !164, metadata !277}
!282 = metadata !{i32 92, i32 0, metadata !164, metadata !277}
!283 = metadata !{i32 93, i32 0, metadata !164, metadata !277}
!284 = metadata !{i32 95, i32 0, metadata !164, metadata !277}
!285 = metadata !{i32 96, i32 0, metadata !164, metadata !277}
!286 = metadata !{i32 111, i32 0, metadata !85, metadata !272}
!287 = metadata !{i32 786689, metadata !70, metadata !"c", metadata !24, i32 16777295, metadata !37, i32 0, metadata !286} ; [ DW_TAG_arg_variable ] [c] [line 79]
!288 = metadata !{i32 79, i32 0, metadata !70, metadata !286}
!289 = metadata !{i32 786689, metadata !70, metadata !"color", metadata !24, i32 33554511, metadata !27, i32 0, metadata !286} ; [ DW_TAG_arg_variable ] [color] [line 79]
!290 = metadata !{i32 786689, metadata !70, metadata !"x", metadata !24, i32 50331727, metadata !46, i32 0, metadata !286} ; [ DW_TAG_arg_variable ] [x] [line 79]
!291 = metadata !{i32 786689, metadata !70, metadata !"y", metadata !24, i32 67108943, metadata !46, i32 0, metadata !286} ; [ DW_TAG_arg_variable ] [y] [line 79]
!292 = metadata !{i32 80, i32 0, metadata !70, metadata !286}
!293 = metadata !{i32 786688, metadata !70, metadata !"index", metadata !24, i32 80, metadata !64, i32 0, metadata !286} ; [ DW_TAG_auto_variable ] [index] [line 80]
!294 = metadata !{i32 786689, metadata !32, metadata !"c", metadata !24, i32 16777257, metadata !37, i32 0, metadata !295} ; [ DW_TAG_arg_variable ] [c] [line 41]
!295 = metadata !{i32 81, i32 0, metadata !70, metadata !286}
!296 = metadata !{i32 41, i32 0, metadata !32, metadata !295}
!297 = metadata !{i32 786689, metadata !32, metadata !"color", metadata !24, i32 33554473, metadata !27, i32 0, metadata !295} ; [ DW_TAG_arg_variable ] [color] [line 41]
!298 = metadata !{i32 42, i32 0, metadata !32, metadata !295}
!299 = metadata !{i32 786688, metadata !32, metadata !"c16", metadata !24, i32 42, metadata !35, i32 0, metadata !295} ; [ DW_TAG_auto_variable ] [c16] [line 42]
!300 = metadata !{i32 44, i32 0, metadata !32, metadata !295}
!301 = metadata !{i32 112, i32 0, metadata !199, metadata !272}
!302 = metadata !{i32 113, i32 0, metadata !201, metadata !272}
!303 = metadata !{i32 114, i32 0, metadata !203, metadata !272}
!304 = metadata !{i32 115, i32 0, metadata !205, metadata !272}
!305 = metadata !{i32 117, i32 0, metadata !201, metadata !272}
!306 = metadata !{i32 122, i32 0, metadata !97, metadata !273}
!307 = metadata !{i32 786688, metadata !97, metadata !"i", metadata !24, i32 122, metadata !46, i32 0, metadata !273} ; [ DW_TAG_auto_variable ] [i] [line 122]
!308 = metadata !{i32 138, i32 0, metadata !98, null}
