; ModuleID = 'src/liballoc.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i686-pc-none-elf"

%struct.liballoc_major = type { %struct.liballoc_major*, %struct.liballoc_major*, i32, i32, i32, %struct.liballoc_minor* }
%struct.liballoc_minor = type { %struct.liballoc_minor*, %struct.liballoc_minor*, %struct.liballoc_major*, i32, i32, i32 }

@l_warningCount = internal global i64 0, align 8
@l_memRoot = internal global %struct.liballoc_major* null, align 4
@l_bestBet = internal global %struct.liballoc_major* null, align 4
@l_inuse = internal global i64 0, align 8
@l_errorCount = internal global i64 0, align 8
@l_possibleOverruns = internal global i64 0, align 8
@l_allocated = internal global i64 0, align 8
@l_pageSize = internal global i32 4194304, align 4
@l_pageCount = internal global i32 1, align 4

; Function Attrs: nounwind
define i8* @kmalloc(i32 %req_size) #0 {
entry:
  %retval = alloca i8*, align 4
  %req_size.addr = alloca i32, align 4
  %startedBet = alloca i32, align 4
  %bestSize = alloca i64, align 8
  %p = alloca i8*, align 4
  %diff = alloca i32, align 4
  %maj = alloca %struct.liballoc_major*, align 4
  %min = alloca %struct.liballoc_minor*, align 4
  %new_min = alloca %struct.liballoc_minor*, align 4
  %size = alloca i32, align 4
  %diff78 = alloca i32, align 4
  %diff125 = alloca i32, align 4
  %diff176 = alloca i32, align 4
  %diff223 = alloca i32, align 4
  store i32 %req_size, i32* %req_size.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %req_size.addr}, metadata !64), !dbg !65
  call void @llvm.dbg.declare(metadata !{i32* %startedBet}, metadata !66), !dbg !67
  store i32 0, i32* %startedBet, align 4, !dbg !67
  call void @llvm.dbg.declare(metadata !{i64* %bestSize}, metadata !68), !dbg !69
  store i64 0, i64* %bestSize, align 8, !dbg !69
  call void @llvm.dbg.declare(metadata !{i8** %p}, metadata !70), !dbg !71
  store i8* null, i8** %p, align 4, !dbg !71
  call void @llvm.dbg.declare(metadata !{i32* %diff}, metadata !72), !dbg !75
  call void @llvm.dbg.declare(metadata !{%struct.liballoc_major** %maj}, metadata !76), !dbg !77
  call void @llvm.dbg.declare(metadata !{%struct.liballoc_minor** %min}, metadata !78), !dbg !79
  call void @llvm.dbg.declare(metadata !{%struct.liballoc_minor** %new_min}, metadata !80), !dbg !81
  call void @llvm.dbg.declare(metadata !{i32* %size}, metadata !82), !dbg !84
  %0 = load i32* %req_size.addr, align 4, !dbg !84
  store i32 %0, i32* %size, align 4, !dbg !84
  %1 = load i32* %size, align 4, !dbg !85
  %add = add i32 %1, 32, !dbg !85
  store i32 %add, i32* %size, align 4, !dbg !85
  %call = call i32 bitcast (i32 (...)* @liballoc_lock to i32 ()*)() #3, !dbg !88
  %2 = load i32* %size, align 4, !dbg !89
  %cmp = icmp eq i32 %2, 0, !dbg !89
  br i1 %cmp, label %if.then, label %if.end, !dbg !89

if.then:                                          ; preds = %entry
  %3 = load i64* @l_warningCount, align 8, !dbg !91
  %add1 = add nsw i64 %3, 1, !dbg !91
  store i64 %add1, i64* @l_warningCount, align 8, !dbg !91
  %call2 = call i32 bitcast (i32 (...)* @liballoc_unlock to i32 ()*)() #3, !dbg !93
  %call3 = call i8* @kmalloc(i32 1) #3, !dbg !94
  store i8* %call3, i8** %retval, !dbg !94
  br label %return, !dbg !94

if.end:                                           ; preds = %entry
  %4 = load %struct.liballoc_major** @l_memRoot, align 4, !dbg !95
  %cmp4 = icmp eq %struct.liballoc_major* %4, null, !dbg !95
  br i1 %cmp4, label %if.then5, label %if.end11, !dbg !95

if.then5:                                         ; preds = %if.end
  %5 = load i32* %size, align 4, !dbg !97
  %call6 = call %struct.liballoc_major* @allocate_new_page(i32 %5) #3, !dbg !97
  store %struct.liballoc_major* %call6, %struct.liballoc_major** @l_memRoot, align 4, !dbg !97
  %6 = load %struct.liballoc_major** @l_memRoot, align 4, !dbg !99
  %cmp7 = icmp eq %struct.liballoc_major* %6, null, !dbg !99
  br i1 %cmp7, label %if.then8, label %if.end10, !dbg !99

if.then8:                                         ; preds = %if.then5
  %call9 = call i32 bitcast (i32 (...)* @liballoc_unlock to i32 ()*)() #3, !dbg !101
  store i8* null, i8** %retval, !dbg !103
  br label %return, !dbg !103

if.end10:                                         ; preds = %if.then5
  br label %if.end11, !dbg !104

if.end11:                                         ; preds = %if.end10, %if.end
  %7 = load %struct.liballoc_major** @l_memRoot, align 4, !dbg !105
  store %struct.liballoc_major* %7, %struct.liballoc_major** %maj, align 4, !dbg !105
  store i32 0, i32* %startedBet, align 4, !dbg !106
  %8 = load %struct.liballoc_major** @l_bestBet, align 4, !dbg !107
  %cmp12 = icmp ne %struct.liballoc_major* %8, null, !dbg !107
  br i1 %cmp12, label %if.then13, label %if.end21, !dbg !107

if.then13:                                        ; preds = %if.end11
  %9 = load %struct.liballoc_major** @l_bestBet, align 4, !dbg !109
  %size14 = getelementptr inbounds %struct.liballoc_major* %9, i32 0, i32 3, !dbg !109
  %10 = load i32* %size14, align 4, !dbg !109
  %11 = load %struct.liballoc_major** @l_bestBet, align 4, !dbg !109
  %usage = getelementptr inbounds %struct.liballoc_major* %11, i32 0, i32 4, !dbg !109
  %12 = load i32* %usage, align 4, !dbg !109
  %sub = sub i32 %10, %12, !dbg !109
  %conv = zext i32 %sub to i64, !dbg !109
  store i64 %conv, i64* %bestSize, align 8, !dbg !109
  %13 = load i64* %bestSize, align 8, !dbg !111
  %14 = load i32* %size, align 4, !dbg !111
  %add15 = add i32 %14, 24, !dbg !111
  %conv16 = zext i32 %add15 to i64, !dbg !111
  %cmp17 = icmp ugt i64 %13, %conv16, !dbg !111
  br i1 %cmp17, label %if.then19, label %if.end20, !dbg !111

if.then19:                                        ; preds = %if.then13
  %15 = load %struct.liballoc_major** @l_bestBet, align 4, !dbg !113
  store %struct.liballoc_major* %15, %struct.liballoc_major** %maj, align 4, !dbg !113
  store i32 1, i32* %startedBet, align 4, !dbg !115
  br label %if.end20, !dbg !116

if.end20:                                         ; preds = %if.then19, %if.then13
  br label %if.end21, !dbg !117

if.end21:                                         ; preds = %if.end20, %if.end11
  br label %while.cond, !dbg !118

while.cond:                                       ; preds = %if.end256, %if.then245, %if.then44, %if.then39, %if.end21
  %16 = load %struct.liballoc_major** %maj, align 4, !dbg !118
  %cmp22 = icmp ne %struct.liballoc_major* %16, null, !dbg !118
  br i1 %cmp22, label %while.body, label %while.end258, !dbg !118

while.body:                                       ; preds = %while.cond
  %17 = load %struct.liballoc_major** %maj, align 4, !dbg !119
  %size24 = getelementptr inbounds %struct.liballoc_major* %17, i32 0, i32 3, !dbg !119
  %18 = load i32* %size24, align 4, !dbg !119
  %19 = load %struct.liballoc_major** %maj, align 4, !dbg !119
  %usage25 = getelementptr inbounds %struct.liballoc_major* %19, i32 0, i32 4, !dbg !119
  %20 = load i32* %usage25, align 4, !dbg !119
  %sub26 = sub i32 %18, %20, !dbg !119
  store i32 %sub26, i32* %diff, align 4, !dbg !119
  %21 = load i64* %bestSize, align 8, !dbg !121
  %22 = load i32* %diff, align 4, !dbg !121
  %conv27 = zext i32 %22 to i64, !dbg !121
  %cmp28 = icmp ult i64 %21, %conv27, !dbg !121
  br i1 %cmp28, label %if.then30, label %if.end32, !dbg !121

if.then30:                                        ; preds = %while.body
  %23 = load %struct.liballoc_major** %maj, align 4, !dbg !123
  store %struct.liballoc_major* %23, %struct.liballoc_major** @l_bestBet, align 4, !dbg !123
  %24 = load i32* %diff, align 4, !dbg !125
  %conv31 = zext i32 %24 to i64, !dbg !125
  store i64 %conv31, i64* %bestSize, align 8, !dbg !125
  br label %if.end32, !dbg !126

if.end32:                                         ; preds = %if.then30, %while.body
  %25 = load i32* %diff, align 4, !dbg !127
  %26 = load i32* %size, align 4, !dbg !127
  %add33 = add i32 %26, 24, !dbg !127
  %cmp34 = icmp ult i32 %25, %add33, !dbg !127
  br i1 %cmp34, label %if.then36, label %if.end55, !dbg !127

if.then36:                                        ; preds = %if.end32
  %27 = load %struct.liballoc_major** %maj, align 4, !dbg !129
  %next = getelementptr inbounds %struct.liballoc_major* %27, i32 0, i32 1, !dbg !129
  %28 = load %struct.liballoc_major** %next, align 4, !dbg !129
  %cmp37 = icmp ne %struct.liballoc_major* %28, null, !dbg !129
  br i1 %cmp37, label %if.then39, label %if.end41, !dbg !129

if.then39:                                        ; preds = %if.then36
  %29 = load %struct.liballoc_major** %maj, align 4, !dbg !132
  %next40 = getelementptr inbounds %struct.liballoc_major* %29, i32 0, i32 1, !dbg !132
  %30 = load %struct.liballoc_major** %next40, align 4, !dbg !132
  store %struct.liballoc_major* %30, %struct.liballoc_major** %maj, align 4, !dbg !132
  br label %while.cond, !dbg !134

if.end41:                                         ; preds = %if.then36
  %31 = load i32* %startedBet, align 4, !dbg !135
  %cmp42 = icmp eq i32 %31, 1, !dbg !135
  br i1 %cmp42, label %if.then44, label %if.end45, !dbg !135

if.then44:                                        ; preds = %if.end41
  %32 = load %struct.liballoc_major** @l_memRoot, align 4, !dbg !137
  store %struct.liballoc_major* %32, %struct.liballoc_major** %maj, align 4, !dbg !137
  store i32 0, i32* %startedBet, align 4, !dbg !139
  br label %while.cond, !dbg !140

if.end45:                                         ; preds = %if.end41
  %33 = load i32* %size, align 4, !dbg !141
  %call46 = call %struct.liballoc_major* @allocate_new_page(i32 %33) #3, !dbg !141
  %34 = load %struct.liballoc_major** %maj, align 4, !dbg !141
  %next47 = getelementptr inbounds %struct.liballoc_major* %34, i32 0, i32 1, !dbg !141
  store %struct.liballoc_major* %call46, %struct.liballoc_major** %next47, align 4, !dbg !141
  %35 = load %struct.liballoc_major** %maj, align 4, !dbg !142
  %next48 = getelementptr inbounds %struct.liballoc_major* %35, i32 0, i32 1, !dbg !142
  %36 = load %struct.liballoc_major** %next48, align 4, !dbg !142
  %cmp49 = icmp eq %struct.liballoc_major* %36, null, !dbg !142
  br i1 %cmp49, label %if.then51, label %if.end52, !dbg !142

if.then51:                                        ; preds = %if.end45
  br label %while.end258, !dbg !142

if.end52:                                         ; preds = %if.end45
  %37 = load %struct.liballoc_major** %maj, align 4, !dbg !144
  %38 = load %struct.liballoc_major** %maj, align 4, !dbg !144
  %next53 = getelementptr inbounds %struct.liballoc_major* %38, i32 0, i32 1, !dbg !144
  %39 = load %struct.liballoc_major** %next53, align 4, !dbg !144
  %prev = getelementptr inbounds %struct.liballoc_major* %39, i32 0, i32 0, !dbg !144
  store %struct.liballoc_major* %37, %struct.liballoc_major** %prev, align 4, !dbg !144
  %40 = load %struct.liballoc_major** %maj, align 4, !dbg !145
  %next54 = getelementptr inbounds %struct.liballoc_major* %40, i32 0, i32 1, !dbg !145
  %41 = load %struct.liballoc_major** %next54, align 4, !dbg !145
  store %struct.liballoc_major* %41, %struct.liballoc_major** %maj, align 4, !dbg !145
  br label %if.end55, !dbg !146

if.end55:                                         ; preds = %if.end52, %if.end32
  %42 = load %struct.liballoc_major** %maj, align 4, !dbg !147
  %first = getelementptr inbounds %struct.liballoc_major* %42, i32 0, i32 5, !dbg !147
  %43 = load %struct.liballoc_minor** %first, align 4, !dbg !147
  %cmp56 = icmp eq %struct.liballoc_minor* %43, null, !dbg !147
  br i1 %cmp56, label %if.then58, label %if.end90, !dbg !147

if.then58:                                        ; preds = %if.end55
  %44 = load %struct.liballoc_major** %maj, align 4, !dbg !149
  %45 = ptrtoint %struct.liballoc_major* %44 to i32, !dbg !149
  %add59 = add i32 %45, 24, !dbg !149
  %46 = inttoptr i32 %add59 to %struct.liballoc_minor*, !dbg !149
  %47 = load %struct.liballoc_major** %maj, align 4, !dbg !149
  %first60 = getelementptr inbounds %struct.liballoc_major* %47, i32 0, i32 5, !dbg !149
  store %struct.liballoc_minor* %46, %struct.liballoc_minor** %first60, align 4, !dbg !149
  %48 = load %struct.liballoc_major** %maj, align 4, !dbg !151
  %first61 = getelementptr inbounds %struct.liballoc_major* %48, i32 0, i32 5, !dbg !151
  %49 = load %struct.liballoc_minor** %first61, align 4, !dbg !151
  %magic = getelementptr inbounds %struct.liballoc_minor* %49, i32 0, i32 3, !dbg !151
  store i32 -1073626914, i32* %magic, align 4, !dbg !151
  %50 = load %struct.liballoc_major** %maj, align 4, !dbg !152
  %first62 = getelementptr inbounds %struct.liballoc_major* %50, i32 0, i32 5, !dbg !152
  %51 = load %struct.liballoc_minor** %first62, align 4, !dbg !152
  %prev63 = getelementptr inbounds %struct.liballoc_minor* %51, i32 0, i32 0, !dbg !152
  store %struct.liballoc_minor* null, %struct.liballoc_minor** %prev63, align 4, !dbg !152
  %52 = load %struct.liballoc_major** %maj, align 4, !dbg !153
  %first64 = getelementptr inbounds %struct.liballoc_major* %52, i32 0, i32 5, !dbg !153
  %53 = load %struct.liballoc_minor** %first64, align 4, !dbg !153
  %next65 = getelementptr inbounds %struct.liballoc_minor* %53, i32 0, i32 1, !dbg !153
  store %struct.liballoc_minor* null, %struct.liballoc_minor** %next65, align 4, !dbg !153
  %54 = load %struct.liballoc_major** %maj, align 4, !dbg !154
  %55 = load %struct.liballoc_major** %maj, align 4, !dbg !154
  %first66 = getelementptr inbounds %struct.liballoc_major* %55, i32 0, i32 5, !dbg !154
  %56 = load %struct.liballoc_minor** %first66, align 4, !dbg !154
  %block = getelementptr inbounds %struct.liballoc_minor* %56, i32 0, i32 2, !dbg !154
  store %struct.liballoc_major* %54, %struct.liballoc_major** %block, align 4, !dbg !154
  %57 = load i32* %size, align 4, !dbg !155
  %58 = load %struct.liballoc_major** %maj, align 4, !dbg !155
  %first67 = getelementptr inbounds %struct.liballoc_major* %58, i32 0, i32 5, !dbg !155
  %59 = load %struct.liballoc_minor** %first67, align 4, !dbg !155
  %size68 = getelementptr inbounds %struct.liballoc_minor* %59, i32 0, i32 4, !dbg !155
  store i32 %57, i32* %size68, align 4, !dbg !155
  %60 = load i32* %req_size.addr, align 4, !dbg !156
  %61 = load %struct.liballoc_major** %maj, align 4, !dbg !156
  %first69 = getelementptr inbounds %struct.liballoc_major* %61, i32 0, i32 5, !dbg !156
  %62 = load %struct.liballoc_minor** %first69, align 4, !dbg !156
  %req_size70 = getelementptr inbounds %struct.liballoc_minor* %62, i32 0, i32 5, !dbg !156
  store i32 %60, i32* %req_size70, align 4, !dbg !156
  %63 = load i32* %size, align 4, !dbg !157
  %add71 = add i32 %63, 24, !dbg !157
  %64 = load %struct.liballoc_major** %maj, align 4, !dbg !157
  %usage72 = getelementptr inbounds %struct.liballoc_major* %64, i32 0, i32 4, !dbg !157
  %65 = load i32* %usage72, align 4, !dbg !157
  %add73 = add i32 %65, %add71, !dbg !157
  store i32 %add73, i32* %usage72, align 4, !dbg !157
  %66 = load i32* %size, align 4, !dbg !158
  %conv74 = zext i32 %66 to i64, !dbg !158
  %67 = load i64* @l_inuse, align 8, !dbg !158
  %add75 = add i64 %67, %conv74, !dbg !158
  store i64 %add75, i64* @l_inuse, align 8, !dbg !158
  %68 = load %struct.liballoc_major** %maj, align 4, !dbg !159
  %first76 = getelementptr inbounds %struct.liballoc_major* %68, i32 0, i32 5, !dbg !159
  %69 = load %struct.liballoc_minor** %first76, align 4, !dbg !159
  %70 = ptrtoint %struct.liballoc_minor* %69 to i32, !dbg !159
  %add77 = add i32 %70, 24, !dbg !159
  %71 = inttoptr i32 %add77 to i8*, !dbg !159
  store i8* %71, i8** %p, align 4, !dbg !159
  call void @llvm.dbg.declare(metadata !{i32* %diff78}, metadata !160), !dbg !163
  %72 = load i8** %p, align 4, !dbg !163
  %73 = ptrtoint i8* %72 to i32, !dbg !163
  %add79 = add i32 %73, 16, !dbg !163
  %74 = inttoptr i32 %add79 to i8*, !dbg !163
  store i8* %74, i8** %p, align 4, !dbg !163
  %75 = load i8** %p, align 4, !dbg !163
  %76 = ptrtoint i8* %75 to i32, !dbg !163
  %and = and i32 %76, 15, !dbg !163
  store i32 %and, i32* %diff78, align 4, !dbg !163
  %77 = load i32* %diff78, align 4, !dbg !164
  %cmp80 = icmp ne i32 %77, 0, !dbg !164
  br i1 %cmp80, label %if.then82, label %if.end85, !dbg !164

if.then82:                                        ; preds = %if.then58
  %78 = load i32* %diff78, align 4, !dbg !166
  %sub83 = sub i32 16, %78, !dbg !166
  store i32 %sub83, i32* %diff78, align 4, !dbg !166
  %79 = load i8** %p, align 4, !dbg !166
  %80 = ptrtoint i8* %79 to i32, !dbg !166
  %81 = load i32* %diff78, align 4, !dbg !166
  %add84 = add i32 %80, %81, !dbg !166
  %82 = inttoptr i32 %add84 to i8*, !dbg !166
  store i8* %82, i8** %p, align 4, !dbg !166
  br label %if.end85, !dbg !166

if.end85:                                         ; preds = %if.then82, %if.then58
  %83 = load i32* %diff78, align 4, !dbg !163
  %add86 = add i32 %83, 16, !dbg !163
  %conv87 = trunc i32 %add86 to i8, !dbg !163
  %84 = load i8** %p, align 4, !dbg !163
  %85 = ptrtoint i8* %84 to i32, !dbg !163
  %sub88 = sub i32 %85, 16, !dbg !163
  %86 = inttoptr i32 %sub88 to i8*, !dbg !163
  store i8 %conv87, i8* %86, align 1, !dbg !163
  %call89 = call i32 bitcast (i32 (...)* @liballoc_unlock to i32 ()*)() #3, !dbg !168
  %87 = load i8** %p, align 4, !dbg !169
  store i8* %87, i8** %retval, !dbg !169
  br label %return, !dbg !169

if.end90:                                         ; preds = %if.end55
  %88 = load %struct.liballoc_major** %maj, align 4, !dbg !170
  %first91 = getelementptr inbounds %struct.liballoc_major* %88, i32 0, i32 5, !dbg !170
  %89 = load %struct.liballoc_minor** %first91, align 4, !dbg !170
  %90 = ptrtoint %struct.liballoc_minor* %89 to i32, !dbg !170
  store i32 %90, i32* %diff, align 4, !dbg !170
  %91 = load %struct.liballoc_major** %maj, align 4, !dbg !171
  %92 = ptrtoint %struct.liballoc_major* %91 to i32, !dbg !171
  %93 = load i32* %diff, align 4, !dbg !171
  %sub92 = sub i32 %93, %92, !dbg !171
  store i32 %sub92, i32* %diff, align 4, !dbg !171
  %94 = load i32* %diff, align 4, !dbg !172
  %sub93 = sub i32 %94, 24, !dbg !172
  store i32 %sub93, i32* %diff, align 4, !dbg !172
  %95 = load i32* %diff, align 4, !dbg !173
  %96 = load i32* %size, align 4, !dbg !173
  %add94 = add i32 %96, 24, !dbg !173
  %cmp95 = icmp uge i32 %95, %add94, !dbg !173
  br i1 %cmp95, label %if.then97, label %if.end138, !dbg !173

if.then97:                                        ; preds = %if.end90
  %97 = load %struct.liballoc_major** %maj, align 4, !dbg !175
  %98 = ptrtoint %struct.liballoc_major* %97 to i32, !dbg !175
  %add98 = add i32 %98, 24, !dbg !175
  %99 = inttoptr i32 %add98 to %struct.liballoc_minor*, !dbg !175
  %100 = load %struct.liballoc_major** %maj, align 4, !dbg !175
  %first99 = getelementptr inbounds %struct.liballoc_major* %100, i32 0, i32 5, !dbg !175
  %101 = load %struct.liballoc_minor** %first99, align 4, !dbg !175
  %prev100 = getelementptr inbounds %struct.liballoc_minor* %101, i32 0, i32 0, !dbg !175
  store %struct.liballoc_minor* %99, %struct.liballoc_minor** %prev100, align 4, !dbg !175
  %102 = load %struct.liballoc_major** %maj, align 4, !dbg !177
  %first101 = getelementptr inbounds %struct.liballoc_major* %102, i32 0, i32 5, !dbg !177
  %103 = load %struct.liballoc_minor** %first101, align 4, !dbg !177
  %104 = load %struct.liballoc_major** %maj, align 4, !dbg !177
  %first102 = getelementptr inbounds %struct.liballoc_major* %104, i32 0, i32 5, !dbg !177
  %105 = load %struct.liballoc_minor** %first102, align 4, !dbg !177
  %prev103 = getelementptr inbounds %struct.liballoc_minor* %105, i32 0, i32 0, !dbg !177
  %106 = load %struct.liballoc_minor** %prev103, align 4, !dbg !177
  %next104 = getelementptr inbounds %struct.liballoc_minor* %106, i32 0, i32 1, !dbg !177
  store %struct.liballoc_minor* %103, %struct.liballoc_minor** %next104, align 4, !dbg !177
  %107 = load %struct.liballoc_major** %maj, align 4, !dbg !178
  %first105 = getelementptr inbounds %struct.liballoc_major* %107, i32 0, i32 5, !dbg !178
  %108 = load %struct.liballoc_minor** %first105, align 4, !dbg !178
  %prev106 = getelementptr inbounds %struct.liballoc_minor* %108, i32 0, i32 0, !dbg !178
  %109 = load %struct.liballoc_minor** %prev106, align 4, !dbg !178
  %110 = load %struct.liballoc_major** %maj, align 4, !dbg !178
  %first107 = getelementptr inbounds %struct.liballoc_major* %110, i32 0, i32 5, !dbg !178
  store %struct.liballoc_minor* %109, %struct.liballoc_minor** %first107, align 4, !dbg !178
  %111 = load %struct.liballoc_major** %maj, align 4, !dbg !179
  %first108 = getelementptr inbounds %struct.liballoc_major* %111, i32 0, i32 5, !dbg !179
  %112 = load %struct.liballoc_minor** %first108, align 4, !dbg !179
  %magic109 = getelementptr inbounds %struct.liballoc_minor* %112, i32 0, i32 3, !dbg !179
  store i32 -1073626914, i32* %magic109, align 4, !dbg !179
  %113 = load %struct.liballoc_major** %maj, align 4, !dbg !180
  %first110 = getelementptr inbounds %struct.liballoc_major* %113, i32 0, i32 5, !dbg !180
  %114 = load %struct.liballoc_minor** %first110, align 4, !dbg !180
  %prev111 = getelementptr inbounds %struct.liballoc_minor* %114, i32 0, i32 0, !dbg !180
  store %struct.liballoc_minor* null, %struct.liballoc_minor** %prev111, align 4, !dbg !180
  %115 = load %struct.liballoc_major** %maj, align 4, !dbg !181
  %116 = load %struct.liballoc_major** %maj, align 4, !dbg !181
  %first112 = getelementptr inbounds %struct.liballoc_major* %116, i32 0, i32 5, !dbg !181
  %117 = load %struct.liballoc_minor** %first112, align 4, !dbg !181
  %block113 = getelementptr inbounds %struct.liballoc_minor* %117, i32 0, i32 2, !dbg !181
  store %struct.liballoc_major* %115, %struct.liballoc_major** %block113, align 4, !dbg !181
  %118 = load i32* %size, align 4, !dbg !182
  %119 = load %struct.liballoc_major** %maj, align 4, !dbg !182
  %first114 = getelementptr inbounds %struct.liballoc_major* %119, i32 0, i32 5, !dbg !182
  %120 = load %struct.liballoc_minor** %first114, align 4, !dbg !182
  %size115 = getelementptr inbounds %struct.liballoc_minor* %120, i32 0, i32 4, !dbg !182
  store i32 %118, i32* %size115, align 4, !dbg !182
  %121 = load i32* %req_size.addr, align 4, !dbg !183
  %122 = load %struct.liballoc_major** %maj, align 4, !dbg !183
  %first116 = getelementptr inbounds %struct.liballoc_major* %122, i32 0, i32 5, !dbg !183
  %123 = load %struct.liballoc_minor** %first116, align 4, !dbg !183
  %req_size117 = getelementptr inbounds %struct.liballoc_minor* %123, i32 0, i32 5, !dbg !183
  store i32 %121, i32* %req_size117, align 4, !dbg !183
  %124 = load i32* %size, align 4, !dbg !184
  %add118 = add i32 %124, 24, !dbg !184
  %125 = load %struct.liballoc_major** %maj, align 4, !dbg !184
  %usage119 = getelementptr inbounds %struct.liballoc_major* %125, i32 0, i32 4, !dbg !184
  %126 = load i32* %usage119, align 4, !dbg !184
  %add120 = add i32 %126, %add118, !dbg !184
  store i32 %add120, i32* %usage119, align 4, !dbg !184
  %127 = load i32* %size, align 4, !dbg !185
  %conv121 = zext i32 %127 to i64, !dbg !185
  %128 = load i64* @l_inuse, align 8, !dbg !185
  %add122 = add i64 %128, %conv121, !dbg !185
  store i64 %add122, i64* @l_inuse, align 8, !dbg !185
  %129 = load %struct.liballoc_major** %maj, align 4, !dbg !186
  %first123 = getelementptr inbounds %struct.liballoc_major* %129, i32 0, i32 5, !dbg !186
  %130 = load %struct.liballoc_minor** %first123, align 4, !dbg !186
  %131 = ptrtoint %struct.liballoc_minor* %130 to i32, !dbg !186
  %add124 = add i32 %131, 24, !dbg !186
  %132 = inttoptr i32 %add124 to i8*, !dbg !186
  store i8* %132, i8** %p, align 4, !dbg !186
  call void @llvm.dbg.declare(metadata !{i32* %diff125}, metadata !187), !dbg !190
  %133 = load i8** %p, align 4, !dbg !190
  %134 = ptrtoint i8* %133 to i32, !dbg !190
  %add126 = add i32 %134, 16, !dbg !190
  %135 = inttoptr i32 %add126 to i8*, !dbg !190
  store i8* %135, i8** %p, align 4, !dbg !190
  %136 = load i8** %p, align 4, !dbg !190
  %137 = ptrtoint i8* %136 to i32, !dbg !190
  %and127 = and i32 %137, 15, !dbg !190
  store i32 %and127, i32* %diff125, align 4, !dbg !190
  %138 = load i32* %diff125, align 4, !dbg !191
  %cmp128 = icmp ne i32 %138, 0, !dbg !191
  br i1 %cmp128, label %if.then130, label %if.end133, !dbg !191

if.then130:                                       ; preds = %if.then97
  %139 = load i32* %diff125, align 4, !dbg !193
  %sub131 = sub i32 16, %139, !dbg !193
  store i32 %sub131, i32* %diff125, align 4, !dbg !193
  %140 = load i8** %p, align 4, !dbg !193
  %141 = ptrtoint i8* %140 to i32, !dbg !193
  %142 = load i32* %diff125, align 4, !dbg !193
  %add132 = add i32 %141, %142, !dbg !193
  %143 = inttoptr i32 %add132 to i8*, !dbg !193
  store i8* %143, i8** %p, align 4, !dbg !193
  br label %if.end133, !dbg !193

if.end133:                                        ; preds = %if.then130, %if.then97
  %144 = load i32* %diff125, align 4, !dbg !190
  %add134 = add i32 %144, 16, !dbg !190
  %conv135 = trunc i32 %add134 to i8, !dbg !190
  %145 = load i8** %p, align 4, !dbg !190
  %146 = ptrtoint i8* %145 to i32, !dbg !190
  %sub136 = sub i32 %146, 16, !dbg !190
  %147 = inttoptr i32 %sub136 to i8*, !dbg !190
  store i8 %conv135, i8* %147, align 1, !dbg !190
  %call137 = call i32 bitcast (i32 (...)* @liballoc_unlock to i32 ()*)() #3, !dbg !195
  %148 = load i8** %p, align 4, !dbg !196
  store i8* %148, i8** %retval, !dbg !196
  br label %return, !dbg !196

if.end138:                                        ; preds = %if.end90
  %149 = load %struct.liballoc_major** %maj, align 4, !dbg !197
  %first139 = getelementptr inbounds %struct.liballoc_major* %149, i32 0, i32 5, !dbg !197
  %150 = load %struct.liballoc_minor** %first139, align 4, !dbg !197
  store %struct.liballoc_minor* %150, %struct.liballoc_minor** %min, align 4, !dbg !197
  br label %while.cond140, !dbg !198

while.cond140:                                    ; preds = %if.end237, %if.end138
  %151 = load %struct.liballoc_minor** %min, align 4, !dbg !198
  %cmp141 = icmp ne %struct.liballoc_minor* %151, null, !dbg !198
  br i1 %cmp141, label %while.body143, label %while.end, !dbg !198

while.body143:                                    ; preds = %while.cond140
  %152 = load %struct.liballoc_minor** %min, align 4, !dbg !199
  %next144 = getelementptr inbounds %struct.liballoc_minor* %152, i32 0, i32 1, !dbg !199
  %153 = load %struct.liballoc_minor** %next144, align 4, !dbg !199
  %cmp145 = icmp eq %struct.liballoc_minor* %153, null, !dbg !199
  br i1 %cmp145, label %if.then147, label %if.end190, !dbg !199

if.then147:                                       ; preds = %while.body143
  %154 = load %struct.liballoc_major** %maj, align 4, !dbg !202
  %155 = ptrtoint %struct.liballoc_major* %154 to i32, !dbg !202
  %156 = load %struct.liballoc_major** %maj, align 4, !dbg !202
  %size148 = getelementptr inbounds %struct.liballoc_major* %156, i32 0, i32 3, !dbg !202
  %157 = load i32* %size148, align 4, !dbg !202
  %add149 = add i32 %155, %157, !dbg !202
  store i32 %add149, i32* %diff, align 4, !dbg !202
  %158 = load %struct.liballoc_minor** %min, align 4, !dbg !204
  %159 = ptrtoint %struct.liballoc_minor* %158 to i32, !dbg !204
  %160 = load i32* %diff, align 4, !dbg !204
  %sub150 = sub i32 %160, %159, !dbg !204
  store i32 %sub150, i32* %diff, align 4, !dbg !204
  %161 = load i32* %diff, align 4, !dbg !205
  %sub151 = sub i32 %161, 24, !dbg !205
  store i32 %sub151, i32* %diff, align 4, !dbg !205
  %162 = load %struct.liballoc_minor** %min, align 4, !dbg !206
  %size152 = getelementptr inbounds %struct.liballoc_minor* %162, i32 0, i32 4, !dbg !206
  %163 = load i32* %size152, align 4, !dbg !206
  %164 = load i32* %diff, align 4, !dbg !206
  %sub153 = sub i32 %164, %163, !dbg !206
  store i32 %sub153, i32* %diff, align 4, !dbg !206
  %165 = load i32* %diff, align 4, !dbg !207
  %166 = load i32* %size, align 4, !dbg !207
  %add154 = add i32 %166, 24, !dbg !207
  %cmp155 = icmp uge i32 %165, %add154, !dbg !207
  br i1 %cmp155, label %if.then157, label %if.end189, !dbg !207

if.then157:                                       ; preds = %if.then147
  %167 = load %struct.liballoc_minor** %min, align 4, !dbg !209
  %168 = ptrtoint %struct.liballoc_minor* %167 to i32, !dbg !209
  %add158 = add i32 %168, 24, !dbg !209
  %169 = load %struct.liballoc_minor** %min, align 4, !dbg !209
  %size159 = getelementptr inbounds %struct.liballoc_minor* %169, i32 0, i32 4, !dbg !209
  %170 = load i32* %size159, align 4, !dbg !209
  %add160 = add i32 %add158, %170, !dbg !209
  %171 = inttoptr i32 %add160 to %struct.liballoc_minor*, !dbg !209
  %172 = load %struct.liballoc_minor** %min, align 4, !dbg !209
  %next161 = getelementptr inbounds %struct.liballoc_minor* %172, i32 0, i32 1, !dbg !209
  store %struct.liballoc_minor* %171, %struct.liballoc_minor** %next161, align 4, !dbg !209
  %173 = load %struct.liballoc_minor** %min, align 4, !dbg !211
  %174 = load %struct.liballoc_minor** %min, align 4, !dbg !211
  %next162 = getelementptr inbounds %struct.liballoc_minor* %174, i32 0, i32 1, !dbg !211
  %175 = load %struct.liballoc_minor** %next162, align 4, !dbg !211
  %prev163 = getelementptr inbounds %struct.liballoc_minor* %175, i32 0, i32 0, !dbg !211
  store %struct.liballoc_minor* %173, %struct.liballoc_minor** %prev163, align 4, !dbg !211
  %176 = load %struct.liballoc_minor** %min, align 4, !dbg !212
  %next164 = getelementptr inbounds %struct.liballoc_minor* %176, i32 0, i32 1, !dbg !212
  %177 = load %struct.liballoc_minor** %next164, align 4, !dbg !212
  store %struct.liballoc_minor* %177, %struct.liballoc_minor** %min, align 4, !dbg !212
  %178 = load %struct.liballoc_minor** %min, align 4, !dbg !213
  %next165 = getelementptr inbounds %struct.liballoc_minor* %178, i32 0, i32 1, !dbg !213
  store %struct.liballoc_minor* null, %struct.liballoc_minor** %next165, align 4, !dbg !213
  %179 = load %struct.liballoc_minor** %min, align 4, !dbg !214
  %magic166 = getelementptr inbounds %struct.liballoc_minor* %179, i32 0, i32 3, !dbg !214
  store i32 -1073626914, i32* %magic166, align 4, !dbg !214
  %180 = load %struct.liballoc_major** %maj, align 4, !dbg !215
  %181 = load %struct.liballoc_minor** %min, align 4, !dbg !215
  %block167 = getelementptr inbounds %struct.liballoc_minor* %181, i32 0, i32 2, !dbg !215
  store %struct.liballoc_major* %180, %struct.liballoc_major** %block167, align 4, !dbg !215
  %182 = load i32* %size, align 4, !dbg !216
  %183 = load %struct.liballoc_minor** %min, align 4, !dbg !216
  %size168 = getelementptr inbounds %struct.liballoc_minor* %183, i32 0, i32 4, !dbg !216
  store i32 %182, i32* %size168, align 4, !dbg !216
  %184 = load i32* %req_size.addr, align 4, !dbg !217
  %185 = load %struct.liballoc_minor** %min, align 4, !dbg !217
  %req_size169 = getelementptr inbounds %struct.liballoc_minor* %185, i32 0, i32 5, !dbg !217
  store i32 %184, i32* %req_size169, align 4, !dbg !217
  %186 = load i32* %size, align 4, !dbg !218
  %add170 = add i32 %186, 24, !dbg !218
  %187 = load %struct.liballoc_major** %maj, align 4, !dbg !218
  %usage171 = getelementptr inbounds %struct.liballoc_major* %187, i32 0, i32 4, !dbg !218
  %188 = load i32* %usage171, align 4, !dbg !218
  %add172 = add i32 %188, %add170, !dbg !218
  store i32 %add172, i32* %usage171, align 4, !dbg !218
  %189 = load i32* %size, align 4, !dbg !219
  %conv173 = zext i32 %189 to i64, !dbg !219
  %190 = load i64* @l_inuse, align 8, !dbg !219
  %add174 = add i64 %190, %conv173, !dbg !219
  store i64 %add174, i64* @l_inuse, align 8, !dbg !219
  %191 = load %struct.liballoc_minor** %min, align 4, !dbg !220
  %192 = ptrtoint %struct.liballoc_minor* %191 to i32, !dbg !220
  %add175 = add i32 %192, 24, !dbg !220
  %193 = inttoptr i32 %add175 to i8*, !dbg !220
  store i8* %193, i8** %p, align 4, !dbg !220
  call void @llvm.dbg.declare(metadata !{i32* %diff176}, metadata !221), !dbg !224
  %194 = load i8** %p, align 4, !dbg !224
  %195 = ptrtoint i8* %194 to i32, !dbg !224
  %add177 = add i32 %195, 16, !dbg !224
  %196 = inttoptr i32 %add177 to i8*, !dbg !224
  store i8* %196, i8** %p, align 4, !dbg !224
  %197 = load i8** %p, align 4, !dbg !224
  %198 = ptrtoint i8* %197 to i32, !dbg !224
  %and178 = and i32 %198, 15, !dbg !224
  store i32 %and178, i32* %diff176, align 4, !dbg !224
  %199 = load i32* %diff176, align 4, !dbg !225
  %cmp179 = icmp ne i32 %199, 0, !dbg !225
  br i1 %cmp179, label %if.then181, label %if.end184, !dbg !225

if.then181:                                       ; preds = %if.then157
  %200 = load i32* %diff176, align 4, !dbg !227
  %sub182 = sub i32 16, %200, !dbg !227
  store i32 %sub182, i32* %diff176, align 4, !dbg !227
  %201 = load i8** %p, align 4, !dbg !227
  %202 = ptrtoint i8* %201 to i32, !dbg !227
  %203 = load i32* %diff176, align 4, !dbg !227
  %add183 = add i32 %202, %203, !dbg !227
  %204 = inttoptr i32 %add183 to i8*, !dbg !227
  store i8* %204, i8** %p, align 4, !dbg !227
  br label %if.end184, !dbg !227

if.end184:                                        ; preds = %if.then181, %if.then157
  %205 = load i32* %diff176, align 4, !dbg !224
  %add185 = add i32 %205, 16, !dbg !224
  %conv186 = trunc i32 %add185 to i8, !dbg !224
  %206 = load i8** %p, align 4, !dbg !224
  %207 = ptrtoint i8* %206 to i32, !dbg !224
  %sub187 = sub i32 %207, 16, !dbg !224
  %208 = inttoptr i32 %sub187 to i8*, !dbg !224
  store i8 %conv186, i8* %208, align 1, !dbg !224
  %call188 = call i32 bitcast (i32 (...)* @liballoc_unlock to i32 ()*)() #3, !dbg !229
  %209 = load i8** %p, align 4, !dbg !230
  store i8* %209, i8** %retval, !dbg !230
  br label %return, !dbg !230

if.end189:                                        ; preds = %if.then147
  br label %if.end190, !dbg !231

if.end190:                                        ; preds = %if.end189, %while.body143
  %210 = load %struct.liballoc_minor** %min, align 4, !dbg !232
  %next191 = getelementptr inbounds %struct.liballoc_minor* %210, i32 0, i32 1, !dbg !232
  %211 = load %struct.liballoc_minor** %next191, align 4, !dbg !232
  %cmp192 = icmp ne %struct.liballoc_minor* %211, null, !dbg !232
  br i1 %cmp192, label %if.then194, label %if.end237, !dbg !232

if.then194:                                       ; preds = %if.end190
  %212 = load %struct.liballoc_minor** %min, align 4, !dbg !234
  %next195 = getelementptr inbounds %struct.liballoc_minor* %212, i32 0, i32 1, !dbg !234
  %213 = load %struct.liballoc_minor** %next195, align 4, !dbg !234
  %214 = ptrtoint %struct.liballoc_minor* %213 to i32, !dbg !234
  store i32 %214, i32* %diff, align 4, !dbg !234
  %215 = load %struct.liballoc_minor** %min, align 4, !dbg !236
  %216 = ptrtoint %struct.liballoc_minor* %215 to i32, !dbg !236
  %217 = load i32* %diff, align 4, !dbg !236
  %sub196 = sub i32 %217, %216, !dbg !236
  store i32 %sub196, i32* %diff, align 4, !dbg !236
  %218 = load i32* %diff, align 4, !dbg !237
  %sub197 = sub i32 %218, 24, !dbg !237
  store i32 %sub197, i32* %diff, align 4, !dbg !237
  %219 = load %struct.liballoc_minor** %min, align 4, !dbg !238
  %size198 = getelementptr inbounds %struct.liballoc_minor* %219, i32 0, i32 4, !dbg !238
  %220 = load i32* %size198, align 4, !dbg !238
  %221 = load i32* %diff, align 4, !dbg !238
  %sub199 = sub i32 %221, %220, !dbg !238
  store i32 %sub199, i32* %diff, align 4, !dbg !238
  %222 = load i32* %diff, align 4, !dbg !239
  %223 = load i32* %size, align 4, !dbg !239
  %add200 = add i32 %223, 24, !dbg !239
  %cmp201 = icmp uge i32 %222, %add200, !dbg !239
  br i1 %cmp201, label %if.then203, label %if.end236, !dbg !239

if.then203:                                       ; preds = %if.then194
  %224 = load %struct.liballoc_minor** %min, align 4, !dbg !241
  %225 = ptrtoint %struct.liballoc_minor* %224 to i32, !dbg !241
  %add204 = add i32 %225, 24, !dbg !241
  %226 = load %struct.liballoc_minor** %min, align 4, !dbg !241
  %size205 = getelementptr inbounds %struct.liballoc_minor* %226, i32 0, i32 4, !dbg !241
  %227 = load i32* %size205, align 4, !dbg !241
  %add206 = add i32 %add204, %227, !dbg !241
  %228 = inttoptr i32 %add206 to %struct.liballoc_minor*, !dbg !241
  store %struct.liballoc_minor* %228, %struct.liballoc_minor** %new_min, align 4, !dbg !241
  %229 = load %struct.liballoc_minor** %new_min, align 4, !dbg !243
  %magic207 = getelementptr inbounds %struct.liballoc_minor* %229, i32 0, i32 3, !dbg !243
  store i32 -1073626914, i32* %magic207, align 4, !dbg !243
  %230 = load %struct.liballoc_minor** %min, align 4, !dbg !244
  %next208 = getelementptr inbounds %struct.liballoc_minor* %230, i32 0, i32 1, !dbg !244
  %231 = load %struct.liballoc_minor** %next208, align 4, !dbg !244
  %232 = load %struct.liballoc_minor** %new_min, align 4, !dbg !244
  %next209 = getelementptr inbounds %struct.liballoc_minor* %232, i32 0, i32 1, !dbg !244
  store %struct.liballoc_minor* %231, %struct.liballoc_minor** %next209, align 4, !dbg !244
  %233 = load %struct.liballoc_minor** %min, align 4, !dbg !245
  %234 = load %struct.liballoc_minor** %new_min, align 4, !dbg !245
  %prev210 = getelementptr inbounds %struct.liballoc_minor* %234, i32 0, i32 0, !dbg !245
  store %struct.liballoc_minor* %233, %struct.liballoc_minor** %prev210, align 4, !dbg !245
  %235 = load i32* %size, align 4, !dbg !246
  %236 = load %struct.liballoc_minor** %new_min, align 4, !dbg !246
  %size211 = getelementptr inbounds %struct.liballoc_minor* %236, i32 0, i32 4, !dbg !246
  store i32 %235, i32* %size211, align 4, !dbg !246
  %237 = load i32* %req_size.addr, align 4, !dbg !247
  %238 = load %struct.liballoc_minor** %new_min, align 4, !dbg !247
  %req_size212 = getelementptr inbounds %struct.liballoc_minor* %238, i32 0, i32 5, !dbg !247
  store i32 %237, i32* %req_size212, align 4, !dbg !247
  %239 = load %struct.liballoc_major** %maj, align 4, !dbg !248
  %240 = load %struct.liballoc_minor** %new_min, align 4, !dbg !248
  %block213 = getelementptr inbounds %struct.liballoc_minor* %240, i32 0, i32 2, !dbg !248
  store %struct.liballoc_major* %239, %struct.liballoc_major** %block213, align 4, !dbg !248
  %241 = load %struct.liballoc_minor** %new_min, align 4, !dbg !249
  %242 = load %struct.liballoc_minor** %min, align 4, !dbg !249
  %next214 = getelementptr inbounds %struct.liballoc_minor* %242, i32 0, i32 1, !dbg !249
  %243 = load %struct.liballoc_minor** %next214, align 4, !dbg !249
  %prev215 = getelementptr inbounds %struct.liballoc_minor* %243, i32 0, i32 0, !dbg !249
  store %struct.liballoc_minor* %241, %struct.liballoc_minor** %prev215, align 4, !dbg !249
  %244 = load %struct.liballoc_minor** %new_min, align 4, !dbg !250
  %245 = load %struct.liballoc_minor** %min, align 4, !dbg !250
  %next216 = getelementptr inbounds %struct.liballoc_minor* %245, i32 0, i32 1, !dbg !250
  store %struct.liballoc_minor* %244, %struct.liballoc_minor** %next216, align 4, !dbg !250
  %246 = load i32* %size, align 4, !dbg !251
  %add217 = add i32 %246, 24, !dbg !251
  %247 = load %struct.liballoc_major** %maj, align 4, !dbg !251
  %usage218 = getelementptr inbounds %struct.liballoc_major* %247, i32 0, i32 4, !dbg !251
  %248 = load i32* %usage218, align 4, !dbg !251
  %add219 = add i32 %248, %add217, !dbg !251
  store i32 %add219, i32* %usage218, align 4, !dbg !251
  %249 = load i32* %size, align 4, !dbg !252
  %conv220 = zext i32 %249 to i64, !dbg !252
  %250 = load i64* @l_inuse, align 8, !dbg !252
  %add221 = add i64 %250, %conv220, !dbg !252
  store i64 %add221, i64* @l_inuse, align 8, !dbg !252
  %251 = load %struct.liballoc_minor** %new_min, align 4, !dbg !253
  %252 = ptrtoint %struct.liballoc_minor* %251 to i32, !dbg !253
  %add222 = add i32 %252, 24, !dbg !253
  %253 = inttoptr i32 %add222 to i8*, !dbg !253
  store i8* %253, i8** %p, align 4, !dbg !253
  call void @llvm.dbg.declare(metadata !{i32* %diff223}, metadata !254), !dbg !257
  %254 = load i8** %p, align 4, !dbg !257
  %255 = ptrtoint i8* %254 to i32, !dbg !257
  %add224 = add i32 %255, 16, !dbg !257
  %256 = inttoptr i32 %add224 to i8*, !dbg !257
  store i8* %256, i8** %p, align 4, !dbg !257
  %257 = load i8** %p, align 4, !dbg !257
  %258 = ptrtoint i8* %257 to i32, !dbg !257
  %and225 = and i32 %258, 15, !dbg !257
  store i32 %and225, i32* %diff223, align 4, !dbg !257
  %259 = load i32* %diff223, align 4, !dbg !258
  %cmp226 = icmp ne i32 %259, 0, !dbg !258
  br i1 %cmp226, label %if.then228, label %if.end231, !dbg !258

if.then228:                                       ; preds = %if.then203
  %260 = load i32* %diff223, align 4, !dbg !260
  %sub229 = sub i32 16, %260, !dbg !260
  store i32 %sub229, i32* %diff223, align 4, !dbg !260
  %261 = load i8** %p, align 4, !dbg !260
  %262 = ptrtoint i8* %261 to i32, !dbg !260
  %263 = load i32* %diff223, align 4, !dbg !260
  %add230 = add i32 %262, %263, !dbg !260
  %264 = inttoptr i32 %add230 to i8*, !dbg !260
  store i8* %264, i8** %p, align 4, !dbg !260
  br label %if.end231, !dbg !260

if.end231:                                        ; preds = %if.then228, %if.then203
  %265 = load i32* %diff223, align 4, !dbg !257
  %add232 = add i32 %265, 16, !dbg !257
  %conv233 = trunc i32 %add232 to i8, !dbg !257
  %266 = load i8** %p, align 4, !dbg !257
  %267 = ptrtoint i8* %266 to i32, !dbg !257
  %sub234 = sub i32 %267, 16, !dbg !257
  %268 = inttoptr i32 %sub234 to i8*, !dbg !257
  store i8 %conv233, i8* %268, align 1, !dbg !257
  %call235 = call i32 bitcast (i32 (...)* @liballoc_unlock to i32 ()*)() #3, !dbg !262
  %269 = load i8** %p, align 4, !dbg !263
  store i8* %269, i8** %retval, !dbg !263
  br label %return, !dbg !263

if.end236:                                        ; preds = %if.then194
  br label %if.end237, !dbg !264

if.end237:                                        ; preds = %if.end236, %if.end190
  %270 = load %struct.liballoc_minor** %min, align 4, !dbg !265
  %next238 = getelementptr inbounds %struct.liballoc_minor* %270, i32 0, i32 1, !dbg !265
  %271 = load %struct.liballoc_minor** %next238, align 4, !dbg !265
  store %struct.liballoc_minor* %271, %struct.liballoc_minor** %min, align 4, !dbg !265
  br label %while.cond140, !dbg !266

while.end:                                        ; preds = %while.cond140
  %272 = load %struct.liballoc_major** %maj, align 4, !dbg !267
  %next239 = getelementptr inbounds %struct.liballoc_major* %272, i32 0, i32 1, !dbg !267
  %273 = load %struct.liballoc_major** %next239, align 4, !dbg !267
  %cmp240 = icmp eq %struct.liballoc_major* %273, null, !dbg !267
  br i1 %cmp240, label %if.then242, label %if.end256, !dbg !267

if.then242:                                       ; preds = %while.end
  %274 = load i32* %startedBet, align 4, !dbg !269
  %cmp243 = icmp eq i32 %274, 1, !dbg !269
  br i1 %cmp243, label %if.then245, label %if.end246, !dbg !269

if.then245:                                       ; preds = %if.then242
  %275 = load %struct.liballoc_major** @l_memRoot, align 4, !dbg !272
  store %struct.liballoc_major* %275, %struct.liballoc_major** %maj, align 4, !dbg !272
  store i32 0, i32* %startedBet, align 4, !dbg !274
  br label %while.cond, !dbg !275

if.end246:                                        ; preds = %if.then242
  %276 = load i32* %size, align 4, !dbg !276
  %call247 = call %struct.liballoc_major* @allocate_new_page(i32 %276) #3, !dbg !276
  %277 = load %struct.liballoc_major** %maj, align 4, !dbg !276
  %next248 = getelementptr inbounds %struct.liballoc_major* %277, i32 0, i32 1, !dbg !276
  store %struct.liballoc_major* %call247, %struct.liballoc_major** %next248, align 4, !dbg !276
  %278 = load %struct.liballoc_major** %maj, align 4, !dbg !277
  %next249 = getelementptr inbounds %struct.liballoc_major* %278, i32 0, i32 1, !dbg !277
  %279 = load %struct.liballoc_major** %next249, align 4, !dbg !277
  %cmp250 = icmp eq %struct.liballoc_major* %279, null, !dbg !277
  br i1 %cmp250, label %if.then252, label %if.end253, !dbg !277

if.then252:                                       ; preds = %if.end246
  br label %while.end258, !dbg !277

if.end253:                                        ; preds = %if.end246
  %280 = load %struct.liballoc_major** %maj, align 4, !dbg !279
  %281 = load %struct.liballoc_major** %maj, align 4, !dbg !279
  %next254 = getelementptr inbounds %struct.liballoc_major* %281, i32 0, i32 1, !dbg !279
  %282 = load %struct.liballoc_major** %next254, align 4, !dbg !279
  %prev255 = getelementptr inbounds %struct.liballoc_major* %282, i32 0, i32 0, !dbg !279
  store %struct.liballoc_major* %280, %struct.liballoc_major** %prev255, align 4, !dbg !279
  br label %if.end256, !dbg !280

if.end256:                                        ; preds = %if.end253, %while.end
  %283 = load %struct.liballoc_major** %maj, align 4, !dbg !281
  %next257 = getelementptr inbounds %struct.liballoc_major* %283, i32 0, i32 1, !dbg !281
  %284 = load %struct.liballoc_major** %next257, align 4, !dbg !281
  store %struct.liballoc_major* %284, %struct.liballoc_major** %maj, align 4, !dbg !281
  br label %while.cond, !dbg !282

while.end258:                                     ; preds = %if.then252, %if.then51, %while.cond
  %call259 = call i32 bitcast (i32 (...)* @liballoc_unlock to i32 ()*)() #3, !dbg !283
  store i8* null, i8** %retval, !dbg !284
  br label %return, !dbg !284

return:                                           ; preds = %while.end258, %if.end231, %if.end184, %if.end133, %if.end85, %if.then8, %if.then
  %285 = load i8** %retval, !dbg !285
  ret i8* %285, !dbg !285
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

declare i32 @liballoc_lock(...) #2

declare i32 @liballoc_unlock(...) #2

; Function Attrs: nounwind
define internal %struct.liballoc_major* @allocate_new_page(i32 %size) #0 {
entry:
  %retval = alloca %struct.liballoc_major*, align 4
  %size.addr = alloca i32, align 4
  %st = alloca i32, align 4
  %maj = alloca %struct.liballoc_major*, align 4
  store i32 %size, i32* %size.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %size.addr}, metadata !286), !dbg !287
  call void @llvm.dbg.declare(metadata !{i32* %st}, metadata !288), !dbg !289
  call void @llvm.dbg.declare(metadata !{%struct.liballoc_major** %maj}, metadata !290), !dbg !291
  %0 = load i32* %size.addr, align 4, !dbg !292
  %add = add i32 %0, 24, !dbg !292
  store i32 %add, i32* %st, align 4, !dbg !292
  %1 = load i32* %st, align 4, !dbg !293
  %add1 = add i32 %1, 24, !dbg !293
  store i32 %add1, i32* %st, align 4, !dbg !293
  %2 = load i32* %st, align 4, !dbg !294
  %3 = load i32* @l_pageSize, align 4, !dbg !294
  %rem = urem i32 %2, %3, !dbg !294
  %cmp = icmp eq i32 %rem, 0, !dbg !294
  br i1 %cmp, label %if.then, label %if.else, !dbg !294

if.then:                                          ; preds = %entry
  %4 = load i32* %st, align 4, !dbg !296
  %5 = load i32* @l_pageSize, align 4, !dbg !296
  %div = udiv i32 %4, %5, !dbg !296
  store i32 %div, i32* %st, align 4, !dbg !296
  br label %if.end, !dbg !296

if.else:                                          ; preds = %entry
  %6 = load i32* %st, align 4, !dbg !297
  %7 = load i32* @l_pageSize, align 4, !dbg !297
  %div2 = udiv i32 %6, %7, !dbg !297
  %add3 = add i32 %div2, 1, !dbg !297
  store i32 %add3, i32* %st, align 4, !dbg !297
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %8 = load i32* %st, align 4, !dbg !298
  %9 = load i32* @l_pageCount, align 4, !dbg !298
  %cmp4 = icmp ult i32 %8, %9, !dbg !298
  br i1 %cmp4, label %if.then5, label %if.end6, !dbg !298

if.then5:                                         ; preds = %if.end
  %10 = load i32* @l_pageCount, align 4, !dbg !298
  store i32 %10, i32* %st, align 4, !dbg !298
  br label %if.end6, !dbg !298

if.end6:                                          ; preds = %if.then5, %if.end
  %11 = load i32* %st, align 4, !dbg !300
  %call = call i8* @liballoc_alloc(i32 %11) #3, !dbg !300
  %12 = bitcast i8* %call to %struct.liballoc_major*, !dbg !300
  store %struct.liballoc_major* %12, %struct.liballoc_major** %maj, align 4, !dbg !300
  %13 = load %struct.liballoc_major** %maj, align 4, !dbg !301
  %cmp7 = icmp eq %struct.liballoc_major* %13, null, !dbg !301
  br i1 %cmp7, label %if.then8, label %if.end10, !dbg !301

if.then8:                                         ; preds = %if.end6
  %14 = load i64* @l_warningCount, align 8, !dbg !303
  %add9 = add nsw i64 %14, 1, !dbg !303
  store i64 %add9, i64* @l_warningCount, align 8, !dbg !303
  store %struct.liballoc_major* null, %struct.liballoc_major** %retval, !dbg !305
  br label %return, !dbg !305

if.end10:                                         ; preds = %if.end6
  %15 = load %struct.liballoc_major** %maj, align 4, !dbg !306
  %prev = getelementptr inbounds %struct.liballoc_major* %15, i32 0, i32 0, !dbg !306
  store %struct.liballoc_major* null, %struct.liballoc_major** %prev, align 4, !dbg !306
  %16 = load %struct.liballoc_major** %maj, align 4, !dbg !307
  %next = getelementptr inbounds %struct.liballoc_major* %16, i32 0, i32 1, !dbg !307
  store %struct.liballoc_major* null, %struct.liballoc_major** %next, align 4, !dbg !307
  %17 = load i32* %st, align 4, !dbg !308
  %18 = load %struct.liballoc_major** %maj, align 4, !dbg !308
  %pages = getelementptr inbounds %struct.liballoc_major* %18, i32 0, i32 2, !dbg !308
  store i32 %17, i32* %pages, align 4, !dbg !308
  %19 = load i32* %st, align 4, !dbg !309
  %20 = load i32* @l_pageSize, align 4, !dbg !309
  %mul = mul i32 %19, %20, !dbg !309
  %21 = load %struct.liballoc_major** %maj, align 4, !dbg !309
  %size11 = getelementptr inbounds %struct.liballoc_major* %21, i32 0, i32 3, !dbg !309
  store i32 %mul, i32* %size11, align 4, !dbg !309
  %22 = load %struct.liballoc_major** %maj, align 4, !dbg !310
  %usage = getelementptr inbounds %struct.liballoc_major* %22, i32 0, i32 4, !dbg !310
  store i32 24, i32* %usage, align 4, !dbg !310
  %23 = load %struct.liballoc_major** %maj, align 4, !dbg !311
  %first = getelementptr inbounds %struct.liballoc_major* %23, i32 0, i32 5, !dbg !311
  store %struct.liballoc_minor* null, %struct.liballoc_minor** %first, align 4, !dbg !311
  %24 = load %struct.liballoc_major** %maj, align 4, !dbg !312
  %size12 = getelementptr inbounds %struct.liballoc_major* %24, i32 0, i32 3, !dbg !312
  %25 = load i32* %size12, align 4, !dbg !312
  %conv = zext i32 %25 to i64, !dbg !312
  %26 = load i64* @l_allocated, align 8, !dbg !312
  %add13 = add i64 %26, %conv, !dbg !312
  store i64 %add13, i64* @l_allocated, align 8, !dbg !312
  %27 = load %struct.liballoc_major** %maj, align 4, !dbg !313
  store %struct.liballoc_major* %27, %struct.liballoc_major** %retval, !dbg !313
  br label %return, !dbg !313

return:                                           ; preds = %if.end10, %if.then8
  %28 = load %struct.liballoc_major** %retval, !dbg !314
  ret %struct.liballoc_major* %28, !dbg !314
}

; Function Attrs: nounwind
define void @kfree(i8* %ptr) #0 {
entry:
  %ptr.addr = alloca i8*, align 4
  %min = alloca %struct.liballoc_minor*, align 4
  %maj = alloca %struct.liballoc_major*, align 4
  %diff = alloca i32, align 4
  %bestSize = alloca i32, align 4
  %majSize = alloca i32, align 4
  store i8* %ptr, i8** %ptr.addr, align 4
  call void @llvm.dbg.declare(metadata !{i8** %ptr.addr}, metadata !315), !dbg !316
  call void @llvm.dbg.declare(metadata !{%struct.liballoc_minor** %min}, metadata !317), !dbg !318
  call void @llvm.dbg.declare(metadata !{%struct.liballoc_major** %maj}, metadata !319), !dbg !320
  %0 = load i8** %ptr.addr, align 4, !dbg !321
  %cmp = icmp eq i8* %0, null, !dbg !321
  br i1 %cmp, label %if.then, label %if.end, !dbg !321

if.then:                                          ; preds = %entry
  %1 = load i64* @l_warningCount, align 8, !dbg !323
  %add = add nsw i64 %1, 1, !dbg !323
  store i64 %add, i64* @l_warningCount, align 8, !dbg !323
  br label %return, !dbg !325

if.end:                                           ; preds = %entry
  call void @llvm.dbg.declare(metadata !{i32* %diff}, metadata !326), !dbg !329
  %2 = load i8** %ptr.addr, align 4, !dbg !329
  %3 = ptrtoint i8* %2 to i32, !dbg !329
  %sub = sub i32 %3, 16, !dbg !329
  %4 = inttoptr i32 %sub to i8*, !dbg !329
  %5 = load i8* %4, align 1, !dbg !329
  %conv = sext i8 %5 to i32, !dbg !329
  store i32 %conv, i32* %diff, align 4, !dbg !329
  %6 = load i32* %diff, align 4, !dbg !330
  %cmp1 = icmp ult i32 %6, 32, !dbg !330
  br i1 %cmp1, label %if.then3, label %if.end5, !dbg !330

if.then3:                                         ; preds = %if.end
  %7 = load i8** %ptr.addr, align 4, !dbg !332
  %8 = ptrtoint i8* %7 to i32, !dbg !332
  %9 = load i32* %diff, align 4, !dbg !332
  %sub4 = sub i32 %8, %9, !dbg !332
  %10 = inttoptr i32 %sub4 to i8*, !dbg !332
  store i8* %10, i8** %ptr.addr, align 4, !dbg !332
  br label %if.end5, !dbg !332

if.end5:                                          ; preds = %if.then3, %if.end
  %call = call i32 bitcast (i32 (...)* @liballoc_lock to i32 ()*)() #3, !dbg !334
  %11 = load i8** %ptr.addr, align 4, !dbg !335
  %12 = ptrtoint i8* %11 to i32, !dbg !335
  %sub6 = sub i32 %12, 24, !dbg !335
  %13 = inttoptr i32 %sub6 to %struct.liballoc_minor*, !dbg !335
  store %struct.liballoc_minor* %13, %struct.liballoc_minor** %min, align 4, !dbg !335
  %14 = load %struct.liballoc_minor** %min, align 4, !dbg !336
  %magic = getelementptr inbounds %struct.liballoc_minor* %14, i32 0, i32 3, !dbg !336
  %15 = load i32* %magic, align 4, !dbg !336
  %cmp7 = icmp ne i32 %15, -1073626914, !dbg !336
  br i1 %cmp7, label %if.then9, label %if.end32, !dbg !336

if.then9:                                         ; preds = %if.end5
  %16 = load i64* @l_errorCount, align 8, !dbg !338
  %add10 = add nsw i64 %16, 1, !dbg !338
  store i64 %add10, i64* @l_errorCount, align 8, !dbg !338
  %17 = load %struct.liballoc_minor** %min, align 4, !dbg !340
  %magic11 = getelementptr inbounds %struct.liballoc_minor* %17, i32 0, i32 3, !dbg !340
  %18 = load i32* %magic11, align 4, !dbg !340
  %and = and i32 %18, 16777215, !dbg !340
  %cmp12 = icmp eq i32 %and, 114910, !dbg !340
  br i1 %cmp12, label %if.then23, label %lor.lhs.false, !dbg !340

lor.lhs.false:                                    ; preds = %if.then9
  %19 = load %struct.liballoc_minor** %min, align 4, !dbg !340
  %magic14 = getelementptr inbounds %struct.liballoc_minor* %19, i32 0, i32 3, !dbg !340
  %20 = load i32* %magic14, align 4, !dbg !340
  %and15 = and i32 %20, 65535, !dbg !340
  %cmp16 = icmp eq i32 %and15, 49374, !dbg !340
  br i1 %cmp16, label %if.then23, label %lor.lhs.false18, !dbg !340

lor.lhs.false18:                                  ; preds = %lor.lhs.false
  %21 = load %struct.liballoc_minor** %min, align 4, !dbg !340
  %magic19 = getelementptr inbounds %struct.liballoc_minor* %21, i32 0, i32 3, !dbg !340
  %22 = load i32* %magic19, align 4, !dbg !340
  %and20 = and i32 %22, 255, !dbg !340
  %cmp21 = icmp eq i32 %and20, 222, !dbg !340
  br i1 %cmp21, label %if.then23, label %if.end25, !dbg !340

if.then23:                                        ; preds = %lor.lhs.false18, %lor.lhs.false, %if.then9
  %23 = load i64* @l_possibleOverruns, align 8, !dbg !342
  %add24 = add nsw i64 %23, 1, !dbg !342
  store i64 %add24, i64* @l_possibleOverruns, align 8, !dbg !342
  br label %if.end25, !dbg !344

if.end25:                                         ; preds = %if.then23, %lor.lhs.false18
  %24 = load %struct.liballoc_minor** %min, align 4, !dbg !345
  %magic26 = getelementptr inbounds %struct.liballoc_minor* %24, i32 0, i32 3, !dbg !345
  %25 = load i32* %magic26, align 4, !dbg !345
  %cmp27 = icmp eq i32 %25, -559030611, !dbg !345
  br i1 %cmp27, label %if.then29, label %if.else, !dbg !345

if.then29:                                        ; preds = %if.end25
  br label %if.end30, !dbg !347

if.else:                                          ; preds = %if.end25
  br label %if.end30

if.end30:                                         ; preds = %if.else, %if.then29
  %call31 = call i32 bitcast (i32 (...)* @liballoc_unlock to i32 ()*)() #3, !dbg !349
  br label %return, !dbg !350

if.end32:                                         ; preds = %if.end5
  %26 = load %struct.liballoc_minor** %min, align 4, !dbg !351
  %block = getelementptr inbounds %struct.liballoc_minor* %26, i32 0, i32 2, !dbg !351
  %27 = load %struct.liballoc_major** %block, align 4, !dbg !351
  store %struct.liballoc_major* %27, %struct.liballoc_major** %maj, align 4, !dbg !351
  %28 = load %struct.liballoc_minor** %min, align 4, !dbg !352
  %size = getelementptr inbounds %struct.liballoc_minor* %28, i32 0, i32 4, !dbg !352
  %29 = load i32* %size, align 4, !dbg !352
  %conv33 = zext i32 %29 to i64, !dbg !352
  %30 = load i64* @l_inuse, align 8, !dbg !352
  %sub34 = sub i64 %30, %conv33, !dbg !352
  store i64 %sub34, i64* @l_inuse, align 8, !dbg !352
  %31 = load %struct.liballoc_minor** %min, align 4, !dbg !353
  %size35 = getelementptr inbounds %struct.liballoc_minor* %31, i32 0, i32 4, !dbg !353
  %32 = load i32* %size35, align 4, !dbg !353
  %add36 = add i32 %32, 24, !dbg !353
  %33 = load %struct.liballoc_major** %maj, align 4, !dbg !353
  %usage = getelementptr inbounds %struct.liballoc_major* %33, i32 0, i32 4, !dbg !353
  %34 = load i32* %usage, align 4, !dbg !353
  %sub37 = sub i32 %34, %add36, !dbg !353
  store i32 %sub37, i32* %usage, align 4, !dbg !353
  %35 = load %struct.liballoc_minor** %min, align 4, !dbg !354
  %magic38 = getelementptr inbounds %struct.liballoc_minor* %35, i32 0, i32 3, !dbg !354
  store i32 -559030611, i32* %magic38, align 4, !dbg !354
  %36 = load %struct.liballoc_minor** %min, align 4, !dbg !355
  %next = getelementptr inbounds %struct.liballoc_minor* %36, i32 0, i32 1, !dbg !355
  %37 = load %struct.liballoc_minor** %next, align 4, !dbg !355
  %cmp39 = icmp ne %struct.liballoc_minor* %37, null, !dbg !355
  br i1 %cmp39, label %if.then41, label %if.end44, !dbg !355

if.then41:                                        ; preds = %if.end32
  %38 = load %struct.liballoc_minor** %min, align 4, !dbg !355
  %prev = getelementptr inbounds %struct.liballoc_minor* %38, i32 0, i32 0, !dbg !355
  %39 = load %struct.liballoc_minor** %prev, align 4, !dbg !355
  %40 = load %struct.liballoc_minor** %min, align 4, !dbg !355
  %next42 = getelementptr inbounds %struct.liballoc_minor* %40, i32 0, i32 1, !dbg !355
  %41 = load %struct.liballoc_minor** %next42, align 4, !dbg !355
  %prev43 = getelementptr inbounds %struct.liballoc_minor* %41, i32 0, i32 0, !dbg !355
  store %struct.liballoc_minor* %39, %struct.liballoc_minor** %prev43, align 4, !dbg !355
  br label %if.end44, !dbg !355

if.end44:                                         ; preds = %if.then41, %if.end32
  %42 = load %struct.liballoc_minor** %min, align 4, !dbg !357
  %prev45 = getelementptr inbounds %struct.liballoc_minor* %42, i32 0, i32 0, !dbg !357
  %43 = load %struct.liballoc_minor** %prev45, align 4, !dbg !357
  %cmp46 = icmp ne %struct.liballoc_minor* %43, null, !dbg !357
  br i1 %cmp46, label %if.then48, label %if.end52, !dbg !357

if.then48:                                        ; preds = %if.end44
  %44 = load %struct.liballoc_minor** %min, align 4, !dbg !357
  %next49 = getelementptr inbounds %struct.liballoc_minor* %44, i32 0, i32 1, !dbg !357
  %45 = load %struct.liballoc_minor** %next49, align 4, !dbg !357
  %46 = load %struct.liballoc_minor** %min, align 4, !dbg !357
  %prev50 = getelementptr inbounds %struct.liballoc_minor* %46, i32 0, i32 0, !dbg !357
  %47 = load %struct.liballoc_minor** %prev50, align 4, !dbg !357
  %next51 = getelementptr inbounds %struct.liballoc_minor* %47, i32 0, i32 1, !dbg !357
  store %struct.liballoc_minor* %45, %struct.liballoc_minor** %next51, align 4, !dbg !357
  br label %if.end52, !dbg !357

if.end52:                                         ; preds = %if.then48, %if.end44
  %48 = load %struct.liballoc_minor** %min, align 4, !dbg !359
  %prev53 = getelementptr inbounds %struct.liballoc_minor* %48, i32 0, i32 0, !dbg !359
  %49 = load %struct.liballoc_minor** %prev53, align 4, !dbg !359
  %cmp54 = icmp eq %struct.liballoc_minor* %49, null, !dbg !359
  br i1 %cmp54, label %if.then56, label %if.end58, !dbg !359

if.then56:                                        ; preds = %if.end52
  %50 = load %struct.liballoc_minor** %min, align 4, !dbg !359
  %next57 = getelementptr inbounds %struct.liballoc_minor* %50, i32 0, i32 1, !dbg !359
  %51 = load %struct.liballoc_minor** %next57, align 4, !dbg !359
  %52 = load %struct.liballoc_major** %maj, align 4, !dbg !359
  %first = getelementptr inbounds %struct.liballoc_major* %52, i32 0, i32 5, !dbg !359
  store %struct.liballoc_minor* %51, %struct.liballoc_minor** %first, align 4, !dbg !359
  br label %if.end58, !dbg !359

if.end58:                                         ; preds = %if.then56, %if.end52
  %53 = load %struct.liballoc_major** %maj, align 4, !dbg !361
  %first59 = getelementptr inbounds %struct.liballoc_major* %53, i32 0, i32 5, !dbg !361
  %54 = load %struct.liballoc_minor** %first59, align 4, !dbg !361
  %cmp60 = icmp eq %struct.liballoc_minor* %54, null, !dbg !361
  br i1 %cmp60, label %if.then62, label %if.else92, !dbg !361

if.then62:                                        ; preds = %if.end58
  %55 = load %struct.liballoc_major** @l_memRoot, align 4, !dbg !363
  %56 = load %struct.liballoc_major** %maj, align 4, !dbg !363
  %cmp63 = icmp eq %struct.liballoc_major* %55, %56, !dbg !363
  br i1 %cmp63, label %if.then65, label %if.end67, !dbg !363

if.then65:                                        ; preds = %if.then62
  %57 = load %struct.liballoc_major** %maj, align 4, !dbg !363
  %next66 = getelementptr inbounds %struct.liballoc_major* %57, i32 0, i32 1, !dbg !363
  %58 = load %struct.liballoc_major** %next66, align 4, !dbg !363
  store %struct.liballoc_major* %58, %struct.liballoc_major** @l_memRoot, align 4, !dbg !363
  br label %if.end67, !dbg !363

if.end67:                                         ; preds = %if.then65, %if.then62
  %59 = load %struct.liballoc_major** @l_bestBet, align 4, !dbg !366
  %60 = load %struct.liballoc_major** %maj, align 4, !dbg !366
  %cmp68 = icmp eq %struct.liballoc_major* %59, %60, !dbg !366
  br i1 %cmp68, label %if.then70, label %if.end71, !dbg !366

if.then70:                                        ; preds = %if.end67
  store %struct.liballoc_major* null, %struct.liballoc_major** @l_bestBet, align 4, !dbg !366
  br label %if.end71, !dbg !366

if.end71:                                         ; preds = %if.then70, %if.end67
  %61 = load %struct.liballoc_major** %maj, align 4, !dbg !368
  %prev72 = getelementptr inbounds %struct.liballoc_major* %61, i32 0, i32 0, !dbg !368
  %62 = load %struct.liballoc_major** %prev72, align 4, !dbg !368
  %cmp73 = icmp ne %struct.liballoc_major* %62, null, !dbg !368
  br i1 %cmp73, label %if.then75, label %if.end79, !dbg !368

if.then75:                                        ; preds = %if.end71
  %63 = load %struct.liballoc_major** %maj, align 4, !dbg !368
  %next76 = getelementptr inbounds %struct.liballoc_major* %63, i32 0, i32 1, !dbg !368
  %64 = load %struct.liballoc_major** %next76, align 4, !dbg !368
  %65 = load %struct.liballoc_major** %maj, align 4, !dbg !368
  %prev77 = getelementptr inbounds %struct.liballoc_major* %65, i32 0, i32 0, !dbg !368
  %66 = load %struct.liballoc_major** %prev77, align 4, !dbg !368
  %next78 = getelementptr inbounds %struct.liballoc_major* %66, i32 0, i32 1, !dbg !368
  store %struct.liballoc_major* %64, %struct.liballoc_major** %next78, align 4, !dbg !368
  br label %if.end79, !dbg !368

if.end79:                                         ; preds = %if.then75, %if.end71
  %67 = load %struct.liballoc_major** %maj, align 4, !dbg !370
  %next80 = getelementptr inbounds %struct.liballoc_major* %67, i32 0, i32 1, !dbg !370
  %68 = load %struct.liballoc_major** %next80, align 4, !dbg !370
  %cmp81 = icmp ne %struct.liballoc_major* %68, null, !dbg !370
  br i1 %cmp81, label %if.then83, label %if.end87, !dbg !370

if.then83:                                        ; preds = %if.end79
  %69 = load %struct.liballoc_major** %maj, align 4, !dbg !370
  %prev84 = getelementptr inbounds %struct.liballoc_major* %69, i32 0, i32 0, !dbg !370
  %70 = load %struct.liballoc_major** %prev84, align 4, !dbg !370
  %71 = load %struct.liballoc_major** %maj, align 4, !dbg !370
  %next85 = getelementptr inbounds %struct.liballoc_major* %71, i32 0, i32 1, !dbg !370
  %72 = load %struct.liballoc_major** %next85, align 4, !dbg !370
  %prev86 = getelementptr inbounds %struct.liballoc_major* %72, i32 0, i32 0, !dbg !370
  store %struct.liballoc_major* %70, %struct.liballoc_major** %prev86, align 4, !dbg !370
  br label %if.end87, !dbg !370

if.end87:                                         ; preds = %if.then83, %if.end79
  %73 = load %struct.liballoc_major** %maj, align 4, !dbg !372
  %size88 = getelementptr inbounds %struct.liballoc_major* %73, i32 0, i32 3, !dbg !372
  %74 = load i32* %size88, align 4, !dbg !372
  %conv89 = zext i32 %74 to i64, !dbg !372
  %75 = load i64* @l_allocated, align 8, !dbg !372
  %sub90 = sub i64 %75, %conv89, !dbg !372
  store i64 %sub90, i64* @l_allocated, align 8, !dbg !372
  %76 = load %struct.liballoc_major** %maj, align 4, !dbg !373
  %77 = bitcast %struct.liballoc_major* %76 to i8*, !dbg !373
  %78 = load %struct.liballoc_major** %maj, align 4, !dbg !373
  %pages = getelementptr inbounds %struct.liballoc_major* %78, i32 0, i32 2, !dbg !373
  %79 = load i32* %pages, align 4, !dbg !373
  %call91 = call i32 @liballoc_free(i8* %77, i32 %79) #3, !dbg !373
  br label %if.end107, !dbg !374

if.else92:                                        ; preds = %if.end58
  %80 = load %struct.liballoc_major** @l_bestBet, align 4, !dbg !375
  %cmp93 = icmp ne %struct.liballoc_major* %80, null, !dbg !375
  br i1 %cmp93, label %if.then95, label %if.end106, !dbg !375

if.then95:                                        ; preds = %if.else92
  call void @llvm.dbg.declare(metadata !{i32* %bestSize}, metadata !378), !dbg !380
  %81 = load %struct.liballoc_major** @l_bestBet, align 4, !dbg !380
  %size96 = getelementptr inbounds %struct.liballoc_major* %81, i32 0, i32 3, !dbg !380
  %82 = load i32* %size96, align 4, !dbg !380
  %83 = load %struct.liballoc_major** @l_bestBet, align 4, !dbg !380
  %usage97 = getelementptr inbounds %struct.liballoc_major* %83, i32 0, i32 4, !dbg !380
  %84 = load i32* %usage97, align 4, !dbg !380
  %sub98 = sub i32 %82, %84, !dbg !380
  store i32 %sub98, i32* %bestSize, align 4, !dbg !380
  call void @llvm.dbg.declare(metadata !{i32* %majSize}, metadata !381), !dbg !382
  %85 = load %struct.liballoc_major** %maj, align 4, !dbg !382
  %size99 = getelementptr inbounds %struct.liballoc_major* %85, i32 0, i32 3, !dbg !382
  %86 = load i32* %size99, align 4, !dbg !382
  %87 = load %struct.liballoc_major** %maj, align 4, !dbg !382
  %usage100 = getelementptr inbounds %struct.liballoc_major* %87, i32 0, i32 4, !dbg !382
  %88 = load i32* %usage100, align 4, !dbg !382
  %sub101 = sub i32 %86, %88, !dbg !382
  store i32 %sub101, i32* %majSize, align 4, !dbg !382
  %89 = load i32* %majSize, align 4, !dbg !383
  %90 = load i32* %bestSize, align 4, !dbg !383
  %cmp102 = icmp sgt i32 %89, %90, !dbg !383
  br i1 %cmp102, label %if.then104, label %if.end105, !dbg !383

if.then104:                                       ; preds = %if.then95
  %91 = load %struct.liballoc_major** %maj, align 4, !dbg !383
  store %struct.liballoc_major* %91, %struct.liballoc_major** @l_bestBet, align 4, !dbg !383
  br label %if.end105, !dbg !383

if.end105:                                        ; preds = %if.then104, %if.then95
  br label %if.end106, !dbg !385

if.end106:                                        ; preds = %if.end105, %if.else92
  br label %if.end107

if.end107:                                        ; preds = %if.end106, %if.end87
  %call108 = call i32 bitcast (i32 (...)* @liballoc_unlock to i32 ()*)() #3, !dbg !386
  br label %return, !dbg !387

return:                                           ; preds = %if.end107, %if.end30, %if.then
  ret void, !dbg !387
}

declare i32 @liballoc_free(i8*, i32) #2

; Function Attrs: nounwind
define i8* @kcalloc(i32 %nobj, i32 %size) #0 {
entry:
  %nobj.addr = alloca i32, align 4
  %size.addr = alloca i32, align 4
  %real_size = alloca i32, align 4
  %p = alloca i8*, align 4
  store i32 %nobj, i32* %nobj.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %nobj.addr}, metadata !388), !dbg !389
  store i32 %size, i32* %size.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %size.addr}, metadata !390), !dbg !389
  call void @llvm.dbg.declare(metadata !{i32* %real_size}, metadata !391), !dbg !392
  call void @llvm.dbg.declare(metadata !{i8** %p}, metadata !393), !dbg !394
  %0 = load i32* %nobj.addr, align 4, !dbg !395
  %1 = load i32* %size.addr, align 4, !dbg !395
  %mul = mul i32 %0, %1, !dbg !395
  store i32 %mul, i32* %real_size, align 4, !dbg !395
  %2 = load i32* %real_size, align 4, !dbg !396
  %call = call i8* @kmalloc(i32 %2) #3, !dbg !396
  store i8* %call, i8** %p, align 4, !dbg !396
  %3 = load i8** %p, align 4, !dbg !397
  %4 = load i32* %real_size, align 4, !dbg !397
  %call1 = call i8* @liballoc_memset(i8* %3, i32 0, i32 %4) #3, !dbg !397
  %5 = load i8** %p, align 4, !dbg !398
  ret i8* %5, !dbg !398
}

; Function Attrs: nounwind
define internal i8* @liballoc_memset(i8* %s, i32 %c, i32 %n) #0 {
entry:
  %s.addr = alloca i8*, align 4
  %c.addr = alloca i32, align 4
  %n.addr = alloca i32, align 4
  %i = alloca i32, align 4
  store i8* %s, i8** %s.addr, align 4
  call void @llvm.dbg.declare(metadata !{i8** %s.addr}, metadata !399), !dbg !400
  store i32 %c, i32* %c.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %c.addr}, metadata !401), !dbg !400
  store i32 %n, i32* %n.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %n.addr}, metadata !402), !dbg !400
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !403), !dbg !404
  store i32 0, i32* %i, align 4, !dbg !405
  br label %for.cond, !dbg !405

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32* %i, align 4, !dbg !405
  %1 = load i32* %n.addr, align 4, !dbg !405
  %cmp = icmp ult i32 %0, %1, !dbg !405
  br i1 %cmp, label %for.body, label %for.end, !dbg !405

for.body:                                         ; preds = %for.cond
  %2 = load i32* %c.addr, align 4, !dbg !407
  %conv = trunc i32 %2 to i8, !dbg !407
  %3 = load i32* %i, align 4, !dbg !407
  %4 = load i8** %s.addr, align 4, !dbg !407
  %arrayidx = getelementptr inbounds i8* %4, i32 %3, !dbg !407
  store i8 %conv, i8* %arrayidx, align 1, !dbg !407
  br label %for.inc, !dbg !407

for.inc:                                          ; preds = %for.body
  %5 = load i32* %i, align 4, !dbg !405
  %inc = add i32 %5, 1, !dbg !405
  store i32 %inc, i32* %i, align 4, !dbg !405
  br label %for.cond, !dbg !405

for.end:                                          ; preds = %for.cond
  %6 = load i8** %s.addr, align 4, !dbg !408
  ret i8* %6, !dbg !408
}

; Function Attrs: nounwind
define i8* @krealloc(i8* %p, i32 %size) #0 {
entry:
  %retval = alloca i8*, align 4
  %p.addr = alloca i8*, align 4
  %size.addr = alloca i32, align 4
  %ptr = alloca i8*, align 4
  %min = alloca %struct.liballoc_minor*, align 4
  %real_size = alloca i32, align 4
  %diff = alloca i32, align 4
  store i8* %p, i8** %p.addr, align 4
  call void @llvm.dbg.declare(metadata !{i8** %p.addr}, metadata !409), !dbg !410
  store i32 %size, i32* %size.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %size.addr}, metadata !411), !dbg !410
  call void @llvm.dbg.declare(metadata !{i8** %ptr}, metadata !412), !dbg !413
  call void @llvm.dbg.declare(metadata !{%struct.liballoc_minor** %min}, metadata !414), !dbg !415
  call void @llvm.dbg.declare(metadata !{i32* %real_size}, metadata !416), !dbg !417
  %0 = load i32* %size.addr, align 4, !dbg !418
  %cmp = icmp eq i32 %0, 0, !dbg !418
  br i1 %cmp, label %if.then, label %if.end, !dbg !418

if.then:                                          ; preds = %entry
  %1 = load i8** %p.addr, align 4, !dbg !420
  call void @kfree(i8* %1) #3, !dbg !420
  store i8* null, i8** %retval, !dbg !422
  br label %return, !dbg !422

if.end:                                           ; preds = %entry
  %2 = load i8** %p.addr, align 4, !dbg !423
  %cmp1 = icmp eq i8* %2, null, !dbg !423
  br i1 %cmp1, label %if.then2, label %if.end3, !dbg !423

if.then2:                                         ; preds = %if.end
  %3 = load i32* %size.addr, align 4, !dbg !423
  %call = call i8* @kmalloc(i32 %3) #3, !dbg !423
  store i8* %call, i8** %retval, !dbg !423
  br label %return, !dbg !423

if.end3:                                          ; preds = %if.end
  %4 = load i8** %p.addr, align 4, !dbg !425
  store i8* %4, i8** %ptr, align 4, !dbg !425
  call void @llvm.dbg.declare(metadata !{i32* %diff}, metadata !426), !dbg !429
  %5 = load i8** %ptr, align 4, !dbg !429
  %6 = ptrtoint i8* %5 to i32, !dbg !429
  %sub = sub i32 %6, 16, !dbg !429
  %7 = inttoptr i32 %sub to i8*, !dbg !429
  %8 = load i8* %7, align 1, !dbg !429
  %conv = sext i8 %8 to i32, !dbg !429
  store i32 %conv, i32* %diff, align 4, !dbg !429
  %9 = load i32* %diff, align 4, !dbg !430
  %cmp4 = icmp ult i32 %9, 32, !dbg !430
  br i1 %cmp4, label %if.then6, label %if.end8, !dbg !430

if.then6:                                         ; preds = %if.end3
  %10 = load i8** %ptr, align 4, !dbg !432
  %11 = ptrtoint i8* %10 to i32, !dbg !432
  %12 = load i32* %diff, align 4, !dbg !432
  %sub7 = sub i32 %11, %12, !dbg !432
  %13 = inttoptr i32 %sub7 to i8*, !dbg !432
  store i8* %13, i8** %ptr, align 4, !dbg !432
  br label %if.end8, !dbg !432

if.end8:                                          ; preds = %if.then6, %if.end3
  %call9 = call i32 bitcast (i32 (...)* @liballoc_lock to i32 ()*)() #3, !dbg !434
  %14 = load i8** %ptr, align 4, !dbg !435
  %15 = ptrtoint i8* %14 to i32, !dbg !435
  %sub10 = sub i32 %15, 24, !dbg !435
  %16 = inttoptr i32 %sub10 to %struct.liballoc_minor*, !dbg !435
  store %struct.liballoc_minor* %16, %struct.liballoc_minor** %min, align 4, !dbg !435
  %17 = load %struct.liballoc_minor** %min, align 4, !dbg !436
  %magic = getelementptr inbounds %struct.liballoc_minor* %17, i32 0, i32 3, !dbg !436
  %18 = load i32* %magic, align 4, !dbg !436
  %cmp11 = icmp ne i32 %18, -1073626914, !dbg !436
  br i1 %cmp11, label %if.then13, label %if.end35, !dbg !436

if.then13:                                        ; preds = %if.end8
  %19 = load i64* @l_errorCount, align 8, !dbg !438
  %add = add nsw i64 %19, 1, !dbg !438
  store i64 %add, i64* @l_errorCount, align 8, !dbg !438
  %20 = load %struct.liballoc_minor** %min, align 4, !dbg !440
  %magic14 = getelementptr inbounds %struct.liballoc_minor* %20, i32 0, i32 3, !dbg !440
  %21 = load i32* %magic14, align 4, !dbg !440
  %and = and i32 %21, 16777215, !dbg !440
  %cmp15 = icmp eq i32 %and, 114910, !dbg !440
  br i1 %cmp15, label %if.then26, label %lor.lhs.false, !dbg !440

lor.lhs.false:                                    ; preds = %if.then13
  %22 = load %struct.liballoc_minor** %min, align 4, !dbg !440
  %magic17 = getelementptr inbounds %struct.liballoc_minor* %22, i32 0, i32 3, !dbg !440
  %23 = load i32* %magic17, align 4, !dbg !440
  %and18 = and i32 %23, 65535, !dbg !440
  %cmp19 = icmp eq i32 %and18, 49374, !dbg !440
  br i1 %cmp19, label %if.then26, label %lor.lhs.false21, !dbg !440

lor.lhs.false21:                                  ; preds = %lor.lhs.false
  %24 = load %struct.liballoc_minor** %min, align 4, !dbg !440
  %magic22 = getelementptr inbounds %struct.liballoc_minor* %24, i32 0, i32 3, !dbg !440
  %25 = load i32* %magic22, align 4, !dbg !440
  %and23 = and i32 %25, 255, !dbg !440
  %cmp24 = icmp eq i32 %and23, 222, !dbg !440
  br i1 %cmp24, label %if.then26, label %if.end28, !dbg !440

if.then26:                                        ; preds = %lor.lhs.false21, %lor.lhs.false, %if.then13
  %26 = load i64* @l_possibleOverruns, align 8, !dbg !442
  %add27 = add nsw i64 %26, 1, !dbg !442
  store i64 %add27, i64* @l_possibleOverruns, align 8, !dbg !442
  br label %if.end28, !dbg !444

if.end28:                                         ; preds = %if.then26, %lor.lhs.false21
  %27 = load %struct.liballoc_minor** %min, align 4, !dbg !445
  %magic29 = getelementptr inbounds %struct.liballoc_minor* %27, i32 0, i32 3, !dbg !445
  %28 = load i32* %magic29, align 4, !dbg !445
  %cmp30 = icmp eq i32 %28, -559030611, !dbg !445
  br i1 %cmp30, label %if.then32, label %if.else, !dbg !445

if.then32:                                        ; preds = %if.end28
  br label %if.end33, !dbg !447

if.else:                                          ; preds = %if.end28
  br label %if.end33

if.end33:                                         ; preds = %if.else, %if.then32
  %call34 = call i32 bitcast (i32 (...)* @liballoc_unlock to i32 ()*)() #3, !dbg !449
  store i8* null, i8** %retval, !dbg !450
  br label %return, !dbg !450

if.end35:                                         ; preds = %if.end8
  %29 = load %struct.liballoc_minor** %min, align 4, !dbg !451
  %req_size = getelementptr inbounds %struct.liballoc_minor* %29, i32 0, i32 5, !dbg !451
  %30 = load i32* %req_size, align 4, !dbg !451
  store i32 %30, i32* %real_size, align 4, !dbg !451
  %31 = load i32* %real_size, align 4, !dbg !452
  %32 = load i32* %size.addr, align 4, !dbg !452
  %cmp36 = icmp uge i32 %31, %32, !dbg !452
  br i1 %cmp36, label %if.then38, label %if.end41, !dbg !452

if.then38:                                        ; preds = %if.end35
  %33 = load i32* %size.addr, align 4, !dbg !454
  %34 = load %struct.liballoc_minor** %min, align 4, !dbg !454
  %req_size39 = getelementptr inbounds %struct.liballoc_minor* %34, i32 0, i32 5, !dbg !454
  store i32 %33, i32* %req_size39, align 4, !dbg !454
  %call40 = call i32 bitcast (i32 (...)* @liballoc_unlock to i32 ()*)() #3, !dbg !456
  %35 = load i8** %p.addr, align 4, !dbg !457
  store i8* %35, i8** %retval, !dbg !457
  br label %return, !dbg !457

if.end41:                                         ; preds = %if.end35
  %call42 = call i32 bitcast (i32 (...)* @liballoc_unlock to i32 ()*)() #3, !dbg !458
  %36 = load i32* %size.addr, align 4, !dbg !459
  %call43 = call i8* @kmalloc(i32 %36) #3, !dbg !459
  store i8* %call43, i8** %ptr, align 4, !dbg !459
  %37 = load i8** %ptr, align 4, !dbg !460
  %38 = load i8** %p.addr, align 4, !dbg !460
  %39 = load i32* %real_size, align 4, !dbg !460
  %call44 = call i8* @liballoc_memcpy(i8* %37, i8* %38, i32 %39) #3, !dbg !460
  %40 = load i8** %p.addr, align 4, !dbg !461
  call void @kfree(i8* %40) #3, !dbg !461
  %41 = load i8** %ptr, align 4, !dbg !462
  store i8* %41, i8** %retval, !dbg !462
  br label %return, !dbg !462

return:                                           ; preds = %if.end41, %if.then38, %if.end33, %if.then2, %if.then
  %42 = load i8** %retval, !dbg !463
  ret i8* %42, !dbg !463
}

; Function Attrs: nounwind
define internal i8* @liballoc_memcpy(i8* %s1, i8* %s2, i32 %n) #0 {
entry:
  %s1.addr = alloca i8*, align 4
  %s2.addr = alloca i8*, align 4
  %n.addr = alloca i32, align 4
  %cdest = alloca i8*, align 4
  %csrc = alloca i8*, align 4
  %ldest = alloca i32*, align 4
  %lsrc = alloca i32*, align 4
  store i8* %s1, i8** %s1.addr, align 4
  call void @llvm.dbg.declare(metadata !{i8** %s1.addr}, metadata !464), !dbg !465
  store i8* %s2, i8** %s2.addr, align 4
  call void @llvm.dbg.declare(metadata !{i8** %s2.addr}, metadata !466), !dbg !465
  store i32 %n, i32* %n.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %n.addr}, metadata !467), !dbg !465
  call void @llvm.dbg.declare(metadata !{i8** %cdest}, metadata !468), !dbg !471
  call void @llvm.dbg.declare(metadata !{i8** %csrc}, metadata !472), !dbg !473
  call void @llvm.dbg.declare(metadata !{i32** %ldest}, metadata !474), !dbg !476
  %0 = load i8** %s1.addr, align 4, !dbg !476
  %1 = bitcast i8* %0 to i32*, !dbg !476
  store i32* %1, i32** %ldest, align 4, !dbg !476
  call void @llvm.dbg.declare(metadata !{i32** %lsrc}, metadata !477), !dbg !478
  %2 = load i8** %s2.addr, align 4, !dbg !478
  %3 = bitcast i8* %2 to i32*, !dbg !478
  store i32* %3, i32** %lsrc, align 4, !dbg !478
  br label %while.cond, !dbg !479

while.cond:                                       ; preds = %while.body, %entry
  %4 = load i32* %n.addr, align 4, !dbg !479
  %cmp = icmp uge i32 %4, 4, !dbg !479
  br i1 %cmp, label %while.body, label %while.end, !dbg !479

while.body:                                       ; preds = %while.cond
  %5 = load i32** %lsrc, align 4, !dbg !480
  %incdec.ptr = getelementptr inbounds i32* %5, i32 1, !dbg !480
  store i32* %incdec.ptr, i32** %lsrc, align 4, !dbg !480
  %6 = load i32* %5, align 4, !dbg !480
  %7 = load i32** %ldest, align 4, !dbg !480
  %incdec.ptr1 = getelementptr inbounds i32* %7, i32 1, !dbg !480
  store i32* %incdec.ptr1, i32** %ldest, align 4, !dbg !480
  store i32 %6, i32* %7, align 4, !dbg !480
  %8 = load i32* %n.addr, align 4, !dbg !482
  %sub = sub i32 %8, 4, !dbg !482
  store i32 %sub, i32* %n.addr, align 4, !dbg !482
  br label %while.cond, !dbg !483

while.end:                                        ; preds = %while.cond
  %9 = load i32** %ldest, align 4, !dbg !484
  %10 = bitcast i32* %9 to i8*, !dbg !484
  store i8* %10, i8** %cdest, align 4, !dbg !484
  %11 = load i32** %lsrc, align 4, !dbg !485
  %12 = bitcast i32* %11 to i8*, !dbg !485
  store i8* %12, i8** %csrc, align 4, !dbg !485
  br label %while.cond2, !dbg !486

while.cond2:                                      ; preds = %while.body4, %while.end
  %13 = load i32* %n.addr, align 4, !dbg !486
  %cmp3 = icmp ugt i32 %13, 0, !dbg !486
  br i1 %cmp3, label %while.body4, label %while.end8, !dbg !486

while.body4:                                      ; preds = %while.cond2
  %14 = load i8** %csrc, align 4, !dbg !487
  %incdec.ptr5 = getelementptr inbounds i8* %14, i32 1, !dbg !487
  store i8* %incdec.ptr5, i8** %csrc, align 4, !dbg !487
  %15 = load i8* %14, align 1, !dbg !487
  %16 = load i8** %cdest, align 4, !dbg !487
  %incdec.ptr6 = getelementptr inbounds i8* %16, i32 1, !dbg !487
  store i8* %incdec.ptr6, i8** %cdest, align 4, !dbg !487
  store i8 %15, i8* %16, align 1, !dbg !487
  %17 = load i32* %n.addr, align 4, !dbg !489
  %sub7 = sub i32 %17, 1, !dbg !489
  store i32 %sub7, i32* %n.addr, align 4, !dbg !489
  br label %while.cond2, !dbg !490

while.end8:                                       ; preds = %while.cond2
  %18 = load i8** %s1.addr, align 4, !dbg !491
  ret i8* %18, !dbg !491
}

declare i8* @liballoc_alloc(i32) #2

attributes #0 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nobuiltin }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!62}
!llvm.ident = !{!63}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"clang version 3.4 (http://llvm.org/git/clang.git 82a2911a94947e20ac4fd961b6322adf74ad9224) (http://llvm.org/git/llvm.git 52244da7f2b3def646900520668b859343b84a33)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !50, metadata !2, metadata !""} ; [ DW_TAG_compile_unit ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c] [DW_LANG_C99]
!1 = metadata !{metadata !"src/liballoc.c", metadata !"/home/gbps/Desktop/Projects/os_notshared/pandos"}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4, metadata !11, metadata !14, metadata !17, metadata !20, metadata !25, metadata !29}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"kmalloc", metadata !"kmalloc", metadata !"", i32 244, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i8* (i32)* @kmalloc, null, null, metadata !2, i32 245} ; [ DW_TAG_subprogram ] [line 244] [def] [scope 245] [kmalloc]
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{metadata !8, metadata !9}
!8 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from ]
!9 = metadata !{i32 786454, metadata !1, null, metadata !"size_t", i32 42, i64 0, i64 0, i64 0, i32 0, metadata !10} ; [ DW_TAG_typedef ] [size_t] [line 42, size 0, align 0, offset 0] [from unsigned int]
!10 = metadata !{i32 786468, null, null, metadata !"unsigned int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [unsigned int] [line 0, size 32, align 32, offset 0, enc DW_ATE_unsigned]
!11 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"kfree", metadata !"kfree", metadata !"", i32 597, metadata !12, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i8*)* @kfree, null, null, metadata !2, i32 598} ; [ DW_TAG_subprogram ] [line 597] [def] [scope 598] [kfree]
!12 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !13, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!13 = metadata !{null, metadata !8}
!14 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"kcalloc", metadata !"kcalloc", metadata !"", i32 726, metadata !15, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i8* (i32, i32)* @kcalloc, null, null, metadata !2, i32 727} ; [ DW_TAG_subprogram ] [line 726] [def] [scope 727] [kcalloc]
!15 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !16, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!16 = metadata !{metadata !8, metadata !9, metadata !9}
!17 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"krealloc", metadata !"krealloc", metadata !"", i32 742, metadata !18, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i8* (i8*, i32)* @krealloc, null, null, metadata !2, i32 743} ; [ DW_TAG_subprogram ] [line 742] [def] [scope 743] [krealloc]
!18 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !19, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!19 = metadata !{metadata !8, metadata !8, metadata !9}
!20 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"liballoc_memcpy", metadata !"liballoc_memcpy", metadata !"", i32 118, metadata !21, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, i8* (i8*, i8*, i32)* @liballoc_memcpy, null, null, metadata !2, i32 119} ; [ DW_TAG_subprogram ] [line 118] [local] [def] [scope 119] [liballoc_memcpy]
!21 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !22, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!22 = metadata !{metadata !8, metadata !8, metadata !23, metadata !9}
!23 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, metadata !24} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from ]
!24 = metadata !{i32 786470, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null} ; [ DW_TAG_const_type ] [line 0, size 0, align 0, offset 0] [from ]
!25 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"liballoc_memset", metadata !"liballoc_memset", metadata !"", i32 110, metadata !26, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, i8* (i8*, i32, i32)* @liballoc_memset, null, null, metadata !2, i32 111} ; [ DW_TAG_subprogram ] [line 110] [local] [def] [scope 111] [liballoc_memset]
!26 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !27, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!27 = metadata !{metadata !8, metadata !8, metadata !28, metadata !9}
!28 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!29 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"allocate_new_page", metadata !"allocate_new_page", metadata !"", i32 188, metadata !30, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, %struct.liballoc_major* (i32)* @allocate_new_page, null, null, metadata !2, i32 189} ; [ DW_TAG_subprogram ] [line 188] [local] [def] [scope 189] [allocate_new_page]
!30 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !31, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!31 = metadata !{metadata !32, metadata !10}
!32 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, metadata !33} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from liballoc_major]
!33 = metadata !{i32 786451, metadata !1, null, metadata !"liballoc_major", i32 65, i64 192, i64 32, i32 0, i32 0, null, metadata !34, i32 0, null, null, null} ; [ DW_TAG_structure_type ] [liballoc_major] [line 65, size 192, align 32, offset 0] [def] [from ]
!34 = metadata !{metadata !35, metadata !36, metadata !37, metadata !38, metadata !39, metadata !40}
!35 = metadata !{i32 786445, metadata !1, metadata !33, metadata !"prev", i32 67, i64 32, i64 32, i64 0, i32 0, metadata !32} ; [ DW_TAG_member ] [prev] [line 67, size 32, align 32, offset 0] [from ]
!36 = metadata !{i32 786445, metadata !1, metadata !33, metadata !"next", i32 68, i64 32, i64 32, i64 32, i32 0, metadata !32} ; [ DW_TAG_member ] [next] [line 68, size 32, align 32, offset 32] [from ]
!37 = metadata !{i32 786445, metadata !1, metadata !33, metadata !"pages", i32 69, i64 32, i64 32, i64 64, i32 0, metadata !10} ; [ DW_TAG_member ] [pages] [line 69, size 32, align 32, offset 64] [from unsigned int]
!38 = metadata !{i32 786445, metadata !1, metadata !33, metadata !"size", i32 70, i64 32, i64 32, i64 96, i32 0, metadata !10} ; [ DW_TAG_member ] [size] [line 70, size 32, align 32, offset 96] [from unsigned int]
!39 = metadata !{i32 786445, metadata !1, metadata !33, metadata !"usage", i32 71, i64 32, i64 32, i64 128, i32 0, metadata !10} ; [ DW_TAG_member ] [usage] [line 71, size 32, align 32, offset 128] [from unsigned int]
!40 = metadata !{i32 786445, metadata !1, metadata !33, metadata !"first", i32 72, i64 32, i64 32, i64 160, i32 0, metadata !41} ; [ DW_TAG_member ] [first] [line 72, size 32, align 32, offset 160] [from ]
!41 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, metadata !42} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from liballoc_minor]
!42 = metadata !{i32 786451, metadata !1, null, metadata !"liballoc_minor", i32 80, i64 192, i64 32, i32 0, i32 0, null, metadata !43, i32 0, null, null, null} ; [ DW_TAG_structure_type ] [liballoc_minor] [line 80, size 192, align 32, offset 0] [def] [from ]
!43 = metadata !{metadata !44, metadata !45, metadata !46, metadata !47, metadata !48, metadata !49}
!44 = metadata !{i32 786445, metadata !1, metadata !42, metadata !"prev", i32 82, i64 32, i64 32, i64 0, i32 0, metadata !41} ; [ DW_TAG_member ] [prev] [line 82, size 32, align 32, offset 0] [from ]
!45 = metadata !{i32 786445, metadata !1, metadata !42, metadata !"next", i32 83, i64 32, i64 32, i64 32, i32 0, metadata !41} ; [ DW_TAG_member ] [next] [line 83, size 32, align 32, offset 32] [from ]
!46 = metadata !{i32 786445, metadata !1, metadata !42, metadata !"block", i32 84, i64 32, i64 32, i64 64, i32 0, metadata !32} ; [ DW_TAG_member ] [block] [line 84, size 32, align 32, offset 64] [from ]
!47 = metadata !{i32 786445, metadata !1, metadata !42, metadata !"magic", i32 85, i64 32, i64 32, i64 96, i32 0, metadata !10} ; [ DW_TAG_member ] [magic] [line 85, size 32, align 32, offset 96] [from unsigned int]
!48 = metadata !{i32 786445, metadata !1, metadata !42, metadata !"size", i32 86, i64 32, i64 32, i64 128, i32 0, metadata !10} ; [ DW_TAG_member ] [size] [line 86, size 32, align 32, offset 128] [from unsigned int]
!49 = metadata !{i32 786445, metadata !1, metadata !42, metadata !"req_size", i32 87, i64 32, i64 32, i64 160, i32 0, metadata !10} ; [ DW_TAG_member ] [req_size] [line 87, size 32, align 32, offset 160] [from unsigned int]
!50 = metadata !{metadata !51, metadata !53, metadata !55, metadata !56, metadata !57, metadata !58, metadata !59, metadata !60, metadata !61}
!51 = metadata !{i32 786484, i32 0, null, metadata !"l_allocated", metadata !"l_allocated", metadata !"", metadata !5, i32 96, metadata !52, i32 1, i32 1, i64* @l_allocated, null} ; [ DW_TAG_variable ] [l_allocated] [line 96] [local] [def]
!52 = metadata !{i32 786468, null, null, metadata !"long long unsigned int", i32 0, i64 64, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [long long unsigned int] [line 0, size 64, align 32, offset 0, enc DW_ATE_unsigned]
!53 = metadata !{i32 786484, i32 0, null, metadata !"l_possibleOverruns", metadata !"l_possibleOverruns", metadata !"", metadata !5, i32 102, metadata !54, i32 1, i32 1, i64* @l_possibleOverruns, null} ; [ DW_TAG_variable ] [l_possibleOverruns] [line 102] [local] [def]
!54 = metadata !{i32 786468, null, null, metadata !"long long int", i32 0, i64 64, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [long long int] [line 0, size 64, align 32, offset 0, enc DW_ATE_signed]
!55 = metadata !{i32 786484, i32 0, null, metadata !"l_errorCount", metadata !"l_errorCount", metadata !"", metadata !5, i32 101, metadata !54, i32 1, i32 1, i64* @l_errorCount, null} ; [ DW_TAG_variable ] [l_errorCount] [line 101] [local] [def]
!56 = metadata !{i32 786484, i32 0, null, metadata !"l_inuse", metadata !"l_inuse", metadata !"", metadata !5, i32 97, metadata !52, i32 1, i32 1, i64* @l_inuse, null} ; [ DW_TAG_variable ] [l_inuse] [line 97] [local] [def]
!57 = metadata !{i32 786484, i32 0, null, metadata !"l_bestBet", metadata !"l_bestBet", metadata !"", metadata !5, i32 92, metadata !32, i32 1, i32 1, %struct.liballoc_major** @l_bestBet, null} ; [ DW_TAG_variable ] [l_bestBet] [line 92] [local] [def]
!58 = metadata !{i32 786484, i32 0, null, metadata !"l_pageCount", metadata !"l_pageCount", metadata !"", metadata !5, i32 95, metadata !10, i32 1, i32 1, i32* @l_pageCount, null} ; [ DW_TAG_variable ] [l_pageCount] [line 95] [local] [def]
!59 = metadata !{i32 786484, i32 0, null, metadata !"l_pageSize", metadata !"l_pageSize", metadata !"", metadata !5, i32 94, metadata !10, i32 1, i32 1, i32* @l_pageSize, null} ; [ DW_TAG_variable ] [l_pageSize] [line 94] [local] [def]
!60 = metadata !{i32 786484, i32 0, null, metadata !"l_memRoot", metadata !"l_memRoot", metadata !"", metadata !5, i32 91, metadata !32, i32 1, i32 1, %struct.liballoc_major** @l_memRoot, null} ; [ DW_TAG_variable ] [l_memRoot] [line 91] [local] [def]
!61 = metadata !{i32 786484, i32 0, null, metadata !"l_warningCount", metadata !"l_warningCount", metadata !"", metadata !5, i32 100, metadata !54, i32 1, i32 1, i64* @l_warningCount, null} ; [ DW_TAG_variable ] [l_warningCount] [line 100] [local] [def]
!62 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!63 = metadata !{metadata !"clang version 3.4 (http://llvm.org/git/clang.git 82a2911a94947e20ac4fd961b6322adf74ad9224) (http://llvm.org/git/llvm.git 52244da7f2b3def646900520668b859343b84a33)"}
!64 = metadata !{i32 786689, metadata !4, metadata !"req_size", metadata !5, i32 16777460, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [req_size] [line 244]
!65 = metadata !{i32 244, i32 0, metadata !4, null}
!66 = metadata !{i32 786688, metadata !4, metadata !"startedBet", metadata !5, i32 246, metadata !28, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [startedBet] [line 246]
!67 = metadata !{i32 246, i32 0, metadata !4, null}
!68 = metadata !{i32 786688, metadata !4, metadata !"bestSize", metadata !5, i32 247, metadata !52, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [bestSize] [line 247]
!69 = metadata !{i32 247, i32 0, metadata !4, null}
!70 = metadata !{i32 786688, metadata !4, metadata !"p", metadata !5, i32 248, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 248]
!71 = metadata !{i32 248, i32 0, metadata !4, null}
!72 = metadata !{i32 786688, metadata !4, metadata !"diff", metadata !5, i32 249, metadata !73, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [diff] [line 249]
!73 = metadata !{i32 786454, metadata !1, null, metadata !"uintptr_t", i32 271, i64 0, i64 0, i64 0, i32 0, metadata !74} ; [ DW_TAG_typedef ] [uintptr_t] [line 271, size 0, align 0, offset 0] [from uint32_t]
!74 = metadata !{i32 786454, metadata !1, null, metadata !"uint32_t", i32 184, i64 0, i64 0, i64 0, i32 0, metadata !10} ; [ DW_TAG_typedef ] [uint32_t] [line 184, size 0, align 0, offset 0] [from unsigned int]
!75 = metadata !{i32 249, i32 0, metadata !4, null}
!76 = metadata !{i32 786688, metadata !4, metadata !"maj", metadata !5, i32 250, metadata !32, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [maj] [line 250]
!77 = metadata !{i32 250, i32 0, metadata !4, null}
!78 = metadata !{i32 786688, metadata !4, metadata !"min", metadata !5, i32 251, metadata !41, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [min] [line 251]
!79 = metadata !{i32 251, i32 0, metadata !4, null}
!80 = metadata !{i32 786688, metadata !4, metadata !"new_min", metadata !5, i32 252, metadata !41, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [new_min] [line 252]
!81 = metadata !{i32 252, i32 0, metadata !4, null}
!82 = metadata !{i32 786688, metadata !4, metadata !"size", metadata !5, i32 253, metadata !83, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [size] [line 253]
!83 = metadata !{i32 786468, null, null, metadata !"long unsigned int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [long unsigned int] [line 0, size 32, align 32, offset 0, enc DW_ATE_unsigned]
!84 = metadata !{i32 253, i32 0, metadata !4, null}
!85 = metadata !{i32 258, i32 0, metadata !86, null}
!86 = metadata !{i32 786443, metadata !1, metadata !87, i32 257, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!87 = metadata !{i32 786443, metadata !1, metadata !4, i32 256, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!88 = metadata !{i32 263, i32 0, metadata !4, null}
!89 = metadata !{i32 265, i32 0, metadata !90, null}
!90 = metadata !{i32 786443, metadata !1, metadata !4, i32 265, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!91 = metadata !{i32 267, i32 0, metadata !92, null}
!92 = metadata !{i32 786443, metadata !1, metadata !90, i32 266, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!93 = metadata !{i32 273, i32 0, metadata !92, null}
!94 = metadata !{i32 274, i32 0, metadata !92, null}
!95 = metadata !{i32 278, i32 0, metadata !96, null}
!96 = metadata !{i32 786443, metadata !1, metadata !4, i32 278, i32 0, i32 4} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!97 = metadata !{i32 289, i32 0, metadata !98, null}
!98 = metadata !{i32 786443, metadata !1, metadata !96, i32 279, i32 0, i32 5} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!99 = metadata !{i32 290, i32 0, metadata !100, null}
!100 = metadata !{i32 786443, metadata !1, metadata !98, i32 290, i32 0, i32 6} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!101 = metadata !{i32 292, i32 0, metadata !102, null}
!102 = metadata !{i32 786443, metadata !1, metadata !100, i32 291, i32 0, i32 7} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!103 = metadata !{i32 297, i32 0, metadata !102, null}
!104 = metadata !{i32 304, i32 0, metadata !98, null}
!105 = metadata !{i32 316, i32 0, metadata !4, null}
!106 = metadata !{i32 317, i32 0, metadata !4, null}
!107 = metadata !{i32 320, i32 0, metadata !108, null}
!108 = metadata !{i32 786443, metadata !1, metadata !4, i32 320, i32 0, i32 8} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!109 = metadata !{i32 322, i32 0, metadata !110, null}
!110 = metadata !{i32 786443, metadata !1, metadata !108, i32 321, i32 0, i32 9} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!111 = metadata !{i32 324, i32 0, metadata !112, null}
!112 = metadata !{i32 786443, metadata !1, metadata !110, i32 324, i32 0, i32 10} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!113 = metadata !{i32 326, i32 0, metadata !114, null}
!114 = metadata !{i32 786443, metadata !1, metadata !112, i32 325, i32 0, i32 11} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!115 = metadata !{i32 327, i32 0, metadata !114, null}
!116 = metadata !{i32 328, i32 0, metadata !114, null}
!117 = metadata !{i32 329, i32 0, metadata !110, null}
!118 = metadata !{i32 331, i32 0, metadata !4, null}
!119 = metadata !{i32 333, i32 0, metadata !120, null}
!120 = metadata !{i32 786443, metadata !1, metadata !4, i32 332, i32 0, i32 12} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!121 = metadata !{i32 336, i32 0, metadata !122, null}
!122 = metadata !{i32 786443, metadata !1, metadata !120, i32 336, i32 0, i32 13} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!123 = metadata !{i32 339, i32 0, metadata !124, null}
!124 = metadata !{i32 786443, metadata !1, metadata !122, i32 337, i32 0, i32 14} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!125 = metadata !{i32 340, i32 0, metadata !124, null}
!126 = metadata !{i32 341, i32 0, metadata !124, null}
!127 = metadata !{i32 347, i32 0, metadata !128, null}
!128 = metadata !{i32 786443, metadata !1, metadata !120, i32 347, i32 0, i32 15} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!129 = metadata !{i32 355, i32 0, metadata !130, null}
!130 = metadata !{i32 786443, metadata !1, metadata !131, i32 355, i32 0, i32 17} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!131 = metadata !{i32 786443, metadata !1, metadata !128, i32 348, i32 0, i32 16} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!132 = metadata !{i32 357, i32 0, metadata !133, null}
!133 = metadata !{i32 786443, metadata !1, metadata !130, i32 356, i32 0, i32 18} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!134 = metadata !{i32 358, i32 0, metadata !133, null}
!135 = metadata !{i32 361, i32 0, metadata !136, null}
!136 = metadata !{i32 786443, metadata !1, metadata !131, i32 361, i32 0, i32 19} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!137 = metadata !{i32 363, i32 0, metadata !138, null}
!138 = metadata !{i32 786443, metadata !1, metadata !136, i32 362, i32 0, i32 20} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!139 = metadata !{i32 364, i32 0, metadata !138, null}
!140 = metadata !{i32 365, i32 0, metadata !138, null}
!141 = metadata !{i32 369, i32 0, metadata !131, null}
!142 = metadata !{i32 370, i32 0, metadata !143, null}
!143 = metadata !{i32 786443, metadata !1, metadata !131, i32 370, i32 0, i32 21} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!144 = metadata !{i32 371, i32 0, metadata !131, null}
!145 = metadata !{i32 372, i32 0, metadata !131, null}
!146 = metadata !{i32 375, i32 0, metadata !131, null}
!147 = metadata !{i32 382, i32 0, metadata !148, null}
!148 = metadata !{i32 786443, metadata !1, metadata !120, i32 382, i32 0, i32 22} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!149 = metadata !{i32 384, i32 0, metadata !150, null}
!150 = metadata !{i32 786443, metadata !1, metadata !148, i32 383, i32 0, i32 23} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!151 = metadata !{i32 387, i32 0, metadata !150, null}
!152 = metadata !{i32 388, i32 0, metadata !150, null}
!153 = metadata !{i32 389, i32 0, metadata !150, null}
!154 = metadata !{i32 390, i32 0, metadata !150, null}
!155 = metadata !{i32 391, i32 0, metadata !150, null}
!156 = metadata !{i32 392, i32 0, metadata !150, null}
!157 = metadata !{i32 393, i32 0, metadata !150, null}
!158 = metadata !{i32 396, i32 0, metadata !150, null}
!159 = metadata !{i32 399, i32 0, metadata !150, null}
!160 = metadata !{i32 786688, metadata !161, metadata !"diff", metadata !5, i32 401, metadata !73, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [diff] [line 401]
!161 = metadata !{i32 786443, metadata !1, metadata !162, i32 401, i32 0, i32 25} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!162 = metadata !{i32 786443, metadata !1, metadata !150, i32 401, i32 0, i32 24} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!163 = metadata !{i32 401, i32 0, metadata !161, null}
!164 = metadata !{i32 401, i32 0, metadata !165, null}
!165 = metadata !{i32 786443, metadata !1, metadata !161, i32 401, i32 0, i32 26} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!166 = metadata !{i32 401, i32 0, metadata !167, null}
!167 = metadata !{i32 786443, metadata !1, metadata !165, i32 401, i32 0, i32 27} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!168 = metadata !{i32 407, i32 0, metadata !150, null}
!169 = metadata !{i32 408, i32 0, metadata !150, null}
!170 = metadata !{i32 416, i32 0, metadata !120, null}
!171 = metadata !{i32 417, i32 0, metadata !120, null}
!172 = metadata !{i32 418, i32 0, metadata !120, null}
!173 = metadata !{i32 420, i32 0, metadata !174, null}
!174 = metadata !{i32 786443, metadata !1, metadata !120, i32 420, i32 0, i32 28} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!175 = metadata !{i32 423, i32 0, metadata !176, null}
!176 = metadata !{i32 786443, metadata !1, metadata !174, i32 421, i32 0, i32 29} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!177 = metadata !{i32 424, i32 0, metadata !176, null}
!178 = metadata !{i32 425, i32 0, metadata !176, null}
!179 = metadata !{i32 427, i32 0, metadata !176, null}
!180 = metadata !{i32 428, i32 0, metadata !176, null}
!181 = metadata !{i32 429, i32 0, metadata !176, null}
!182 = metadata !{i32 430, i32 0, metadata !176, null}
!183 = metadata !{i32 431, i32 0, metadata !176, null}
!184 = metadata !{i32 432, i32 0, metadata !176, null}
!185 = metadata !{i32 434, i32 0, metadata !176, null}
!186 = metadata !{i32 436, i32 0, metadata !176, null}
!187 = metadata !{i32 786688, metadata !188, metadata !"diff", metadata !5, i32 437, metadata !73, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [diff] [line 437]
!188 = metadata !{i32 786443, metadata !1, metadata !189, i32 437, i32 0, i32 31} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!189 = metadata !{i32 786443, metadata !1, metadata !176, i32 437, i32 0, i32 30} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!190 = metadata !{i32 437, i32 0, metadata !188, null}
!191 = metadata !{i32 437, i32 0, metadata !192, null}
!192 = metadata !{i32 786443, metadata !1, metadata !188, i32 437, i32 0, i32 32} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!193 = metadata !{i32 437, i32 0, metadata !194, null}
!194 = metadata !{i32 786443, metadata !1, metadata !192, i32 437, i32 0, i32 33} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!195 = metadata !{i32 443, i32 0, metadata !176, null}
!196 = metadata !{i32 444, i32 0, metadata !176, null}
!197 = metadata !{i32 453, i32 0, metadata !120, null}
!198 = metadata !{i32 456, i32 0, metadata !120, null}
!199 = metadata !{i32 459, i32 0, metadata !200, null}
!200 = metadata !{i32 786443, metadata !1, metadata !201, i32 459, i32 0, i32 35} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!201 = metadata !{i32 786443, metadata !1, metadata !120, i32 457, i32 0, i32 34} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!202 = metadata !{i32 462, i32 0, metadata !203, null}
!203 = metadata !{i32 786443, metadata !1, metadata !200, i32 460, i32 0, i32 36} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!204 = metadata !{i32 463, i32 0, metadata !203, null}
!205 = metadata !{i32 464, i32 0, metadata !203, null}
!206 = metadata !{i32 465, i32 0, metadata !203, null}
!207 = metadata !{i32 468, i32 0, metadata !208, null}
!208 = metadata !{i32 786443, metadata !1, metadata !203, i32 468, i32 0, i32 37} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!209 = metadata !{i32 471, i32 0, metadata !210, null}
!210 = metadata !{i32 786443, metadata !1, metadata !208, i32 469, i32 0, i32 38} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!211 = metadata !{i32 472, i32 0, metadata !210, null}
!212 = metadata !{i32 473, i32 0, metadata !210, null}
!213 = metadata !{i32 474, i32 0, metadata !210, null}
!214 = metadata !{i32 475, i32 0, metadata !210, null}
!215 = metadata !{i32 476, i32 0, metadata !210, null}
!216 = metadata !{i32 477, i32 0, metadata !210, null}
!217 = metadata !{i32 478, i32 0, metadata !210, null}
!218 = metadata !{i32 479, i32 0, metadata !210, null}
!219 = metadata !{i32 481, i32 0, metadata !210, null}
!220 = metadata !{i32 483, i32 0, metadata !210, null}
!221 = metadata !{i32 786688, metadata !222, metadata !"diff", metadata !5, i32 484, metadata !73, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [diff] [line 484]
!222 = metadata !{i32 786443, metadata !1, metadata !223, i32 484, i32 0, i32 40} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!223 = metadata !{i32 786443, metadata !1, metadata !210, i32 484, i32 0, i32 39} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!224 = metadata !{i32 484, i32 0, metadata !222, null}
!225 = metadata !{i32 484, i32 0, metadata !226, null}
!226 = metadata !{i32 786443, metadata !1, metadata !222, i32 484, i32 0, i32 41} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!227 = metadata !{i32 484, i32 0, metadata !228, null}
!228 = metadata !{i32 786443, metadata !1, metadata !226, i32 484, i32 0, i32 42} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!229 = metadata !{i32 490, i32 0, metadata !210, null}
!230 = metadata !{i32 491, i32 0, metadata !210, null}
!231 = metadata !{i32 493, i32 0, metadata !203, null}
!232 = metadata !{i32 498, i32 0, metadata !233, null}
!233 = metadata !{i32 786443, metadata !1, metadata !201, i32 498, i32 0, i32 43} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!234 = metadata !{i32 501, i32 0, metadata !235, null}
!235 = metadata !{i32 786443, metadata !1, metadata !233, i32 499, i32 0, i32 44} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!236 = metadata !{i32 502, i32 0, metadata !235, null}
!237 = metadata !{i32 503, i32 0, metadata !235, null}
!238 = metadata !{i32 504, i32 0, metadata !235, null}
!239 = metadata !{i32 507, i32 0, metadata !240, null}
!240 = metadata !{i32 786443, metadata !1, metadata !235, i32 507, i32 0, i32 45} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!241 = metadata !{i32 510, i32 0, metadata !242, null}
!242 = metadata !{i32 786443, metadata !1, metadata !240, i32 508, i32 0, i32 46} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!243 = metadata !{i32 512, i32 0, metadata !242, null}
!244 = metadata !{i32 513, i32 0, metadata !242, null}
!245 = metadata !{i32 514, i32 0, metadata !242, null}
!246 = metadata !{i32 515, i32 0, metadata !242, null}
!247 = metadata !{i32 516, i32 0, metadata !242, null}
!248 = metadata !{i32 517, i32 0, metadata !242, null}
!249 = metadata !{i32 518, i32 0, metadata !242, null}
!250 = metadata !{i32 519, i32 0, metadata !242, null}
!251 = metadata !{i32 520, i32 0, metadata !242, null}
!252 = metadata !{i32 522, i32 0, metadata !242, null}
!253 = metadata !{i32 524, i32 0, metadata !242, null}
!254 = metadata !{i32 786688, metadata !255, metadata !"diff", metadata !5, i32 525, metadata !73, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [diff] [line 525]
!255 = metadata !{i32 786443, metadata !1, metadata !256, i32 525, i32 0, i32 48} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!256 = metadata !{i32 786443, metadata !1, metadata !242, i32 525, i32 0, i32 47} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!257 = metadata !{i32 525, i32 0, metadata !255, null}
!258 = metadata !{i32 525, i32 0, metadata !259, null}
!259 = metadata !{i32 786443, metadata !1, metadata !255, i32 525, i32 0, i32 49} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!260 = metadata !{i32 525, i32 0, metadata !261, null}
!261 = metadata !{i32 786443, metadata !1, metadata !259, i32 525, i32 0, i32 50} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!262 = metadata !{i32 533, i32 0, metadata !242, null}
!263 = metadata !{i32 534, i32 0, metadata !242, null}
!264 = metadata !{i32 536, i32 0, metadata !235, null}
!265 = metadata !{i32 538, i32 0, metadata !201, null}
!266 = metadata !{i32 539, i32 0, metadata !201, null}
!267 = metadata !{i32 547, i32 0, metadata !268, null}
!268 = metadata !{i32 786443, metadata !1, metadata !120, i32 547, i32 0, i32 51} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!269 = metadata !{i32 554, i32 0, metadata !270, null}
!270 = metadata !{i32 786443, metadata !1, metadata !271, i32 554, i32 0, i32 53} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!271 = metadata !{i32 786443, metadata !1, metadata !268, i32 548, i32 0, i32 52} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!272 = metadata !{i32 556, i32 0, metadata !273, null}
!273 = metadata !{i32 786443, metadata !1, metadata !270, i32 555, i32 0, i32 54} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!274 = metadata !{i32 557, i32 0, metadata !273, null}
!275 = metadata !{i32 558, i32 0, metadata !273, null}
!276 = metadata !{i32 562, i32 0, metadata !271, null}
!277 = metadata !{i32 563, i32 0, metadata !278, null}
!278 = metadata !{i32 786443, metadata !1, metadata !271, i32 563, i32 0, i32 55} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!279 = metadata !{i32 564, i32 0, metadata !271, null}
!280 = metadata !{i32 566, i32 0, metadata !271, null}
!281 = metadata !{i32 570, i32 0, metadata !120, null}
!282 = metadata !{i32 571, i32 0, metadata !120, null}
!283 = metadata !{i32 575, i32 0, metadata !4, null}
!284 = metadata !{i32 586, i32 0, metadata !4, null}
!285 = metadata !{i32 587, i32 0, metadata !4, null}
!286 = metadata !{i32 786689, metadata !29, metadata !"size", metadata !5, i32 16777404, metadata !10, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [size] [line 188]
!287 = metadata !{i32 188, i32 0, metadata !29, null}
!288 = metadata !{i32 786688, metadata !29, metadata !"st", metadata !5, i32 190, metadata !10, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [st] [line 190]
!289 = metadata !{i32 190, i32 0, metadata !29, null}
!290 = metadata !{i32 786688, metadata !29, metadata !"maj", metadata !5, i32 191, metadata !32, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [maj] [line 191]
!291 = metadata !{i32 191, i32 0, metadata !29, null}
!292 = metadata !{i32 194, i32 0, metadata !29, null}
!293 = metadata !{i32 195, i32 0, metadata !29, null}
!294 = metadata !{i32 198, i32 0, metadata !295, null}
!295 = metadata !{i32 786443, metadata !1, metadata !29, i32 198, i32 0, i32 101} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!296 = metadata !{i32 199, i32 0, metadata !295, null}
!297 = metadata !{i32 201, i32 0, metadata !295, null}
!298 = metadata !{i32 206, i32 0, metadata !299, null}
!299 = metadata !{i32 786443, metadata !1, metadata !29, i32 206, i32 0, i32 102} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!300 = metadata !{i32 208, i32 0, metadata !29, null}
!301 = metadata !{i32 210, i32 0, metadata !302, null}
!302 = metadata !{i32 786443, metadata !1, metadata !29, i32 210, i32 0, i32 103} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!303 = metadata !{i32 212, i32 0, metadata !304, null}
!304 = metadata !{i32 786443, metadata !1, metadata !302, i32 211, i32 0, i32 104} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!305 = metadata !{i32 217, i32 0, metadata !304, null}
!306 = metadata !{i32 220, i32 0, metadata !29, null}
!307 = metadata !{i32 221, i32 0, metadata !29, null}
!308 = metadata !{i32 222, i32 0, metadata !29, null}
!309 = metadata !{i32 223, i32 0, metadata !29, null}
!310 = metadata !{i32 224, i32 0, metadata !29, null}
!311 = metadata !{i32 225, i32 0, metadata !29, null}
!312 = metadata !{i32 227, i32 0, metadata !29, null}
!313 = metadata !{i32 237, i32 0, metadata !29, null}
!314 = metadata !{i32 238, i32 0, metadata !29, null}
!315 = metadata !{i32 786689, metadata !11, metadata !"ptr", metadata !5, i32 16777813, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [ptr] [line 597]
!316 = metadata !{i32 597, i32 0, metadata !11, null}
!317 = metadata !{i32 786688, metadata !11, metadata !"min", metadata !5, i32 599, metadata !41, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [min] [line 599]
!318 = metadata !{i32 599, i32 0, metadata !11, null}
!319 = metadata !{i32 786688, metadata !11, metadata !"maj", metadata !5, i32 600, metadata !32, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [maj] [line 600]
!320 = metadata !{i32 600, i32 0, metadata !11, null}
!321 = metadata !{i32 602, i32 0, metadata !322, null}
!322 = metadata !{i32 786443, metadata !1, metadata !11, i32 602, i32 0, i32 56} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!323 = metadata !{i32 604, i32 0, metadata !324, null}
!324 = metadata !{i32 786443, metadata !1, metadata !322, i32 603, i32 0, i32 57} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!325 = metadata !{i32 610, i32 0, metadata !324, null}
!326 = metadata !{i32 786688, metadata !327, metadata !"diff", metadata !5, i32 613, metadata !73, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [diff] [line 613]
!327 = metadata !{i32 786443, metadata !1, metadata !328, i32 613, i32 0, i32 59} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!328 = metadata !{i32 786443, metadata !1, metadata !11, i32 613, i32 0, i32 58} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!329 = metadata !{i32 613, i32 0, metadata !327, null}
!330 = metadata !{i32 613, i32 0, metadata !331, null}
!331 = metadata !{i32 786443, metadata !1, metadata !327, i32 613, i32 0, i32 60} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!332 = metadata !{i32 613, i32 0, metadata !333, null}
!333 = metadata !{i32 786443, metadata !1, metadata !331, i32 613, i32 0, i32 61} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!334 = metadata !{i32 615, i32 0, metadata !11, null}
!335 = metadata !{i32 618, i32 0, metadata !11, null}
!336 = metadata !{i32 621, i32 0, metadata !337, null}
!337 = metadata !{i32 786443, metadata !1, metadata !11, i32 621, i32 0, i32 62} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!338 = metadata !{i32 623, i32 0, metadata !339, null}
!339 = metadata !{i32 786443, metadata !1, metadata !337, i32 622, i32 0, i32 63} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!340 = metadata !{i32 626, i32 0, metadata !341, null}
!341 = metadata !{i32 786443, metadata !1, metadata !339, i32 626, i32 0, i32 64} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!342 = metadata !{i32 632, i32 0, metadata !343, null}
!343 = metadata !{i32 786443, metadata !1, metadata !341, i32 631, i32 0, i32 65} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!344 = metadata !{i32 639, i32 0, metadata !343, null}
!345 = metadata !{i32 642, i32 0, metadata !346, null}
!346 = metadata !{i32 786443, metadata !1, metadata !339, i32 642, i32 0, i32 66} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!347 = metadata !{i32 650, i32 0, metadata !348, null}
!348 = metadata !{i32 786443, metadata !1, metadata !346, i32 643, i32 0, i32 67} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!349 = metadata !{i32 662, i32 0, metadata !339, null}
!350 = metadata !{i32 663, i32 0, metadata !339, null}
!351 = metadata !{i32 674, i32 0, metadata !11, null}
!352 = metadata !{i32 676, i32 0, metadata !11, null}
!353 = metadata !{i32 678, i32 0, metadata !11, null}
!354 = metadata !{i32 679, i32 0, metadata !11, null}
!355 = metadata !{i32 681, i32 0, metadata !356, null}
!356 = metadata !{i32 786443, metadata !1, metadata !11, i32 681, i32 0, i32 69} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!357 = metadata !{i32 682, i32 0, metadata !358, null}
!358 = metadata !{i32 786443, metadata !1, metadata !11, i32 682, i32 0, i32 70} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!359 = metadata !{i32 684, i32 0, metadata !360, null}
!360 = metadata !{i32 786443, metadata !1, metadata !11, i32 684, i32 0, i32 71} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!361 = metadata !{i32 691, i32 0, metadata !362, null}
!362 = metadata !{i32 786443, metadata !1, metadata !11, i32 691, i32 0, i32 72} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!363 = metadata !{i32 693, i32 0, metadata !364, null}
!364 = metadata !{i32 786443, metadata !1, metadata !365, i32 693, i32 0, i32 74} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!365 = metadata !{i32 786443, metadata !1, metadata !362, i32 692, i32 0, i32 73} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!366 = metadata !{i32 694, i32 0, metadata !367, null}
!367 = metadata !{i32 786443, metadata !1, metadata !365, i32 694, i32 0, i32 75} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!368 = metadata !{i32 695, i32 0, metadata !369, null}
!369 = metadata !{i32 786443, metadata !1, metadata !365, i32 695, i32 0, i32 76} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!370 = metadata !{i32 696, i32 0, metadata !371, null}
!371 = metadata !{i32 786443, metadata !1, metadata !365, i32 696, i32 0, i32 77} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!372 = metadata !{i32 697, i32 0, metadata !365, null}
!373 = metadata !{i32 699, i32 0, metadata !365, null}
!374 = metadata !{i32 700, i32 0, metadata !365, null}
!375 = metadata !{i32 703, i32 0, metadata !376, null}
!376 = metadata !{i32 786443, metadata !1, metadata !377, i32 703, i32 0, i32 79} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!377 = metadata !{i32 786443, metadata !1, metadata !362, i32 702, i32 0, i32 78} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!378 = metadata !{i32 786688, metadata !379, metadata !"bestSize", metadata !5, i32 705, metadata !28, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [bestSize] [line 705]
!379 = metadata !{i32 786443, metadata !1, metadata !376, i32 704, i32 0, i32 80} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!380 = metadata !{i32 705, i32 0, metadata !379, null}
!381 = metadata !{i32 786688, metadata !379, metadata !"majSize", metadata !5, i32 706, metadata !28, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [majSize] [line 706]
!382 = metadata !{i32 706, i32 0, metadata !379, null}
!383 = metadata !{i32 708, i32 0, metadata !384, null}
!384 = metadata !{i32 786443, metadata !1, metadata !379, i32 708, i32 0, i32 81} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!385 = metadata !{i32 709, i32 0, metadata !379, null}
!386 = metadata !{i32 719, i32 0, metadata !11, null}
!387 = metadata !{i32 720, i32 0, metadata !11, null}
!388 = metadata !{i32 786689, metadata !14, metadata !"nobj", metadata !5, i32 16777942, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [nobj] [line 726]
!389 = metadata !{i32 726, i32 0, metadata !14, null}
!390 = metadata !{i32 786689, metadata !14, metadata !"size", metadata !5, i32 33555158, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [size] [line 726]
!391 = metadata !{i32 786688, metadata !14, metadata !"real_size", metadata !5, i32 728, metadata !28, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [real_size] [line 728]
!392 = metadata !{i32 728, i32 0, metadata !14, null}
!393 = metadata !{i32 786688, metadata !14, metadata !"p", metadata !5, i32 729, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 729]
!394 = metadata !{i32 729, i32 0, metadata !14, null}
!395 = metadata !{i32 731, i32 0, metadata !14, null}
!396 = metadata !{i32 733, i32 0, metadata !14, null}
!397 = metadata !{i32 735, i32 0, metadata !14, null}
!398 = metadata !{i32 737, i32 0, metadata !14, null}
!399 = metadata !{i32 786689, metadata !25, metadata !"s", metadata !5, i32 16777326, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [s] [line 110]
!400 = metadata !{i32 110, i32 0, metadata !25, null}
!401 = metadata !{i32 786689, metadata !25, metadata !"c", metadata !5, i32 33554542, metadata !28, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [c] [line 110]
!402 = metadata !{i32 786689, metadata !25, metadata !"n", metadata !5, i32 50331758, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [n] [line 110]
!403 = metadata !{i32 786688, metadata !25, metadata !"i", metadata !5, i32 112, metadata !10, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 112]
!404 = metadata !{i32 112, i32 0, metadata !25, null}
!405 = metadata !{i32 113, i32 0, metadata !406, null}
!406 = metadata !{i32 786443, metadata !1, metadata !25, i32 113, i32 0, i32 100} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!407 = metadata !{i32 114, i32 0, metadata !406, null}
!408 = metadata !{i32 116, i32 0, metadata !25, null}
!409 = metadata !{i32 786689, metadata !17, metadata !"p", metadata !5, i32 16777958, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [p] [line 742]
!410 = metadata !{i32 742, i32 0, metadata !17, null}
!411 = metadata !{i32 786689, metadata !17, metadata !"size", metadata !5, i32 33555174, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [size] [line 742]
!412 = metadata !{i32 786688, metadata !17, metadata !"ptr", metadata !5, i32 744, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [ptr] [line 744]
!413 = metadata !{i32 744, i32 0, metadata !17, null}
!414 = metadata !{i32 786688, metadata !17, metadata !"min", metadata !5, i32 745, metadata !41, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [min] [line 745]
!415 = metadata !{i32 745, i32 0, metadata !17, null}
!416 = metadata !{i32 786688, metadata !17, metadata !"real_size", metadata !5, i32 746, metadata !10, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [real_size] [line 746]
!417 = metadata !{i32 746, i32 0, metadata !17, null}
!418 = metadata !{i32 749, i32 0, metadata !419, null}
!419 = metadata !{i32 786443, metadata !1, metadata !17, i32 749, i32 0, i32 82} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!420 = metadata !{i32 751, i32 0, metadata !421, null}
!421 = metadata !{i32 786443, metadata !1, metadata !419, i32 750, i32 0, i32 83} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!422 = metadata !{i32 752, i32 0, metadata !421, null}
!423 = metadata !{i32 756, i32 0, metadata !424, null}
!424 = metadata !{i32 786443, metadata !1, metadata !17, i32 756, i32 0, i32 84} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!425 = metadata !{i32 759, i32 0, metadata !17, null}
!426 = metadata !{i32 786688, metadata !427, metadata !"diff", metadata !5, i32 760, metadata !73, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [diff] [line 760]
!427 = metadata !{i32 786443, metadata !1, metadata !428, i32 760, i32 0, i32 86} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!428 = metadata !{i32 786443, metadata !1, metadata !17, i32 760, i32 0, i32 85} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!429 = metadata !{i32 760, i32 0, metadata !427, null}
!430 = metadata !{i32 760, i32 0, metadata !431, null}
!431 = metadata !{i32 786443, metadata !1, metadata !427, i32 760, i32 0, i32 87} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!432 = metadata !{i32 760, i32 0, metadata !433, null}
!433 = metadata !{i32 786443, metadata !1, metadata !431, i32 760, i32 0, i32 88} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!434 = metadata !{i32 762, i32 0, metadata !17, null}
!435 = metadata !{i32 764, i32 0, metadata !17, null}
!436 = metadata !{i32 767, i32 0, metadata !437, null}
!437 = metadata !{i32 786443, metadata !1, metadata !17, i32 767, i32 0, i32 89} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!438 = metadata !{i32 769, i32 0, metadata !439, null}
!439 = metadata !{i32 786443, metadata !1, metadata !437, i32 768, i32 0, i32 90} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!440 = metadata !{i32 772, i32 0, metadata !441, null}
!441 = metadata !{i32 786443, metadata !1, metadata !439, i32 772, i32 0, i32 91} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!442 = metadata !{i32 778, i32 0, metadata !443, null}
!443 = metadata !{i32 786443, metadata !1, metadata !441, i32 777, i32 0, i32 92} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!444 = metadata !{i32 785, i32 0, metadata !443, null}
!445 = metadata !{i32 788, i32 0, metadata !446, null}
!446 = metadata !{i32 786443, metadata !1, metadata !439, i32 788, i32 0, i32 93} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!447 = metadata !{i32 796, i32 0, metadata !448, null}
!448 = metadata !{i32 786443, metadata !1, metadata !446, i32 789, i32 0, i32 94} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!449 = metadata !{i32 808, i32 0, metadata !439, null}
!450 = metadata !{i32 809, i32 0, metadata !439, null}
!451 = metadata !{i32 814, i32 0, metadata !17, null}
!452 = metadata !{i32 816, i32 0, metadata !453, null}
!453 = metadata !{i32 786443, metadata !1, metadata !17, i32 816, i32 0, i32 96} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!454 = metadata !{i32 818, i32 0, metadata !455, null}
!455 = metadata !{i32 786443, metadata !1, metadata !453, i32 817, i32 0, i32 97} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!456 = metadata !{i32 819, i32 0, metadata !455, null}
!457 = metadata !{i32 820, i32 0, metadata !455, null}
!458 = metadata !{i32 823, i32 0, metadata !17, null}
!459 = metadata !{i32 826, i32 0, metadata !17, null}
!460 = metadata !{i32 827, i32 0, metadata !17, null}
!461 = metadata !{i32 828, i32 0, metadata !17, null}
!462 = metadata !{i32 830, i32 0, metadata !17, null}
!463 = metadata !{i32 831, i32 0, metadata !17, null}
!464 = metadata !{i32 786689, metadata !20, metadata !"s1", metadata !5, i32 16777334, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [s1] [line 118]
!465 = metadata !{i32 118, i32 0, metadata !20, null}
!466 = metadata !{i32 786689, metadata !20, metadata !"s2", metadata !5, i32 33554550, metadata !23, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [s2] [line 118]
!467 = metadata !{i32 786689, metadata !20, metadata !"n", metadata !5, i32 50331766, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [n] [line 118]
!468 = metadata !{i32 786688, metadata !20, metadata !"cdest", metadata !5, i32 120, metadata !469, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [cdest] [line 120]
!469 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, metadata !470} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from char]
!470 = metadata !{i32 786468, null, null, metadata !"char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!471 = metadata !{i32 120, i32 0, metadata !20, null}
!472 = metadata !{i32 786688, metadata !20, metadata !"csrc", metadata !5, i32 121, metadata !469, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [csrc] [line 121]
!473 = metadata !{i32 121, i32 0, metadata !20, null}
!474 = metadata !{i32 786688, metadata !20, metadata !"ldest", metadata !5, i32 122, metadata !475, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [ldest] [line 122]
!475 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, metadata !10} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from unsigned int]
!476 = metadata !{i32 122, i32 0, metadata !20, null}
!477 = metadata !{i32 786688, metadata !20, metadata !"lsrc", metadata !5, i32 123, metadata !475, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [lsrc] [line 123]
!478 = metadata !{i32 123, i32 0, metadata !20, null}
!479 = metadata !{i32 125, i32 0, metadata !20, null}
!480 = metadata !{i32 127, i32 0, metadata !481, null}
!481 = metadata !{i32 786443, metadata !1, metadata !20, i32 126, i32 0, i32 98} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!482 = metadata !{i32 128, i32 0, metadata !481, null}
!483 = metadata !{i32 129, i32 0, metadata !481, null}
!484 = metadata !{i32 131, i32 0, metadata !20, null}
!485 = metadata !{i32 132, i32 0, metadata !20, null}
!486 = metadata !{i32 134, i32 0, metadata !20, null}
!487 = metadata !{i32 136, i32 0, metadata !488, null}
!488 = metadata !{i32 786443, metadata !1, metadata !20, i32 135, i32 0, i32 99} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/liballoc.c]
!489 = metadata !{i32 137, i32 0, metadata !488, null}
!490 = metadata !{i32 138, i32 0, metadata !488, null}
!491 = metadata !{i32 140, i32 0, metadata !20, null}
