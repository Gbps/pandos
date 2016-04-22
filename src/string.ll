; ModuleID = 'src/string.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i686-pc-none-elf"

@.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1

; Function Attrs: nounwind
define i8* @memmove(i8* %dstptr, i8* %srcptr, i32 %size) #0 {
entry:
  %dstptr.addr = alloca i8*, align 4
  %srcptr.addr = alloca i8*, align 4
  %size.addr = alloca i32, align 4
  %dst = alloca i8*, align 4
  %src = alloca i8*, align 4
  %i = alloca i32, align 4
  %i3 = alloca i32, align 4
  store i8* %dstptr, i8** %dstptr.addr, align 4
  call void @llvm.dbg.declare(metadata !{i8** %dstptr.addr}, metadata !46), !dbg !47
  store i8* %srcptr, i8** %srcptr.addr, align 4
  call void @llvm.dbg.declare(metadata !{i8** %srcptr.addr}, metadata !48), !dbg !47
  store i32 %size, i32* %size.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %size.addr}, metadata !49), !dbg !47
  call void @llvm.dbg.declare(metadata !{i8** %dst}, metadata !50), !dbg !53
  %0 = load i8** %dstptr.addr, align 4, !dbg !53
  store i8* %0, i8** %dst, align 4, !dbg !53
  call void @llvm.dbg.declare(metadata !{i8** %src}, metadata !54), !dbg !57
  %1 = load i8** %srcptr.addr, align 4, !dbg !57
  store i8* %1, i8** %src, align 4, !dbg !57
  %2 = load i8** %dst, align 4, !dbg !58
  %3 = load i8** %src, align 4, !dbg !58
  %cmp = icmp ult i8* %2, %3, !dbg !58
  br i1 %cmp, label %if.then, label %if.else, !dbg !58

if.then:                                          ; preds = %entry
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !60), !dbg !62
  store i32 0, i32* %i, align 4, !dbg !62
  br label %for.cond, !dbg !62

for.cond:                                         ; preds = %for.inc, %if.then
  %4 = load i32* %i, align 4, !dbg !62
  %5 = load i32* %size.addr, align 4, !dbg !62
  %cmp1 = icmp ult i32 %4, %5, !dbg !62
  br i1 %cmp1, label %for.body, label %for.end, !dbg !62

for.body:                                         ; preds = %for.cond
  %6 = load i32* %i, align 4, !dbg !63
  %7 = load i8** %src, align 4, !dbg !63
  %arrayidx = getelementptr inbounds i8* %7, i32 %6, !dbg !63
  %8 = load i8* %arrayidx, align 1, !dbg !63
  %9 = load i32* %i, align 4, !dbg !63
  %10 = load i8** %dst, align 4, !dbg !63
  %arrayidx2 = getelementptr inbounds i8* %10, i32 %9, !dbg !63
  store i8 %8, i8* %arrayidx2, align 1, !dbg !63
  br label %for.inc, !dbg !63

for.inc:                                          ; preds = %for.body
  %11 = load i32* %i, align 4, !dbg !62
  %inc = add i32 %11, 1, !dbg !62
  store i32 %inc, i32* %i, align 4, !dbg !62
  br label %for.cond, !dbg !62

for.end:                                          ; preds = %for.cond
  br label %if.end, !dbg !63

if.else:                                          ; preds = %entry
  call void @llvm.dbg.declare(metadata !{i32* %i3}, metadata !64), !dbg !66
  %12 = load i32* %size.addr, align 4, !dbg !66
  store i32 %12, i32* %i3, align 4, !dbg !66
  br label %for.cond4, !dbg !66

for.cond4:                                        ; preds = %for.inc10, %if.else
  %13 = load i32* %i3, align 4, !dbg !66
  %cmp5 = icmp ne i32 %13, 0, !dbg !66
  br i1 %cmp5, label %for.body6, label %for.end11, !dbg !66

for.body6:                                        ; preds = %for.cond4
  %14 = load i32* %i3, align 4, !dbg !67
  %sub = sub i32 %14, 1, !dbg !67
  %15 = load i8** %src, align 4, !dbg !67
  %arrayidx7 = getelementptr inbounds i8* %15, i32 %sub, !dbg !67
  %16 = load i8* %arrayidx7, align 1, !dbg !67
  %17 = load i32* %i3, align 4, !dbg !67
  %sub8 = sub i32 %17, 1, !dbg !67
  %18 = load i8** %dst, align 4, !dbg !67
  %arrayidx9 = getelementptr inbounds i8* %18, i32 %sub8, !dbg !67
  store i8 %16, i8* %arrayidx9, align 1, !dbg !67
  br label %for.inc10, !dbg !67

for.inc10:                                        ; preds = %for.body6
  %19 = load i32* %i3, align 4, !dbg !66
  %dec = add i32 %19, -1, !dbg !66
  store i32 %dec, i32* %i3, align 4, !dbg !66
  br label %for.cond4, !dbg !66

for.end11:                                        ; preds = %for.cond4
  br label %if.end

if.end:                                           ; preds = %for.end11, %for.end
  %20 = load i8** %dstptr.addr, align 4, !dbg !68
  ret i8* %20, !dbg !68
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

; Function Attrs: nounwind
define i32 @strlen(i8* %string) #0 {
entry:
  %string.addr = alloca i8*, align 4
  %result = alloca i32, align 4
  store i8* %string, i8** %string.addr, align 4
  call void @llvm.dbg.declare(metadata !{i8** %string.addr}, metadata !69), !dbg !70
  call void @llvm.dbg.declare(metadata !{i32* %result}, metadata !71), !dbg !72
  store i32 0, i32* %result, align 4, !dbg !72
  br label %while.cond, !dbg !73

while.cond:                                       ; preds = %while.body, %entry
  %0 = load i32* %result, align 4, !dbg !73
  %1 = load i8** %string.addr, align 4, !dbg !73
  %arrayidx = getelementptr inbounds i8* %1, i32 %0, !dbg !73
  %2 = load i8* %arrayidx, align 1, !dbg !73
  %tobool = icmp ne i8 %2, 0, !dbg !73
  br i1 %tobool, label %while.body, label %while.end, !dbg !73

while.body:                                       ; preds = %while.cond
  %3 = load i32* %result, align 4, !dbg !74
  %inc = add i32 %3, 1, !dbg !74
  store i32 %inc, i32* %result, align 4, !dbg !74
  br label %while.cond, !dbg !74

while.end:                                        ; preds = %while.cond
  %4 = load i32* %result, align 4, !dbg !75
  ret i32 %4, !dbg !75
}

; Function Attrs: nounwind
define i32 @memcmp(i8* %aptr, i8* %bptr, i32 %size) #0 {
entry:
  %retval = alloca i32, align 4
  %aptr.addr = alloca i8*, align 4
  %bptr.addr = alloca i8*, align 4
  %size.addr = alloca i32, align 4
  %a = alloca i8*, align 4
  %b = alloca i8*, align 4
  %i = alloca i32, align 4
  store i8* %aptr, i8** %aptr.addr, align 4
  call void @llvm.dbg.declare(metadata !{i8** %aptr.addr}, metadata !76), !dbg !77
  store i8* %bptr, i8** %bptr.addr, align 4
  call void @llvm.dbg.declare(metadata !{i8** %bptr.addr}, metadata !78), !dbg !77
  store i32 %size, i32* %size.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %size.addr}, metadata !79), !dbg !77
  call void @llvm.dbg.declare(metadata !{i8** %a}, metadata !80), !dbg !81
  %0 = load i8** %aptr.addr, align 4, !dbg !81
  store i8* %0, i8** %a, align 4, !dbg !81
  call void @llvm.dbg.declare(metadata !{i8** %b}, metadata !82), !dbg !83
  %1 = load i8** %bptr.addr, align 4, !dbg !83
  store i8* %1, i8** %b, align 4, !dbg !83
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !84), !dbg !86
  store i32 0, i32* %i, align 4, !dbg !86
  br label %for.cond, !dbg !86

for.cond:                                         ; preds = %for.inc, %entry
  %2 = load i32* %i, align 4, !dbg !86
  %3 = load i32* %size.addr, align 4, !dbg !86
  %cmp = icmp ult i32 %2, %3, !dbg !86
  br i1 %cmp, label %for.body, label %for.end, !dbg !86

for.body:                                         ; preds = %for.cond
  %4 = load i32* %i, align 4, !dbg !87
  %5 = load i8** %a, align 4, !dbg !87
  %arrayidx = getelementptr inbounds i8* %5, i32 %4, !dbg !87
  %6 = load i8* %arrayidx, align 1, !dbg !87
  %conv = zext i8 %6 to i32, !dbg !87
  %7 = load i32* %i, align 4, !dbg !87
  %8 = load i8** %b, align 4, !dbg !87
  %arrayidx1 = getelementptr inbounds i8* %8, i32 %7, !dbg !87
  %9 = load i8* %arrayidx1, align 1, !dbg !87
  %conv2 = zext i8 %9 to i32, !dbg !87
  %cmp3 = icmp slt i32 %conv, %conv2, !dbg !87
  br i1 %cmp3, label %if.then, label %if.else, !dbg !87

if.then:                                          ; preds = %for.body
  store i32 -1, i32* %retval, !dbg !89
  br label %return, !dbg !89

if.else:                                          ; preds = %for.body
  %10 = load i32* %i, align 4, !dbg !90
  %11 = load i8** %b, align 4, !dbg !90
  %arrayidx5 = getelementptr inbounds i8* %11, i32 %10, !dbg !90
  %12 = load i8* %arrayidx5, align 1, !dbg !90
  %conv6 = zext i8 %12 to i32, !dbg !90
  %13 = load i32* %i, align 4, !dbg !90
  %14 = load i8** %a, align 4, !dbg !90
  %arrayidx7 = getelementptr inbounds i8* %14, i32 %13, !dbg !90
  %15 = load i8* %arrayidx7, align 1, !dbg !90
  %conv8 = zext i8 %15 to i32, !dbg !90
  %cmp9 = icmp slt i32 %conv6, %conv8, !dbg !90
  br i1 %cmp9, label %if.then11, label %if.end, !dbg !90

if.then11:                                        ; preds = %if.else
  store i32 1, i32* %retval, !dbg !92
  br label %return, !dbg !92

if.end:                                           ; preds = %if.else
  br label %if.end12

if.end12:                                         ; preds = %if.end
  br label %for.inc, !dbg !93

for.inc:                                          ; preds = %if.end12
  %16 = load i32* %i, align 4, !dbg !86
  %inc = add i32 %16, 1, !dbg !86
  store i32 %inc, i32* %i, align 4, !dbg !86
  br label %for.cond, !dbg !86

for.end:                                          ; preds = %for.cond
  store i32 0, i32* %retval, !dbg !94
  br label %return, !dbg !94

return:                                           ; preds = %for.end, %if.then11, %if.then
  %17 = load i32* %retval, !dbg !95
  ret i32 %17, !dbg !95
}

; Function Attrs: nounwind
define i8* @memset(i8* %bufptr, i32 %value, i32 %size) #0 {
entry:
  %bufptr.addr = alloca i8*, align 4
  %value.addr = alloca i32, align 4
  %size.addr = alloca i32, align 4
  %buf = alloca i8*, align 4
  %i = alloca i32, align 4
  store i8* %bufptr, i8** %bufptr.addr, align 4
  call void @llvm.dbg.declare(metadata !{i8** %bufptr.addr}, metadata !96), !dbg !97
  store i32 %value, i32* %value.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %value.addr}, metadata !98), !dbg !97
  store i32 %size, i32* %size.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %size.addr}, metadata !99), !dbg !97
  call void @llvm.dbg.declare(metadata !{i8** %buf}, metadata !100), !dbg !101
  %0 = load i8** %bufptr.addr, align 4, !dbg !101
  store i8* %0, i8** %buf, align 4, !dbg !101
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !102), !dbg !104
  store i32 0, i32* %i, align 4, !dbg !104
  br label %for.cond, !dbg !104

for.cond:                                         ; preds = %for.inc, %entry
  %1 = load i32* %i, align 4, !dbg !104
  %2 = load i32* %size.addr, align 4, !dbg !104
  %cmp = icmp ult i32 %1, %2, !dbg !104
  br i1 %cmp, label %for.body, label %for.end, !dbg !104

for.body:                                         ; preds = %for.cond
  %3 = load i32* %value.addr, align 4, !dbg !105
  %conv = trunc i32 %3 to i8, !dbg !105
  %4 = load i32* %i, align 4, !dbg !105
  %5 = load i8** %buf, align 4, !dbg !105
  %arrayidx = getelementptr inbounds i8* %5, i32 %4, !dbg !105
  store i8 %conv, i8* %arrayidx, align 1, !dbg !105
  br label %for.inc, !dbg !105

for.inc:                                          ; preds = %for.body
  %6 = load i32* %i, align 4, !dbg !104
  %inc = add i32 %6, 1, !dbg !104
  store i32 %inc, i32* %i, align 4, !dbg !104
  br label %for.cond, !dbg !104

for.end:                                          ; preds = %for.cond
  %7 = load i8** %bufptr.addr, align 4, !dbg !106
  ret i8* %7, !dbg !106
}

; Function Attrs: nounwind
define i8* @memcpy(i8* noalias %dstptr, i8* noalias %srcptr, i32 %size) #0 {
entry:
  %dstptr.addr = alloca i8*, align 4
  %srcptr.addr = alloca i8*, align 4
  %size.addr = alloca i32, align 4
  %dst = alloca i8*, align 4
  %src = alloca i8*, align 4
  %i = alloca i32, align 4
  store i8* %dstptr, i8** %dstptr.addr, align 4
  call void @llvm.dbg.declare(metadata !{i8** %dstptr.addr}, metadata !107), !dbg !108
  store i8* %srcptr, i8** %srcptr.addr, align 4
  call void @llvm.dbg.declare(metadata !{i8** %srcptr.addr}, metadata !109), !dbg !108
  store i32 %size, i32* %size.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %size.addr}, metadata !110), !dbg !108
  call void @llvm.dbg.declare(metadata !{i8** %dst}, metadata !111), !dbg !112
  %0 = load i8** %dstptr.addr, align 4, !dbg !112
  store i8* %0, i8** %dst, align 4, !dbg !112
  call void @llvm.dbg.declare(metadata !{i8** %src}, metadata !113), !dbg !114
  %1 = load i8** %srcptr.addr, align 4, !dbg !114
  store i8* %1, i8** %src, align 4, !dbg !114
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !115), !dbg !117
  store i32 0, i32* %i, align 4, !dbg !117
  br label %for.cond, !dbg !117

for.cond:                                         ; preds = %for.inc, %entry
  %2 = load i32* %i, align 4, !dbg !117
  %3 = load i32* %size.addr, align 4, !dbg !117
  %cmp = icmp ult i32 %2, %3, !dbg !117
  br i1 %cmp, label %for.body, label %for.end, !dbg !117

for.body:                                         ; preds = %for.cond
  %4 = load i32* %i, align 4, !dbg !118
  %5 = load i8** %src, align 4, !dbg !118
  %arrayidx = getelementptr inbounds i8* %5, i32 %4, !dbg !118
  %6 = load i8* %arrayidx, align 1, !dbg !118
  %7 = load i32* %i, align 4, !dbg !118
  %8 = load i8** %dst, align 4, !dbg !118
  %arrayidx1 = getelementptr inbounds i8* %8, i32 %7, !dbg !118
  store i8 %6, i8* %arrayidx1, align 1, !dbg !118
  br label %for.inc, !dbg !118

for.inc:                                          ; preds = %for.body
  %9 = load i32* %i, align 4, !dbg !117
  %inc = add i32 %9, 1, !dbg !117
  store i32 %inc, i32* %i, align 4, !dbg !117
  br label %for.cond, !dbg !117

for.end:                                          ; preds = %for.cond
  %10 = load i8** %dstptr.addr, align 4, !dbg !119
  ret i8* %10, !dbg !119
}

; Function Attrs: nounwind
define i32 @puts(i8* %string) #0 {
entry:
  %string.addr = alloca i8*, align 4
  store i8* %string, i8** %string.addr, align 4
  call void @llvm.dbg.declare(metadata !{i8** %string.addr}, metadata !120), !dbg !121
  %0 = load i8** %string.addr, align 4, !dbg !122
  %call = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str, i32 0, i32 0), i8* %0) #4, !dbg !122
  ret i32 %call, !dbg !122
}

; Function Attrs: nounwind
define i32 @printf(i8* noalias %format, ...) #0 {
entry:
  %format.addr = alloca i8*, align 4
  %parameters = alloca i8*, align 4
  %written = alloca i32, align 4
  %amount = alloca i32, align 4
  %rejected_bad_specifier = alloca i8, align 1
  %format_begun_at = alloca i8*, align 4
  %c = alloca i8, align 1
  %s = alloca i8*, align 4
  %x = alloca i32, align 4
  %res = alloca [5 x i8], align 1
  store i8* %format, i8** %format.addr, align 4
  call void @llvm.dbg.declare(metadata !{i8** %format.addr}, metadata !123), !dbg !124
  call void @llvm.dbg.declare(metadata !{i8** %parameters}, metadata !125), !dbg !129
  %parameters1 = bitcast i8** %parameters to i8*, !dbg !130
  call void @llvm.va_start(i8* %parameters1), !dbg !130
  call void @llvm.dbg.declare(metadata !{i32* %written}, metadata !131), !dbg !132
  store i32 0, i32* %written, align 4, !dbg !132
  call void @llvm.dbg.declare(metadata !{i32* %amount}, metadata !133), !dbg !134
  call void @llvm.dbg.declare(metadata !{i8* %rejected_bad_specifier}, metadata !135), !dbg !137
  store i8 0, i8* %rejected_bad_specifier, align 1, !dbg !137
  br label %while.cond, !dbg !138

while.cond:                                       ; preds = %if.end139, %while.end, %entry
  %0 = load i8** %format.addr, align 4, !dbg !138
  %1 = load i8* %0, align 1, !dbg !138
  %conv = sext i8 %1 to i32, !dbg !138
  %cmp = icmp ne i32 %conv, 0, !dbg !138
  br i1 %cmp, label %while.body, label %while.end140, !dbg !138

while.body:                                       ; preds = %while.cond
  %2 = load i8** %format.addr, align 4, !dbg !139
  %3 = load i8* %2, align 1, !dbg !139
  %conv3 = sext i8 %3 to i32, !dbg !139
  %cmp4 = icmp ne i32 %conv3, 37, !dbg !139
  br i1 %cmp4, label %if.then, label %if.end, !dbg !139

if.then:                                          ; preds = %while.body
  br label %print_c, !dbg !142

print_c:                                          ; preds = %incomprehensible_conversion, %if.then16, %if.then
  store i32 1, i32* %amount, align 4, !dbg !144
  br label %while.cond6, !dbg !145

while.cond6:                                      ; preds = %while.body12, %print_c
  %4 = load i32* %amount, align 4, !dbg !145
  %5 = load i8** %format.addr, align 4, !dbg !145
  %arrayidx = getelementptr inbounds i8* %5, i32 %4, !dbg !145
  %6 = load i8* %arrayidx, align 1, !dbg !145
  %conv7 = sext i8 %6 to i32, !dbg !145
  %tobool = icmp ne i32 %conv7, 0, !dbg !145
  br i1 %tobool, label %land.rhs, label %land.end, !dbg !145

land.rhs:                                         ; preds = %while.cond6
  %7 = load i32* %amount, align 4, !dbg !145
  %8 = load i8** %format.addr, align 4, !dbg !145
  %arrayidx8 = getelementptr inbounds i8* %8, i32 %7, !dbg !145
  %9 = load i8* %arrayidx8, align 1, !dbg !145
  %conv9 = sext i8 %9 to i32, !dbg !145
  %cmp10 = icmp ne i32 %conv9, 37, !dbg !145
  br label %land.end

land.end:                                         ; preds = %land.rhs, %while.cond6
  %10 = phi i1 [ false, %while.cond6 ], [ %cmp10, %land.rhs ]
  br i1 %10, label %while.body12, label %while.end

while.body12:                                     ; preds = %land.end
  %11 = load i32* %amount, align 4, !dbg !146
  %inc = add i32 %11, 1, !dbg !146
  store i32 %inc, i32* %amount, align 4, !dbg !146
  br label %while.cond6, !dbg !146

while.end:                                        ; preds = %land.end
  %12 = load i8** %format.addr, align 4, !dbg !147
  %13 = load i32* %amount, align 4, !dbg !147
  call void @print(i8* %12, i32 %13) #4, !dbg !147
  %14 = load i32* %amount, align 4, !dbg !148
  %15 = load i8** %format.addr, align 4, !dbg !148
  %add.ptr = getelementptr inbounds i8* %15, i32 %14, !dbg !148
  store i8* %add.ptr, i8** %format.addr, align 4, !dbg !148
  %16 = load i32* %amount, align 4, !dbg !149
  %17 = load i32* %written, align 4, !dbg !149
  %add = add i32 %17, %16, !dbg !149
  store i32 %add, i32* %written, align 4, !dbg !149
  br label %while.cond, !dbg !150

if.end:                                           ; preds = %while.body
  call void @llvm.dbg.declare(metadata !{i8** %format_begun_at}, metadata !151), !dbg !152
  %18 = load i8** %format.addr, align 4, !dbg !152
  store i8* %18, i8** %format_begun_at, align 4, !dbg !152
  %19 = load i8** %format.addr, align 4, !dbg !153
  %incdec.ptr = getelementptr inbounds i8* %19, i32 1, !dbg !153
  store i8* %incdec.ptr, i8** %format.addr, align 4, !dbg !153
  %20 = load i8* %incdec.ptr, align 1, !dbg !153
  %conv13 = sext i8 %20 to i32, !dbg !153
  %cmp14 = icmp eq i32 %conv13, 37, !dbg !153
  br i1 %cmp14, label %if.then16, label %if.end17, !dbg !153

if.then16:                                        ; preds = %if.end
  br label %print_c, !dbg !155

if.end17:                                         ; preds = %if.end
  %21 = load i8* %rejected_bad_specifier, align 1, !dbg !156
  %tobool18 = trunc i8 %21 to i1, !dbg !156
  br i1 %tobool18, label %if.then19, label %if.end20, !dbg !156

if.then19:                                        ; preds = %if.end17
  br label %incomprehensible_conversion, !dbg !158

incomprehensible_conversion:                      ; preds = %if.else136, %if.then19
  store i8 1, i8* %rejected_bad_specifier, align 1, !dbg !160
  %22 = load i8** %format_begun_at, align 4, !dbg !161
  store i8* %22, i8** %format.addr, align 4, !dbg !161
  br label %print_c, !dbg !162

if.end20:                                         ; preds = %if.end17
  %23 = load i8** %format.addr, align 4, !dbg !163
  %24 = load i8* %23, align 1, !dbg !163
  %conv21 = sext i8 %24 to i32, !dbg !163
  %cmp22 = icmp eq i32 %conv21, 99, !dbg !163
  br i1 %cmp22, label %if.then24, label %if.else, !dbg !163

if.then24:                                        ; preds = %if.end20
  %25 = load i8** %format.addr, align 4, !dbg !165
  %incdec.ptr25 = getelementptr inbounds i8* %25, i32 1, !dbg !165
  store i8* %incdec.ptr25, i8** %format.addr, align 4, !dbg !165
  call void @llvm.dbg.declare(metadata !{i8* %c}, metadata !167), !dbg !168
  %ap.cur = load i8** %parameters, !dbg !168
  %26 = bitcast i8* %ap.cur to i32*, !dbg !168
  %ap.next = getelementptr i8* %ap.cur, i32 4, !dbg !168
  store i8* %ap.next, i8** %parameters, !dbg !168
  %27 = load i32* %26, !dbg !168
  %conv26 = trunc i32 %27 to i8, !dbg !168
  store i8 %conv26, i8* %c, align 1, !dbg !168
  call void @print(i8* %c, i32 1) #4, !dbg !169
  br label %if.end139, !dbg !170

if.else:                                          ; preds = %if.end20
  %28 = load i8** %format.addr, align 4, !dbg !171
  %29 = load i8* %28, align 1, !dbg !171
  %conv27 = sext i8 %29 to i32, !dbg !171
  %cmp28 = icmp eq i32 %conv27, 115, !dbg !171
  br i1 %cmp28, label %if.then30, label %if.else34, !dbg !171

if.then30:                                        ; preds = %if.else
  %30 = load i8** %format.addr, align 4, !dbg !173
  %incdec.ptr31 = getelementptr inbounds i8* %30, i32 1, !dbg !173
  store i8* %incdec.ptr31, i8** %format.addr, align 4, !dbg !173
  call void @llvm.dbg.declare(metadata !{i8** %s}, metadata !175), !dbg !176
  %ap.cur32 = load i8** %parameters, !dbg !176
  %31 = bitcast i8* %ap.cur32 to i8**, !dbg !176
  %ap.next33 = getelementptr i8* %ap.cur32, i32 4, !dbg !176
  store i8* %ap.next33, i8** %parameters, !dbg !176
  %32 = load i8** %31, !dbg !176
  store i8* %32, i8** %s, align 4, !dbg !176
  %33 = load i8** %s, align 4, !dbg !177
  %34 = load i8** %s, align 4, !dbg !177
  %call = call i32 @strlen(i8* %34) #4, !dbg !177
  call void @print(i8* %33, i32 %call) #4, !dbg !177
  br label %if.end138, !dbg !178

if.else34:                                        ; preds = %if.else
  %35 = load i8** %format.addr, align 4, !dbg !179
  %36 = load i8* %35, align 1, !dbg !179
  %conv35 = sext i8 %36 to i32, !dbg !179
  %cmp36 = icmp eq i32 %conv35, 120, !dbg !179
  br i1 %cmp36, label %if.then38, label %if.else136, !dbg !179

if.then38:                                        ; preds = %if.else34
  %37 = load i8** %format.addr, align 4, !dbg !181
  %incdec.ptr39 = getelementptr inbounds i8* %37, i32 1, !dbg !181
  store i8* %incdec.ptr39, i8** %format.addr, align 4, !dbg !181
  call void @llvm.dbg.declare(metadata !{i32* %x}, metadata !183), !dbg !184
  %ap.cur40 = load i8** %parameters, !dbg !184
  %38 = bitcast i8* %ap.cur40 to i32*, !dbg !184
  %ap.next41 = getelementptr i8* %ap.cur40, i32 4, !dbg !184
  store i8* %ap.next41, i8** %parameters, !dbg !184
  %39 = load i32* %38, !dbg !184
  store i32 %39, i32* %x, align 4, !dbg !184
  call void @llvm.dbg.declare(metadata !{[5 x i8]* %res}, metadata !185), !dbg !189
  %40 = load i32* %x, align 4, !dbg !190
  %cmp42 = icmp sle i32 %40, 255, !dbg !190
  br i1 %cmp42, label %if.then44, label %if.else68, !dbg !190

if.then44:                                        ; preds = %if.then38
  %41 = load i32* %x, align 4, !dbg !192
  %and = and i32 %41, 240, !dbg !192
  %shr = ashr i32 %and, 4, !dbg !192
  %cmp45 = icmp sle i32 %shr, 9, !dbg !192
  br i1 %cmp45, label %cond.true, label %cond.false, !dbg !192

cond.true:                                        ; preds = %if.then44
  %42 = load i32* %x, align 4, !dbg !192
  %and47 = and i32 %42, 240, !dbg !192
  %shr48 = ashr i32 %and47, 4, !dbg !192
  %add49 = add nsw i32 48, %shr48, !dbg !192
  br label %cond.end, !dbg !192

cond.false:                                       ; preds = %if.then44
  %43 = load i32* %x, align 4, !dbg !192
  %and50 = and i32 %43, 240, !dbg !192
  %shr51 = ashr i32 %and50, 4, !dbg !192
  %add52 = add nsw i32 55, %shr51, !dbg !192
  br label %cond.end, !dbg !192

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i32 [ %add49, %cond.true ], [ %add52, %cond.false ], !dbg !192
  %conv53 = trunc i32 %cond to i8, !dbg !192
  %arrayidx54 = getelementptr inbounds [5 x i8]* %res, i32 0, i32 0, !dbg !192
  store i8 %conv53, i8* %arrayidx54, align 1, !dbg !192
  %44 = load i32* %x, align 4, !dbg !194
  %and55 = and i32 %44, 15, !dbg !194
  %cmp56 = icmp sle i32 %and55, 9, !dbg !194
  br i1 %cmp56, label %cond.true58, label %cond.false61, !dbg !194

cond.true58:                                      ; preds = %cond.end
  %45 = load i32* %x, align 4, !dbg !194
  %and59 = and i32 %45, 15, !dbg !194
  %add60 = add nsw i32 48, %and59, !dbg !194
  br label %cond.end64, !dbg !194

cond.false61:                                     ; preds = %cond.end
  %46 = load i32* %x, align 4, !dbg !194
  %and62 = and i32 %46, 15, !dbg !194
  %add63 = add nsw i32 55, %and62, !dbg !194
  br label %cond.end64, !dbg !194

cond.end64:                                       ; preds = %cond.false61, %cond.true58
  %cond65 = phi i32 [ %add60, %cond.true58 ], [ %add63, %cond.false61 ], !dbg !194
  %conv66 = trunc i32 %cond65 to i8, !dbg !194
  %arrayidx67 = getelementptr inbounds [5 x i8]* %res, i32 0, i32 1, !dbg !194
  store i8 %conv66, i8* %arrayidx67, align 1, !dbg !194
  %arraydecay = getelementptr inbounds [5 x i8]* %res, i32 0, i32 0, !dbg !195
  call void @print(i8* %arraydecay, i32 2) #4, !dbg !195
  br label %if.end135, !dbg !196

if.else68:                                        ; preds = %if.then38
  %47 = load i32* %x, align 4, !dbg !197
  %cmp69 = icmp sle i32 %47, 65535, !dbg !197
  br i1 %cmp69, label %if.then71, label %if.end134, !dbg !197

if.then71:                                        ; preds = %if.else68
  %48 = load i32* %x, align 4, !dbg !199
  %and72 = and i32 %48, 61440, !dbg !199
  %shr73 = ashr i32 %and72, 12, !dbg !199
  %cmp74 = icmp sle i32 %shr73, 9, !dbg !199
  br i1 %cmp74, label %cond.true76, label %cond.false80, !dbg !199

cond.true76:                                      ; preds = %if.then71
  %49 = load i32* %x, align 4, !dbg !199
  %and77 = and i32 %49, 61440, !dbg !199
  %shr78 = ashr i32 %and77, 12, !dbg !199
  %add79 = add nsw i32 48, %shr78, !dbg !199
  br label %cond.end84, !dbg !199

cond.false80:                                     ; preds = %if.then71
  %50 = load i32* %x, align 4, !dbg !199
  %and81 = and i32 %50, 61440, !dbg !199
  %shr82 = ashr i32 %and81, 12, !dbg !199
  %add83 = add nsw i32 55, %shr82, !dbg !199
  br label %cond.end84, !dbg !199

cond.end84:                                       ; preds = %cond.false80, %cond.true76
  %cond85 = phi i32 [ %add79, %cond.true76 ], [ %add83, %cond.false80 ], !dbg !199
  %conv86 = trunc i32 %cond85 to i8, !dbg !199
  %arrayidx87 = getelementptr inbounds [5 x i8]* %res, i32 0, i32 0, !dbg !199
  store i8 %conv86, i8* %arrayidx87, align 1, !dbg !199
  %51 = load i32* %x, align 4, !dbg !201
  %and88 = and i32 %51, 3840, !dbg !201
  %shr89 = ashr i32 %and88, 8, !dbg !201
  %cmp90 = icmp sle i32 %shr89, 9, !dbg !201
  br i1 %cmp90, label %cond.true92, label %cond.false96, !dbg !201

cond.true92:                                      ; preds = %cond.end84
  %52 = load i32* %x, align 4, !dbg !201
  %and93 = and i32 %52, 3840, !dbg !201
  %shr94 = ashr i32 %and93, 8, !dbg !201
  %add95 = add nsw i32 48, %shr94, !dbg !201
  br label %cond.end100, !dbg !201

cond.false96:                                     ; preds = %cond.end84
  %53 = load i32* %x, align 4, !dbg !201
  %and97 = and i32 %53, 3840, !dbg !201
  %shr98 = ashr i32 %and97, 8, !dbg !201
  %add99 = add nsw i32 55, %shr98, !dbg !201
  br label %cond.end100, !dbg !201

cond.end100:                                      ; preds = %cond.false96, %cond.true92
  %cond101 = phi i32 [ %add95, %cond.true92 ], [ %add99, %cond.false96 ], !dbg !201
  %conv102 = trunc i32 %cond101 to i8, !dbg !201
  %arrayidx103 = getelementptr inbounds [5 x i8]* %res, i32 0, i32 1, !dbg !201
  store i8 %conv102, i8* %arrayidx103, align 1, !dbg !201
  %54 = load i32* %x, align 4, !dbg !202
  %and104 = and i32 %54, 240, !dbg !202
  %shr105 = ashr i32 %and104, 4, !dbg !202
  %cmp106 = icmp sle i32 %shr105, 9, !dbg !202
  br i1 %cmp106, label %cond.true108, label %cond.false112, !dbg !202

cond.true108:                                     ; preds = %cond.end100
  %55 = load i32* %x, align 4, !dbg !202
  %and109 = and i32 %55, 240, !dbg !202
  %shr110 = ashr i32 %and109, 4, !dbg !202
  %add111 = add nsw i32 48, %shr110, !dbg !202
  br label %cond.end116, !dbg !202

cond.false112:                                    ; preds = %cond.end100
  %56 = load i32* %x, align 4, !dbg !202
  %and113 = and i32 %56, 240, !dbg !202
  %shr114 = ashr i32 %and113, 4, !dbg !202
  %add115 = add nsw i32 55, %shr114, !dbg !202
  br label %cond.end116, !dbg !202

cond.end116:                                      ; preds = %cond.false112, %cond.true108
  %cond117 = phi i32 [ %add111, %cond.true108 ], [ %add115, %cond.false112 ], !dbg !202
  %conv118 = trunc i32 %cond117 to i8, !dbg !202
  %arrayidx119 = getelementptr inbounds [5 x i8]* %res, i32 0, i32 2, !dbg !202
  store i8 %conv118, i8* %arrayidx119, align 1, !dbg !202
  %57 = load i32* %x, align 4, !dbg !203
  %and120 = and i32 %57, 15, !dbg !203
  %cmp121 = icmp sle i32 %and120, 9, !dbg !203
  br i1 %cmp121, label %cond.true123, label %cond.false126, !dbg !203

cond.true123:                                     ; preds = %cond.end116
  %58 = load i32* %x, align 4, !dbg !203
  %and124 = and i32 %58, 15, !dbg !203
  %add125 = add nsw i32 48, %and124, !dbg !203
  br label %cond.end129, !dbg !203

cond.false126:                                    ; preds = %cond.end116
  %59 = load i32* %x, align 4, !dbg !203
  %and127 = and i32 %59, 15, !dbg !203
  %add128 = add nsw i32 55, %and127, !dbg !203
  br label %cond.end129, !dbg !203

cond.end129:                                      ; preds = %cond.false126, %cond.true123
  %cond130 = phi i32 [ %add125, %cond.true123 ], [ %add128, %cond.false126 ], !dbg !203
  %conv131 = trunc i32 %cond130 to i8, !dbg !203
  %arrayidx132 = getelementptr inbounds [5 x i8]* %res, i32 0, i32 3, !dbg !203
  store i8 %conv131, i8* %arrayidx132, align 1, !dbg !203
  %arraydecay133 = getelementptr inbounds [5 x i8]* %res, i32 0, i32 0, !dbg !204
  call void @print(i8* %arraydecay133, i32 4) #4, !dbg !204
  br label %if.end134, !dbg !205

if.end134:                                        ; preds = %cond.end129, %if.else68
  br label %if.end135

if.end135:                                        ; preds = %if.end134, %cond.end64
  br label %if.end137, !dbg !206

if.else136:                                       ; preds = %if.else34
  br label %incomprehensible_conversion, !dbg !207

if.end137:                                        ; preds = %if.end135
  br label %if.end138

if.end138:                                        ; preds = %if.end137, %if.then30
  br label %if.end139

if.end139:                                        ; preds = %if.end138, %if.then24
  br label %while.cond, !dbg !209

while.end140:                                     ; preds = %while.cond
  %parameters141 = bitcast i8** %parameters to i8*, !dbg !210
  call void @llvm.va_end(i8* %parameters141), !dbg !210
  %60 = load i32* %written, align 4, !dbg !211
  ret i32 %60, !dbg !211
}

; Function Attrs: nounwind
define i32 @putchar(i32 %ic) #0 {
entry:
  %ic.addr = alloca i32, align 4
  %c = alloca i8, align 1
  store i32 %ic, i32* %ic.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %ic.addr}, metadata !212), !dbg !213
  call void @llvm.dbg.declare(metadata !{i8* %c}, metadata !214), !dbg !215
  %0 = load i32* %ic.addr, align 4, !dbg !215
  %conv = trunc i32 %0 to i8, !dbg !215
  store i8 %conv, i8* %c, align 1, !dbg !215
  %1 = load i8* %c, align 1, !dbg !216
  call void @terminal_putchar(i8 signext %1) #4, !dbg !216
  %2 = load i32* %ic.addr, align 4, !dbg !217
  ret i32 %2, !dbg !217
}

declare void @terminal_putchar(i8 signext) #2

; Function Attrs: nounwind
declare void @llvm.va_start(i8*) #3

; Function Attrs: nounwind
define internal void @print(i8* %data, i32 %data_length) #0 {
entry:
  %data.addr = alloca i8*, align 4
  %data_length.addr = alloca i32, align 4
  %i = alloca i32, align 4
  store i8* %data, i8** %data.addr, align 4
  call void @llvm.dbg.declare(metadata !{i8** %data.addr}, metadata !218), !dbg !219
  store i32 %data_length, i32* %data_length.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %data_length.addr}, metadata !220), !dbg !219
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !221), !dbg !223
  store i32 0, i32* %i, align 4, !dbg !223
  br label %for.cond, !dbg !223

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32* %i, align 4, !dbg !223
  %1 = load i32* %data_length.addr, align 4, !dbg !223
  %cmp = icmp ult i32 %0, %1, !dbg !223
  br i1 %cmp, label %for.body, label %for.end, !dbg !223

for.body:                                         ; preds = %for.cond
  %2 = load i32* %i, align 4, !dbg !224
  %3 = load i8** %data.addr, align 4, !dbg !224
  %arrayidx = getelementptr inbounds i8* %3, i32 %2, !dbg !224
  %4 = load i8* %arrayidx, align 1, !dbg !224
  %conv = zext i8 %4 to i32, !dbg !224
  %call = call i32 @putchar(i32 %conv) #4, !dbg !224
  br label %for.inc, !dbg !224

for.inc:                                          ; preds = %for.body
  %5 = load i32* %i, align 4, !dbg !223
  %inc = add i32 %5, 1, !dbg !223
  store i32 %inc, i32* %i, align 4, !dbg !223
  br label %for.cond, !dbg !223

for.end:                                          ; preds = %for.cond
  ret void, !dbg !225
}

; Function Attrs: nounwind
declare void @llvm.va_end(i8*) #3

attributes #0 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }
attributes #4 = { nobuiltin }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!44}
!llvm.ident = !{!45}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"clang version 3.4 (http://llvm.org/git/clang.git 82a2911a94947e20ac4fd961b6322adf74ad9224) (http://llvm.org/git/llvm.git 52244da7f2b3def646900520668b859343b84a33)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !2, metadata !2, metadata !""} ; [ DW_TAG_compile_unit ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c] [DW_LANG_C99]
!1 = metadata !{metadata !"src/string.c", metadata !"/home/gbps/Desktop/Projects/os_notshared/pandos"}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4, metadata !13, metadata !19, metadata !23, metadata !26, metadata !31, metadata !34, metadata !37, metadata !41}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"memmove", metadata !"memmove", metadata !"", i32 10, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i8* (i8*, i8*, i32)* @memmove, null, null, metadata !2, i32 11} ; [ DW_TAG_subprogram ] [line 10] [def] [scope 11] [memmove]
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{metadata !8, metadata !8, metadata !9, metadata !11}
!8 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from ]
!9 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, metadata !10} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from ]
!10 = metadata !{i32 786470, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null} ; [ DW_TAG_const_type ] [line 0, size 0, align 0, offset 0] [from ]
!11 = metadata !{i32 786454, metadata !1, null, metadata !"uint32_t", i32 184, i64 0, i64 0, i64 0, i32 0, metadata !12} ; [ DW_TAG_typedef ] [uint32_t] [line 184, size 0, align 0, offset 0] [from unsigned int]
!12 = metadata !{i32 786468, null, null, metadata !"unsigned int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [unsigned int] [line 0, size 32, align 32, offset 0, enc DW_ATE_unsigned]
!13 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"strlen", metadata !"strlen", metadata !"", i32 23, metadata !14, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i8*)* @strlen, null, null, metadata !2, i32 24} ; [ DW_TAG_subprogram ] [line 23] [def] [scope 24] [strlen]
!14 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !15, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!15 = metadata !{metadata !11, metadata !16}
!16 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, metadata !17} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from ]
!17 = metadata !{i32 786470, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !18} ; [ DW_TAG_const_type ] [line 0, size 0, align 0, offset 0] [from char]
!18 = metadata !{i32 786468, null, null, metadata !"char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!19 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"memcmp", metadata !"memcmp", metadata !"", i32 31, metadata !20, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i8*, i8*, i32)* @memcmp, null, null, metadata !2, i32 32} ; [ DW_TAG_subprogram ] [line 31] [def] [scope 32] [memcmp]
!20 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !21, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!21 = metadata !{metadata !22, metadata !9, metadata !9, metadata !11}
!22 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!23 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"memset", metadata !"memset", metadata !"", i32 43, metadata !24, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i8* (i8*, i32, i32)* @memset, null, null, metadata !2, i32 44} ; [ DW_TAG_subprogram ] [line 43] [def] [scope 44] [memset]
!24 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !25, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!25 = metadata !{metadata !8, metadata !8, metadata !22, metadata !11}
!26 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"memcpy", metadata !"memcpy", metadata !"", i32 51, metadata !27, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i8* (i8*, i8*, i32)* @memcpy, null, null, metadata !2, i32 52} ; [ DW_TAG_subprogram ] [line 51] [def] [scope 52] [memcpy]
!27 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !28, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!28 = metadata !{metadata !8, metadata !29, metadata !30, metadata !11}
!29 = metadata !{i32 786487, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !8} ; [ DW_TAG_restrict_type ] [line 0, size 0, align 0, offset 0] [from ]
!30 = metadata !{i32 786487, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !9} ; [ DW_TAG_restrict_type ] [line 0, size 0, align 0, offset 0] [from ]
!31 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"puts", metadata !"puts", metadata !"", i32 60, metadata !32, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i8*)* @puts, null, null, metadata !2, i32 61} ; [ DW_TAG_subprogram ] [line 60] [def] [scope 61] [puts]
!32 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !33, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!33 = metadata !{metadata !22, metadata !16}
!34 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"putchar", metadata !"putchar", metadata !"", i32 65, metadata !35, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32)* @putchar, null, null, metadata !2, i32 66} ; [ DW_TAG_subprogram ] [line 65] [def] [scope 66] [putchar]
!35 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !36, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!36 = metadata !{metadata !22, metadata !22}
!37 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"printf", metadata !"printf", metadata !"", i32 78, metadata !38, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i8*, ...)* @printf, null, null, metadata !2, i32 79} ; [ DW_TAG_subprogram ] [line 78] [def] [scope 79] [printf]
!38 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !39, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!39 = metadata !{metadata !22, metadata !40}
!40 = metadata !{i32 786487, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !16} ; [ DW_TAG_restrict_type ] [line 0, size 0, align 0, offset 0] [from ]
!41 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"print", metadata !"print", metadata !"", i32 72, metadata !42, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i8*, i32)* @print, null, null, metadata !2, i32 73} ; [ DW_TAG_subprogram ] [line 72] [local] [def] [scope 73] [print]
!42 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !43, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!43 = metadata !{null, metadata !16, metadata !11}
!44 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!45 = metadata !{metadata !"clang version 3.4 (http://llvm.org/git/clang.git 82a2911a94947e20ac4fd961b6322adf74ad9224) (http://llvm.org/git/llvm.git 52244da7f2b3def646900520668b859343b84a33)"}
!46 = metadata !{i32 786689, metadata !4, metadata !"dstptr", metadata !5, i32 16777226, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [dstptr] [line 10]
!47 = metadata !{i32 10, i32 0, metadata !4, null}
!48 = metadata !{i32 786689, metadata !4, metadata !"srcptr", metadata !5, i32 33554442, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [srcptr] [line 10]
!49 = metadata !{i32 786689, metadata !4, metadata !"size", metadata !5, i32 50331658, metadata !11, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [size] [line 10]
!50 = metadata !{i32 786688, metadata !4, metadata !"dst", metadata !5, i32 12, metadata !51, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [dst] [line 12]
!51 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, metadata !52} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from unsigned char]
!52 = metadata !{i32 786468, null, null, metadata !"unsigned char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 8} ; [ DW_TAG_base_type ] [unsigned char] [line 0, size 8, align 8, offset 0, enc DW_ATE_unsigned_char]
!53 = metadata !{i32 12, i32 0, metadata !4, null}
!54 = metadata !{i32 786688, metadata !4, metadata !"src", metadata !5, i32 13, metadata !55, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [src] [line 13]
!55 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, metadata !56} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from ]
!56 = metadata !{i32 786470, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !52} ; [ DW_TAG_const_type ] [line 0, size 0, align 0, offset 0] [from unsigned char]
!57 = metadata !{i32 13, i32 0, metadata !4, null}
!58 = metadata !{i32 14, i32 0, metadata !59, null}
!59 = metadata !{i32 786443, metadata !1, metadata !4, i32 14, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!60 = metadata !{i32 786688, metadata !61, metadata !"i", metadata !5, i32 15, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 15]
!61 = metadata !{i32 786443, metadata !1, metadata !59, i32 15, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!62 = metadata !{i32 15, i32 0, metadata !61, null}
!63 = metadata !{i32 16, i32 0, metadata !61, null}
!64 = metadata !{i32 786688, metadata !65, metadata !"i", metadata !5, i32 18, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 18]
!65 = metadata !{i32 786443, metadata !1, metadata !59, i32 18, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!66 = metadata !{i32 18, i32 0, metadata !65, null}
!67 = metadata !{i32 19, i32 0, metadata !65, null}
!68 = metadata !{i32 20, i32 0, metadata !4, null}
!69 = metadata !{i32 786689, metadata !13, metadata !"string", metadata !5, i32 16777239, metadata !16, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [string] [line 23]
!70 = metadata !{i32 23, i32 0, metadata !13, null}
!71 = metadata !{i32 786688, metadata !13, metadata !"result", metadata !5, i32 25, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [result] [line 25]
!72 = metadata !{i32 25, i32 0, metadata !13, null}
!73 = metadata !{i32 26, i32 0, metadata !13, null}
!74 = metadata !{i32 27, i32 0, metadata !13, null}
!75 = metadata !{i32 28, i32 0, metadata !13, null}
!76 = metadata !{i32 786689, metadata !19, metadata !"aptr", metadata !5, i32 16777247, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [aptr] [line 31]
!77 = metadata !{i32 31, i32 0, metadata !19, null}
!78 = metadata !{i32 786689, metadata !19, metadata !"bptr", metadata !5, i32 33554463, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [bptr] [line 31]
!79 = metadata !{i32 786689, metadata !19, metadata !"size", metadata !5, i32 50331679, metadata !11, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [size] [line 31]
!80 = metadata !{i32 786688, metadata !19, metadata !"a", metadata !5, i32 33, metadata !55, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [a] [line 33]
!81 = metadata !{i32 33, i32 0, metadata !19, null}
!82 = metadata !{i32 786688, metadata !19, metadata !"b", metadata !5, i32 34, metadata !55, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [b] [line 34]
!83 = metadata !{i32 34, i32 0, metadata !19, null}
!84 = metadata !{i32 786688, metadata !85, metadata !"i", metadata !5, i32 35, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 35]
!85 = metadata !{i32 786443, metadata !1, metadata !19, i32 35, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!86 = metadata !{i32 35, i32 0, metadata !85, null}
!87 = metadata !{i32 36, i32 0, metadata !88, null}
!88 = metadata !{i32 786443, metadata !1, metadata !85, i32 36, i32 0, i32 4} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!89 = metadata !{i32 37, i32 0, metadata !88, null}
!90 = metadata !{i32 38, i32 0, metadata !91, null}
!91 = metadata !{i32 786443, metadata !1, metadata !88, i32 38, i32 0, i32 5} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!92 = metadata !{i32 39, i32 0, metadata !91, null}
!93 = metadata !{i32 39, i32 0, metadata !88, null}
!94 = metadata !{i32 40, i32 0, metadata !19, null}
!95 = metadata !{i32 41, i32 0, metadata !19, null}
!96 = metadata !{i32 786689, metadata !23, metadata !"bufptr", metadata !5, i32 16777259, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [bufptr] [line 43]
!97 = metadata !{i32 43, i32 0, metadata !23, null}
!98 = metadata !{i32 786689, metadata !23, metadata !"value", metadata !5, i32 33554475, metadata !22, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [value] [line 43]
!99 = metadata !{i32 786689, metadata !23, metadata !"size", metadata !5, i32 50331691, metadata !11, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [size] [line 43]
!100 = metadata !{i32 786688, metadata !23, metadata !"buf", metadata !5, i32 45, metadata !51, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [buf] [line 45]
!101 = metadata !{i32 45, i32 0, metadata !23, null}
!102 = metadata !{i32 786688, metadata !103, metadata !"i", metadata !5, i32 46, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 46]
!103 = metadata !{i32 786443, metadata !1, metadata !23, i32 46, i32 0, i32 6} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!104 = metadata !{i32 46, i32 0, metadata !103, null}
!105 = metadata !{i32 47, i32 0, metadata !103, null}
!106 = metadata !{i32 48, i32 0, metadata !23, null}
!107 = metadata !{i32 786689, metadata !26, metadata !"dstptr", metadata !5, i32 16777267, metadata !29, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [dstptr] [line 51]
!108 = metadata !{i32 51, i32 0, metadata !26, null}
!109 = metadata !{i32 786689, metadata !26, metadata !"srcptr", metadata !5, i32 33554483, metadata !30, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [srcptr] [line 51]
!110 = metadata !{i32 786689, metadata !26, metadata !"size", metadata !5, i32 50331699, metadata !11, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [size] [line 51]
!111 = metadata !{i32 786688, metadata !26, metadata !"dst", metadata !5, i32 53, metadata !51, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [dst] [line 53]
!112 = metadata !{i32 53, i32 0, metadata !26, null}
!113 = metadata !{i32 786688, metadata !26, metadata !"src", metadata !5, i32 54, metadata !55, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [src] [line 54]
!114 = metadata !{i32 54, i32 0, metadata !26, null}
!115 = metadata !{i32 786688, metadata !116, metadata !"i", metadata !5, i32 55, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 55]
!116 = metadata !{i32 786443, metadata !1, metadata !26, i32 55, i32 0, i32 7} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!117 = metadata !{i32 55, i32 0, metadata !116, null}
!118 = metadata !{i32 56, i32 0, metadata !116, null}
!119 = metadata !{i32 57, i32 0, metadata !26, null}
!120 = metadata !{i32 786689, metadata !31, metadata !"string", metadata !5, i32 16777276, metadata !16, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [string] [line 60]
!121 = metadata !{i32 60, i32 0, metadata !31, null}
!122 = metadata !{i32 62, i32 0, metadata !31, null}
!123 = metadata !{i32 786689, metadata !37, metadata !"format", metadata !5, i32 16777294, metadata !40, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [format] [line 78]
!124 = metadata !{i32 78, i32 0, metadata !37, null}
!125 = metadata !{i32 786688, metadata !37, metadata !"parameters", metadata !5, i32 80, metadata !126, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [parameters] [line 80]
!126 = metadata !{i32 786454, metadata !1, null, metadata !"va_list", i32 30, i64 0, i64 0, i64 0, i32 0, metadata !127} ; [ DW_TAG_typedef ] [va_list] [line 30, size 0, align 0, offset 0] [from __builtin_va_list]
!127 = metadata !{i32 786454, metadata !1, null, metadata !"__builtin_va_list", i32 80, i64 0, i64 0, i64 0, i32 0, metadata !128} ; [ DW_TAG_typedef ] [__builtin_va_list] [line 80, size 0, align 0, offset 0] [from ]
!128 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, metadata !18} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from char]
!129 = metadata !{i32 80, i32 0, metadata !37, null}
!130 = metadata !{i32 81, i32 0, metadata !37, null}
!131 = metadata !{i32 786688, metadata !37, metadata !"written", metadata !5, i32 83, metadata !22, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [written] [line 83]
!132 = metadata !{i32 83, i32 0, metadata !37, null}
!133 = metadata !{i32 786688, metadata !37, metadata !"amount", metadata !5, i32 84, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [amount] [line 84]
!134 = metadata !{i32 84, i32 0, metadata !37, null}
!135 = metadata !{i32 786688, metadata !37, metadata !"rejected_bad_specifier", metadata !5, i32 85, metadata !136, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [rejected_bad_specifier] [line 85]
!136 = metadata !{i32 786468, null, null, metadata !"_Bool", i32 0, i64 8, i64 8, i64 0, i32 0, i32 2} ; [ DW_TAG_base_type ] [_Bool] [line 0, size 8, align 8, offset 0, enc DW_ATE_boolean]
!137 = metadata !{i32 85, i32 0, metadata !37, null}
!138 = metadata !{i32 89, i32 0, metadata !37, null}
!139 = metadata !{i32 91, i32 0, metadata !140, null}
!140 = metadata !{i32 786443, metadata !1, metadata !141, i32 91, i32 0, i32 9} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!141 = metadata !{i32 786443, metadata !1, metadata !37, i32 90, i32 0, i32 8} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!142 = metadata !{i32 92, i32 0, metadata !143, null}
!143 = metadata !{i32 786443, metadata !1, metadata !140, i32 92, i32 0, i32 10} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!144 = metadata !{i32 94, i32 0, metadata !143, null}
!145 = metadata !{i32 95, i32 0, metadata !143, null}
!146 = metadata !{i32 96, i32 0, metadata !143, null}
!147 = metadata !{i32 97, i32 0, metadata !143, null}
!148 = metadata !{i32 98, i32 0, metadata !143, null}
!149 = metadata !{i32 99, i32 0, metadata !143, null}
!150 = metadata !{i32 100, i32 0, metadata !143, null}
!151 = metadata !{i32 786688, metadata !141, metadata !"format_begun_at", metadata !5, i32 103, metadata !16, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [format_begun_at] [line 103]
!152 = metadata !{i32 103, i32 0, metadata !141, null}
!153 = metadata !{i32 105, i32 0, metadata !154, null}
!154 = metadata !{i32 786443, metadata !1, metadata !141, i32 105, i32 0, i32 11} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!155 = metadata !{i32 106, i32 0, metadata !154, null}
!156 = metadata !{i32 108, i32 0, metadata !157, null}
!157 = metadata !{i32 786443, metadata !1, metadata !141, i32 108, i32 0, i32 12} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!158 = metadata !{i32 109, i32 0, metadata !159, null}
!159 = metadata !{i32 786443, metadata !1, metadata !157, i32 109, i32 0, i32 13} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!160 = metadata !{i32 111, i32 0, metadata !159, null}
!161 = metadata !{i32 112, i32 0, metadata !159, null}
!162 = metadata !{i32 113, i32 0, metadata !159, null}
!163 = metadata !{i32 116, i32 0, metadata !164, null}
!164 = metadata !{i32 786443, metadata !1, metadata !141, i32 116, i32 0, i32 14} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!165 = metadata !{i32 118, i32 0, metadata !166, null}
!166 = metadata !{i32 786443, metadata !1, metadata !164, i32 117, i32 0, i32 15} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!167 = metadata !{i32 786688, metadata !166, metadata !"c", metadata !5, i32 119, metadata !18, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [c] [line 119]
!168 = metadata !{i32 119, i32 0, metadata !166, null}
!169 = metadata !{i32 120, i32 0, metadata !166, null}
!170 = metadata !{i32 121, i32 0, metadata !166, null}
!171 = metadata !{i32 122, i32 0, metadata !172, null}
!172 = metadata !{i32 786443, metadata !1, metadata !164, i32 122, i32 0, i32 16} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!173 = metadata !{i32 124, i32 0, metadata !174, null}
!174 = metadata !{i32 786443, metadata !1, metadata !172, i32 123, i32 0, i32 17} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!175 = metadata !{i32 786688, metadata !174, metadata !"s", metadata !5, i32 125, metadata !16, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [s] [line 125]
!176 = metadata !{i32 125, i32 0, metadata !174, null}
!177 = metadata !{i32 126, i32 0, metadata !174, null}
!178 = metadata !{i32 127, i32 0, metadata !174, null}
!179 = metadata !{i32 128, i32 0, metadata !180, null}
!180 = metadata !{i32 786443, metadata !1, metadata !172, i32 128, i32 0, i32 18} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!181 = metadata !{i32 130, i32 0, metadata !182, null}
!182 = metadata !{i32 786443, metadata !1, metadata !180, i32 129, i32 0, i32 19} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!183 = metadata !{i32 786688, metadata !182, metadata !"x", metadata !5, i32 131, metadata !22, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [x] [line 131]
!184 = metadata !{i32 131, i32 0, metadata !182, null}
!185 = metadata !{i32 786688, metadata !182, metadata !"res", metadata !5, i32 132, metadata !186, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [res] [line 132]
!186 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 40, i64 8, i32 0, i32 0, metadata !18, metadata !187, i32 0, null, null, null} ; [ DW_TAG_array_type ] [line 0, size 40, align 8, offset 0] [from char]
!187 = metadata !{metadata !188}
!188 = metadata !{i32 786465, i64 0, i64 5}       ; [ DW_TAG_subrange_type ] [0, 4]
!189 = metadata !{i32 132, i32 0, metadata !182, null}
!190 = metadata !{i32 134, i32 0, metadata !191, null}
!191 = metadata !{i32 786443, metadata !1, metadata !182, i32 134, i32 0, i32 20} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!192 = metadata !{i32 136, i32 0, metadata !193, null}
!193 = metadata !{i32 786443, metadata !1, metadata !191, i32 135, i32 0, i32 21} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!194 = metadata !{i32 137, i32 0, metadata !193, null}
!195 = metadata !{i32 138, i32 0, metadata !193, null}
!196 = metadata !{i32 139, i32 0, metadata !193, null}
!197 = metadata !{i32 140, i32 0, metadata !198, null}
!198 = metadata !{i32 786443, metadata !1, metadata !191, i32 140, i32 0, i32 22} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!199 = metadata !{i32 142, i32 0, metadata !200, null}
!200 = metadata !{i32 786443, metadata !1, metadata !198, i32 141, i32 0, i32 23} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!201 = metadata !{i32 143, i32 0, metadata !200, null}
!202 = metadata !{i32 144, i32 0, metadata !200, null}
!203 = metadata !{i32 145, i32 0, metadata !200, null}
!204 = metadata !{i32 147, i32 0, metadata !200, null}
!205 = metadata !{i32 148, i32 0, metadata !200, null}
!206 = metadata !{i32 149, i32 0, metadata !182, null}
!207 = metadata !{i32 152, i32 0, metadata !208, null}
!208 = metadata !{i32 786443, metadata !1, metadata !180, i32 151, i32 0, i32 24} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!209 = metadata !{i32 154, i32 0, metadata !141, null}
!210 = metadata !{i32 156, i32 0, metadata !37, null}
!211 = metadata !{i32 158, i32 0, metadata !37, null}
!212 = metadata !{i32 786689, metadata !34, metadata !"ic", metadata !5, i32 16777281, metadata !22, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [ic] [line 65]
!213 = metadata !{i32 65, i32 0, metadata !34, null}
!214 = metadata !{i32 786688, metadata !34, metadata !"c", metadata !5, i32 67, metadata !18, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [c] [line 67]
!215 = metadata !{i32 67, i32 0, metadata !34, null}
!216 = metadata !{i32 68, i32 0, metadata !34, null}
!217 = metadata !{i32 69, i32 0, metadata !34, null}
!218 = metadata !{i32 786689, metadata !41, metadata !"data", metadata !5, i32 16777288, metadata !16, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [data] [line 72]
!219 = metadata !{i32 72, i32 0, metadata !41, null}
!220 = metadata !{i32 786689, metadata !41, metadata !"data_length", metadata !5, i32 33554504, metadata !11, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [data_length] [line 72]
!221 = metadata !{i32 786688, metadata !222, metadata !"i", metadata !5, i32 74, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 74]
!222 = metadata !{i32 786443, metadata !1, metadata !41, i32 74, i32 0, i32 25} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/string.c]
!223 = metadata !{i32 74, i32 0, metadata !222, null}
!224 = metadata !{i32 75, i32 0, metadata !222, null}
!225 = metadata !{i32 76, i32 0, metadata !41, null}
