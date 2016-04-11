; ModuleID = 'src/paging.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i686-pc-none-elf"

%struct.page_dict_t = type { %union.anon }
%union.anon = type { i32 }
%struct.anon = type { [4 x i8] }

@open_pages_map = global [32 x i32] zeroinitializer, align 4
@BootPageDirectory = external global %struct.page_dict_t

; Function Attrs: nounwind
define i32 @getpagesize() #0 {
entry:
  ret i32 1048576, !dbg !38
}

; Function Attrs: nounwind
define i8* @kmmap(i32 %n_pages) #0 {
entry:
  %n_pages.addr = alloca i32, align 4
  store i32 %n_pages, i32* %n_pages.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %n_pages.addr}, metadata !39), !dbg !40
  %0 = load i32* %n_pages.addr, align 4, !dbg !41
  %call = call i8* @mmap(i32 %0, i8* inttoptr (i32 -1073741824 to i8*)) #4, !dbg !41
  ret i8* %call, !dbg !41
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

; Function Attrs: nounwind
define i8* @mmap(i32 %n_pages, i8* %addr_base) #0 {
entry:
  %retval = alloca i8*, align 4
  %n_pages.addr = alloca i32, align 4
  %addr_base.addr = alloca i8*, align 4
  %kpage_root = alloca %struct.page_dict_t*, align 4
  %phys_page = alloca i32, align 4
  %page_ok = alloca i8, align 1
  %i = alloca i32, align 4
  %start_virt_entry = alloca i32, align 4
  %virt_base_addr = alloca i32, align 4
  %page_ok15 = alloca i8, align 1
  %i16 = alloca i32, align 4
  %entry20 = alloca %struct.page_dict_t*, align 4
  %i33 = alloca i32, align 4
  %phys_addr = alloca i32, align 4
  %entry39 = alloca %struct.page_dict_t*, align 4
  store i32 %n_pages, i32* %n_pages.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %n_pages.addr}, metadata !42), !dbg !43
  store i8* %addr_base, i8** %addr_base.addr, align 4
  call void @llvm.dbg.declare(metadata !{i8** %addr_base.addr}, metadata !44), !dbg !43
  call void @llvm.dbg.declare(metadata !{%struct.page_dict_t** %kpage_root}, metadata !45), !dbg !69
  store %struct.page_dict_t* @BootPageDirectory, %struct.page_dict_t** %kpage_root, align 4, !dbg !69
  call void @llvm.dbg.declare(metadata !{i32* %phys_page}, metadata !70), !dbg !71
  store i32 1, i32* %phys_page, align 4, !dbg !71
  call void @llvm.dbg.declare(metadata !{i8* %page_ok}, metadata !72), !dbg !73
  store i8 1, i8* %page_ok, align 1, !dbg !73
  br label %for.cond, !dbg !74

for.cond:                                         ; preds = %for.inc6, %entry
  %0 = load i32* %phys_page, align 4, !dbg !74
  %cmp = icmp slt i32 %0, 1024, !dbg !74
  br i1 %cmp, label %for.body, label %for.end8, !dbg !74

for.body:                                         ; preds = %for.cond
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !76), !dbg !79
  store i32 0, i32* %i, align 4, !dbg !79
  br label %for.cond1, !dbg !79

for.cond1:                                        ; preds = %for.inc, %for.body
  %1 = load i32* %i, align 4, !dbg !79
  %2 = load i32* %n_pages.addr, align 4, !dbg !79
  %cmp2 = icmp slt i32 %1, %2, !dbg !79
  br i1 %cmp2, label %for.body3, label %for.end, !dbg !79

for.body3:                                        ; preds = %for.cond1
  %3 = load i32* %phys_page, align 4, !dbg !80
  %shl = shl i32 %3, 22, !dbg !80
  %4 = inttoptr i32 %shl to i8*, !dbg !80
  %call = call zeroext i1 @is_paddress_mapped(i8* %4) #4, !dbg !80
  br i1 %call, label %if.then, label %if.end, !dbg !80

if.then:                                          ; preds = %for.body3
  store i8 0, i8* %page_ok, align 1, !dbg !83
  br label %if.end, !dbg !85

if.end:                                           ; preds = %if.then, %for.body3
  br label %for.inc, !dbg !86

for.inc:                                          ; preds = %if.end
  %5 = load i32* %i, align 4, !dbg !79
  %inc = add nsw i32 %5, 1, !dbg !79
  store i32 %inc, i32* %i, align 4, !dbg !79
  br label %for.cond1, !dbg !79

for.end:                                          ; preds = %for.cond1
  %6 = load i8* %page_ok, align 1, !dbg !87
  %tobool = trunc i8 %6 to i1, !dbg !87
  br i1 %tobool, label %if.then4, label %if.end5, !dbg !87

if.then4:                                         ; preds = %for.end
  br label %for.end8, !dbg !89

if.end5:                                          ; preds = %for.end
  br label %for.inc6, !dbg !91

for.inc6:                                         ; preds = %if.end5
  %7 = load i32* %phys_page, align 4, !dbg !74
  %inc7 = add nsw i32 %7, 1, !dbg !74
  store i32 %inc7, i32* %phys_page, align 4, !dbg !74
  br label %for.cond, !dbg !74

for.end8:                                         ; preds = %if.then4, %for.cond
  %8 = load i8* %page_ok, align 1, !dbg !92
  %tobool9 = trunc i8 %8 to i1, !dbg !92
  br i1 %tobool9, label %if.end11, label %if.then10, !dbg !92

if.then10:                                        ; preds = %for.end8
  store i8* null, i8** %retval, !dbg !94
  br label %return, !dbg !94

if.end11:                                         ; preds = %for.end8
  call void @llvm.dbg.declare(metadata !{i32* %start_virt_entry}, metadata !96), !dbg !97
  %9 = load i8** %addr_base.addr, align 4, !dbg !97
  %10 = ptrtoint i8* %9 to i32, !dbg !97
  %shr = lshr i32 %10, 22, !dbg !97
  store i32 %shr, i32* %start_virt_entry, align 4, !dbg !97
  call void @llvm.dbg.declare(metadata !{i32* %virt_base_addr}, metadata !98), !dbg !99
  %11 = load i8** %addr_base.addr, align 4, !dbg !99
  %12 = ptrtoint i8* %11 to i32, !dbg !99
  store i32 %12, i32* %virt_base_addr, align 4, !dbg !99
  br label %for.cond12, !dbg !100

for.cond12:                                       ; preds = %for.inc30, %if.end11
  %13 = load i32* %start_virt_entry, align 4, !dbg !100
  %cmp13 = icmp ult i32 %13, 1024, !dbg !100
  br i1 %cmp13, label %for.body14, label %for.end32, !dbg !100

for.body14:                                       ; preds = %for.cond12
  call void @llvm.dbg.declare(metadata !{i8* %page_ok15}, metadata !102), !dbg !104
  store i8 1, i8* %page_ok15, align 1, !dbg !104
  call void @llvm.dbg.declare(metadata !{i32* %i16}, metadata !105), !dbg !107
  store i32 0, i32* %i16, align 4, !dbg !107
  br label %for.cond17, !dbg !107

for.cond17:                                       ; preds = %for.inc24, %for.body14
  %14 = load i32* %i16, align 4, !dbg !107
  %15 = load i32* %n_pages.addr, align 4, !dbg !107
  %cmp18 = icmp slt i32 %14, %15, !dbg !107
  br i1 %cmp18, label %for.body19, label %for.end26, !dbg !107

for.body19:                                       ; preds = %for.cond17
  call void @llvm.dbg.declare(metadata !{%struct.page_dict_t** %entry20}, metadata !108), !dbg !110
  %16 = load i32* %start_virt_entry, align 4, !dbg !110
  %17 = load i32* %i16, align 4, !dbg !110
  %add = add i32 %16, %17, !dbg !110
  %18 = load %struct.page_dict_t** %kpage_root, align 4, !dbg !110
  %arrayidx = getelementptr inbounds %struct.page_dict_t* %18, i32 %add, !dbg !110
  store %struct.page_dict_t* %arrayidx, %struct.page_dict_t** %entry20, align 4, !dbg !110
  %19 = load %struct.page_dict_t** %entry20, align 4, !dbg !111
  %20 = getelementptr inbounds %struct.page_dict_t* %19, i32 0, i32 0, !dbg !111
  %21 = bitcast %union.anon* %20 to %struct.anon*, !dbg !111
  %22 = bitcast %struct.anon* %21 to i32*, !dbg !111
  %bf.load = load i32* %22, align 4, !dbg !111
  %bf.clear = and i32 %bf.load, 1, !dbg !111
  %tobool21 = icmp ne i32 %bf.clear, 0, !dbg !111
  br i1 %tobool21, label %if.then22, label %if.end23, !dbg !111

if.then22:                                        ; preds = %for.body19
  store i8 0, i8* %page_ok15, align 1, !dbg !113
  br label %if.end23, !dbg !115

if.end23:                                         ; preds = %if.then22, %for.body19
  br label %for.inc24, !dbg !116

for.inc24:                                        ; preds = %if.end23
  %23 = load i32* %i16, align 4, !dbg !107
  %inc25 = add nsw i32 %23, 1, !dbg !107
  store i32 %inc25, i32* %i16, align 4, !dbg !107
  br label %for.cond17, !dbg !107

for.end26:                                        ; preds = %for.cond17
  %24 = load i8* %page_ok15, align 1, !dbg !117
  %tobool27 = trunc i8 %24 to i1, !dbg !117
  br i1 %tobool27, label %if.then28, label %if.end29, !dbg !117

if.then28:                                        ; preds = %for.end26
  br label %for.end32, !dbg !119

if.end29:                                         ; preds = %for.end26
  br label %for.inc30, !dbg !121

for.inc30:                                        ; preds = %if.end29
  %25 = load i32* %start_virt_entry, align 4, !dbg !100
  %inc31 = add i32 %25, 1, !dbg !100
  store i32 %inc31, i32* %start_virt_entry, align 4, !dbg !100
  br label %for.cond12, !dbg !100

for.end32:                                        ; preds = %if.then28, %for.cond12
  call void @llvm.dbg.declare(metadata !{i32* %i33}, metadata !122), !dbg !124
  store i32 0, i32* %i33, align 4, !dbg !124
  br label %for.cond34, !dbg !124

for.cond34:                                       ; preds = %for.inc50, %for.end32
  %26 = load i32* %i33, align 4, !dbg !124
  %27 = load i32* %n_pages.addr, align 4, !dbg !124
  %cmp35 = icmp slt i32 %26, %27, !dbg !124
  br i1 %cmp35, label %for.body36, label %for.end52, !dbg !124

for.body36:                                       ; preds = %for.cond34
  call void @llvm.dbg.declare(metadata !{i32* %phys_addr}, metadata !125), !dbg !127
  %28 = load i32* %phys_page, align 4, !dbg !127
  %29 = load i32* %i33, align 4, !dbg !127
  %add37 = add nsw i32 %28, %29, !dbg !127
  %shl38 = shl i32 %add37, 22, !dbg !127
  store i32 %shl38, i32* %phys_addr, align 4, !dbg !127
  call void @llvm.dbg.declare(metadata !{%struct.page_dict_t** %entry39}, metadata !128), !dbg !129
  %30 = load i32* %start_virt_entry, align 4, !dbg !129
  %31 = load i32* %i33, align 4, !dbg !129
  %add40 = add i32 %30, %31, !dbg !129
  %32 = load %struct.page_dict_t** %kpage_root, align 4, !dbg !129
  %arrayidx41 = getelementptr inbounds %struct.page_dict_t* %32, i32 %add40, !dbg !129
  store %struct.page_dict_t* %arrayidx41, %struct.page_dict_t** %entry39, align 4, !dbg !129
  %33 = load %struct.page_dict_t** %entry39, align 4, !dbg !130
  %34 = getelementptr inbounds %struct.page_dict_t* %33, i32 0, i32 0, !dbg !130
  %35 = bitcast %union.anon* %34 to %struct.anon*, !dbg !130
  %36 = bitcast %struct.anon* %35 to i32*, !dbg !130
  %bf.load42 = load i32* %36, align 4, !dbg !130
  %bf.clear43 = and i32 %bf.load42, -2, !dbg !130
  %bf.set = or i32 %bf.clear43, 1, !dbg !130
  store i32 %bf.set, i32* %36, align 4, !dbg !130
  %37 = load %struct.page_dict_t** %entry39, align 4, !dbg !131
  %38 = getelementptr inbounds %struct.page_dict_t* %37, i32 0, i32 0, !dbg !131
  %39 = bitcast %union.anon* %38 to %struct.anon*, !dbg !131
  %40 = bitcast %struct.anon* %39 to i32*, !dbg !131
  %bf.load44 = load i32* %40, align 4, !dbg !131
  %bf.clear45 = and i32 %bf.load44, -3, !dbg !131
  %bf.set46 = or i32 %bf.clear45, 2, !dbg !131
  store i32 %bf.set46, i32* %40, align 4, !dbg !131
  %41 = load %struct.page_dict_t** %entry39, align 4, !dbg !132
  %42 = getelementptr inbounds %struct.page_dict_t* %41, i32 0, i32 0, !dbg !132
  %43 = bitcast %union.anon* %42 to %struct.anon*, !dbg !132
  %44 = bitcast %struct.anon* %43 to i32*, !dbg !132
  %bf.load47 = load i32* %44, align 4, !dbg !132
  %bf.clear48 = and i32 %bf.load47, -129, !dbg !132
  %bf.set49 = or i32 %bf.clear48, 128, !dbg !132
  store i32 %bf.set49, i32* %44, align 4, !dbg !132
  %45 = load i32* %phys_addr, align 4, !dbg !133
  %46 = load %struct.page_dict_t** %entry39, align 4, !dbg !133
  %47 = getelementptr inbounds %struct.page_dict_t* %46, i32 0, i32 0, !dbg !133
  %u32 = bitcast %union.anon* %47 to i32*, !dbg !133
  %48 = load i32* %u32, align 4, !dbg !133
  %or = or i32 %48, %45, !dbg !133
  store i32 %or, i32* %u32, align 4, !dbg !133
  %49 = load i32* %phys_addr, align 4, !dbg !134
  %50 = inttoptr i32 %49 to i8*, !dbg !134
  call void @invlpg(i8* %50) #4, !dbg !134
  br label %for.inc50, !dbg !135

for.inc50:                                        ; preds = %for.body36
  %51 = load i32* %i33, align 4, !dbg !124
  %inc51 = add nsw i32 %51, 1, !dbg !124
  store i32 %inc51, i32* %i33, align 4, !dbg !124
  br label %for.cond34, !dbg !124

for.end52:                                        ; preds = %for.cond34
  %52 = load i32* %start_virt_entry, align 4, !dbg !136
  %shl53 = shl i32 %52, 22, !dbg !136
  %53 = inttoptr i32 %shl53 to i8*, !dbg !136
  store i8* %53, i8** %retval, !dbg !136
  br label %return, !dbg !136

return:                                           ; preds = %for.end52, %if.then10
  %54 = load i8** %retval, !dbg !137
  ret i8* %54, !dbg !137
}

; Function Attrs: nounwind
define zeroext i1 @is_paddress_mapped(i8* %addr) #0 {
entry:
  %addr.addr = alloca i8*, align 4
  %addr_u = alloca i32, align 4
  store i8* %addr, i8** %addr.addr, align 4
  call void @llvm.dbg.declare(metadata !{i8** %addr.addr}, metadata !138), !dbg !139
  call void @llvm.dbg.declare(metadata !{i32* %addr_u}, metadata !140), !dbg !141
  %0 = load i8** %addr.addr, align 4, !dbg !141
  %1 = ptrtoint i8* %0 to i32, !dbg !141
  %shr = lshr i32 %1, 22, !dbg !141
  store i32 %shr, i32* %addr_u, align 4, !dbg !141
  %2 = load i32* %addr_u, align 4, !dbg !142
  %call = call i32 @bm_get_bit(i32* getelementptr inbounds ([32 x i32]* @open_pages_map, i32 0, i32 0), i32 %2) #4, !dbg !142
  %tobool = icmp ne i32 %call, 0, !dbg !142
  ret i1 %tobool, !dbg !142
}

declare i32 @bm_get_bit(i32*, i32) #2

; Function Attrs: nounwind
define void @set_paddress_mapped(i8* %addr, i1 zeroext %mapped) #0 {
entry:
  %addr.addr = alloca i8*, align 4
  %mapped.addr = alloca i8, align 1
  %addr_u = alloca i32, align 4
  store i8* %addr, i8** %addr.addr, align 4
  call void @llvm.dbg.declare(metadata !{i8** %addr.addr}, metadata !143), !dbg !144
  %frombool = zext i1 %mapped to i8
  store i8 %frombool, i8* %mapped.addr, align 1
  call void @llvm.dbg.declare(metadata !{i8* %mapped.addr}, metadata !145), !dbg !144
  call void @llvm.dbg.declare(metadata !{i32* %addr_u}, metadata !146), !dbg !147
  %0 = load i8** %addr.addr, align 4, !dbg !147
  %1 = ptrtoint i8* %0 to i32, !dbg !147
  %shr = lshr i32 %1, 22, !dbg !147
  store i32 %shr, i32* %addr_u, align 4, !dbg !147
  %2 = load i8* %mapped.addr, align 1, !dbg !148
  %tobool = trunc i8 %2 to i1, !dbg !148
  br i1 %tobool, label %if.then, label %if.else, !dbg !148

if.then:                                          ; preds = %entry
  %3 = load i32* %addr_u, align 4, !dbg !150
  call void @bm_set_bit(i32* getelementptr inbounds ([32 x i32]* @open_pages_map, i32 0, i32 0), i32 %3) #4, !dbg !150
  br label %if.end, !dbg !152

if.else:                                          ; preds = %entry
  %4 = load i32* %addr_u, align 4, !dbg !153
  call void @bm_clear_bit(i32* getelementptr inbounds ([32 x i32]* @open_pages_map, i32 0, i32 0), i32 %4) #4, !dbg !153
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret void, !dbg !155
}

declare void @bm_set_bit(i32*, i32) #2

declare void @bm_clear_bit(i32*, i32) #2

; Function Attrs: inlinehint nounwind
define internal void @invlpg(i8* %m) #3 {
entry:
  %m.addr = alloca i8*, align 4
  store i8* %m, i8** %m.addr, align 4
  call void @llvm.dbg.declare(metadata !{i8** %m.addr}, metadata !156), !dbg !157
  %0 = load i8** %m.addr, align 4, !dbg !158
  call void asm sideeffect "invlpg ($0)", "{bx},~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %0) #5, !dbg !158, !srcloc !159
  ret void, !dbg !160
}

; Function Attrs: nounwind
define zeroext i1 @munmap(i8* %addr, i32 %n_pages) #0 {
entry:
  %addr.addr = alloca i8*, align 4
  %n_pages.addr = alloca i32, align 4
  %mmaped_addr = alloca i32, align 4
  %kpage_root = alloca %struct.page_dict_t*, align 4
  %kpage_entry = alloca i32, align 4
  %i = alloca i32, align 4
  %entry1 = alloca %struct.page_dict_t*, align 4
  %phys_addr = alloca i32, align 4
  store i8* %addr, i8** %addr.addr, align 4
  call void @llvm.dbg.declare(metadata !{i8** %addr.addr}, metadata !161), !dbg !162
  store i32 %n_pages, i32* %n_pages.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %n_pages.addr}, metadata !163), !dbg !162
  call void @llvm.dbg.declare(metadata !{i32* %mmaped_addr}, metadata !164), !dbg !165
  %0 = load i8** %addr.addr, align 4, !dbg !165
  %1 = ptrtoint i8* %0 to i32, !dbg !165
  store i32 %1, i32* %mmaped_addr, align 4, !dbg !165
  call void @llvm.dbg.declare(metadata !{%struct.page_dict_t** %kpage_root}, metadata !166), !dbg !167
  store %struct.page_dict_t* @BootPageDirectory, %struct.page_dict_t** %kpage_root, align 4, !dbg !167
  call void @llvm.dbg.declare(metadata !{i32* %kpage_entry}, metadata !168), !dbg !169
  %2 = load i32* %mmaped_addr, align 4, !dbg !169
  %shr = lshr i32 %2, 22, !dbg !169
  store i32 %shr, i32* %kpage_entry, align 4, !dbg !169
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !170), !dbg !172
  %3 = load i32* %kpage_entry, align 4, !dbg !172
  store i32 %3, i32* %i, align 4, !dbg !172
  br label %for.cond, !dbg !172

for.cond:                                         ; preds = %for.inc, %entry
  %4 = load i32* %i, align 4, !dbg !172
  %5 = load i32* %kpage_entry, align 4, !dbg !172
  %6 = load i32* %n_pages.addr, align 4, !dbg !172
  %add = add nsw i32 %5, %6, !dbg !172
  %cmp = icmp slt i32 %4, %add, !dbg !172
  br i1 %cmp, label %for.body, label %for.end, !dbg !172

for.body:                                         ; preds = %for.cond
  call void @llvm.dbg.declare(metadata !{%struct.page_dict_t** %entry1}, metadata !173), !dbg !175
  %7 = load i32* %i, align 4, !dbg !175
  %8 = load %struct.page_dict_t** %kpage_root, align 4, !dbg !175
  %arrayidx = getelementptr inbounds %struct.page_dict_t* %8, i32 %7, !dbg !175
  store %struct.page_dict_t* %arrayidx, %struct.page_dict_t** %entry1, align 4, !dbg !175
  call void @llvm.dbg.declare(metadata !{i32* %phys_addr}, metadata !176), !dbg !177
  %9 = load %struct.page_dict_t** %entry1, align 4, !dbg !177
  %10 = getelementptr inbounds %struct.page_dict_t* %9, i32 0, i32 0, !dbg !177
  %11 = bitcast %union.anon* %10 to %struct.anon*, !dbg !177
  %12 = bitcast %struct.anon* %11 to i32*, !dbg !177
  %bf.load = load i32* %12, align 4, !dbg !177
  %bf.lshr = lshr i32 %bf.load, 12, !dbg !177
  store i32 %bf.lshr, i32* %phys_addr, align 4, !dbg !177
  %13 = load i32* %phys_addr, align 4, !dbg !178
  %14 = inttoptr i32 %13 to i8*, !dbg !178
  call void @set_paddress_mapped(i8* %14, i1 zeroext false) #4, !dbg !178
  %15 = load %struct.page_dict_t** %entry1, align 4, !dbg !179
  %16 = getelementptr inbounds %struct.page_dict_t* %15, i32 0, i32 0, !dbg !179
  %u32 = bitcast %union.anon* %16 to i32*, !dbg !179
  store i32 0, i32* %u32, align 4, !dbg !179
  br label %for.inc, !dbg !180

for.inc:                                          ; preds = %for.body
  %17 = load i32* %i, align 4, !dbg !172
  %inc = add nsw i32 %17, 1, !dbg !172
  store i32 %inc, i32* %i, align 4, !dbg !172
  br label %for.cond, !dbg !172

for.end:                                          ; preds = %for.cond
  ret i1 true, !dbg !181
}

attributes #0 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { inlinehint nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nobuiltin }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!36}
!llvm.ident = !{!37}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"clang version 3.4 (http://llvm.org/git/clang.git 82a2911a94947e20ac4fd961b6322adf74ad9224) (http://llvm.org/git/llvm.git 52244da7f2b3def646900520668b859343b84a33)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !29, metadata !2, metadata !""} ; [ DW_TAG_compile_unit ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c] [DW_LANG_C99]
!1 = metadata !{metadata !"src/paging.c", metadata !"/home/gbps/Desktop/Projects/os_notshared/pandos"}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4, metadata !9, metadata !13, metadata !17, metadata !20, metadata !23, metadata !26}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"getpagesize", metadata !"getpagesize", metadata !"", i32 13, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, i32 ()* @getpagesize, null, null, metadata !2, i32 14} ; [ DW_TAG_subprogram ] [line 13] [def] [scope 14] [getpagesize]
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{metadata !8}
!8 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!9 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"kmmap", metadata !"kmmap", metadata !"", i32 25, metadata !10, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i8* (i32)* @kmmap, null, null, metadata !2, i32 26} ; [ DW_TAG_subprogram ] [line 25] [def] [scope 26] [kmmap]
!10 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !11, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!11 = metadata !{metadata !12, metadata !8}
!12 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from ]
!13 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"is_paddress_mapped", metadata !"is_paddress_mapped", metadata !"", i32 30, metadata !14, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i1 (i8*)* @is_paddress_mapped, null, null, metadata !2, i32 31} ; [ DW_TAG_subprogram ] [line 30] [def] [scope 31] [is_paddress_mapped]
!14 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !15, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!15 = metadata !{metadata !16, metadata !12}
!16 = metadata !{i32 786468, null, null, metadata !"_Bool", i32 0, i64 8, i64 8, i64 0, i32 0, i32 2} ; [ DW_TAG_base_type ] [_Bool] [line 0, size 8, align 8, offset 0, enc DW_ATE_boolean]
!17 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"set_paddress_mapped", metadata !"set_paddress_mapped", metadata !"", i32 36, metadata !18, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i8*, i1)* @set_paddress_mapped, null, null, metadata !2, i32 37} ; [ DW_TAG_subprogram ] [line 36] [def] [scope 37] [set_paddress_mapped]
!18 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !19, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!19 = metadata !{null, metadata !12, metadata !16}
!20 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"mmap", metadata !"mmap", metadata !"", i32 50, metadata !21, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i8* (i32, i8*)* @mmap, null, null, metadata !2, i32 51} ; [ DW_TAG_subprogram ] [line 50] [def] [scope 51] [mmap]
!21 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !22, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!22 = metadata !{metadata !12, metadata !8, metadata !12}
!23 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"munmap", metadata !"munmap", metadata !"", i32 122, metadata !24, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i1 (i8*, i32)* @munmap, null, null, metadata !2, i32 123} ; [ DW_TAG_subprogram ] [line 122] [def] [scope 123] [munmap]
!24 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !25, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!25 = metadata !{metadata !16, metadata !12, metadata !8}
!26 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"invlpg", metadata !"invlpg", metadata !"", i32 18, metadata !27, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i8*)* @invlpg, null, null, metadata !2, i32 19} ; [ DW_TAG_subprogram ] [line 18] [local] [def] [scope 19] [invlpg]
!27 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !28, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!28 = metadata !{null, metadata !12}
!29 = metadata !{metadata !30}
!30 = metadata !{i32 786484, i32 0, null, metadata !"open_pages_map", metadata !"open_pages_map", metadata !"", metadata !5, i32 11, metadata !31, i32 0, i32 1, [32 x i32]* @open_pages_map, null} ; [ DW_TAG_variable ] [open_pages_map] [line 11] [def]
!31 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 1024, i64 32, i32 0, i32 0, metadata !32, metadata !34, i32 0, null, null, null} ; [ DW_TAG_array_type ] [line 0, size 1024, align 32, offset 0] [from uint32_t]
!32 = metadata !{i32 786454, metadata !1, null, metadata !"uint32_t", i32 184, i64 0, i64 0, i64 0, i32 0, metadata !33} ; [ DW_TAG_typedef ] [uint32_t] [line 184, size 0, align 0, offset 0] [from unsigned int]
!33 = metadata !{i32 786468, null, null, metadata !"unsigned int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [unsigned int] [line 0, size 32, align 32, offset 0, enc DW_ATE_unsigned]
!34 = metadata !{metadata !35}
!35 = metadata !{i32 786465, i64 0, i64 32}       ; [ DW_TAG_subrange_type ] [0, 31]
!36 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!37 = metadata !{metadata !"clang version 3.4 (http://llvm.org/git/clang.git 82a2911a94947e20ac4fd961b6322adf74ad9224) (http://llvm.org/git/llvm.git 52244da7f2b3def646900520668b859343b84a33)"}
!38 = metadata !{i32 15, i32 0, metadata !4, null}
!39 = metadata !{i32 786689, metadata !9, metadata !"n_pages", metadata !5, i32 16777241, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [n_pages] [line 25]
!40 = metadata !{i32 25, i32 0, metadata !9, null}
!41 = metadata !{i32 27, i32 0, metadata !9, null}
!42 = metadata !{i32 786689, metadata !20, metadata !"n_pages", metadata !5, i32 16777266, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [n_pages] [line 50]
!43 = metadata !{i32 50, i32 0, metadata !20, null}
!44 = metadata !{i32 786689, metadata !20, metadata !"addr_base", metadata !5, i32 33554482, metadata !12, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [addr_base] [line 50]
!45 = metadata !{i32 786688, metadata !20, metadata !"kpage_root", metadata !5, i32 52, metadata !46, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [kpage_root] [line 52]
!46 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, metadata !47} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from page_dict_t]
!47 = metadata !{i32 786454, metadata !1, null, metadata !"page_dict_t", i32 24, i64 0, i64 0, i64 0, i32 0, metadata !48} ; [ DW_TAG_typedef ] [page_dict_t] [line 24, size 0, align 0, offset 0] [from page_dict_t]
!48 = metadata !{i32 786451, metadata !49, null, metadata !"page_dict_t", i32 4, i64 32, i64 32, i32 0, i32 0, null, metadata !50, i32 0, null, null, null} ; [ DW_TAG_structure_type ] [page_dict_t] [line 4, size 32, align 32, offset 0] [def] [from ]
!49 = metadata !{metadata !"src/paging.h", metadata !"/home/gbps/Desktop/Projects/os_notshared/pandos"}
!50 = metadata !{metadata !51}
!51 = metadata !{i32 786445, metadata !49, metadata !48, metadata !"", i32 6, i64 32, i64 32, i64 0, i32 0, metadata !52} ; [ DW_TAG_member ] [line 6, size 32, align 32, offset 0] [from ]
!52 = metadata !{i32 786455, metadata !49, metadata !48, metadata !"", i32 6, i64 32, i64 32, i64 0, i32 0, null, metadata !53, i32 0, null, null, null} ; [ DW_TAG_union_type ] [line 6, size 32, align 32, offset 0] [def] [from ]
!53 = metadata !{metadata !54, metadata !55}
!54 = metadata !{i32 786445, metadata !49, metadata !52, metadata !"u32", i32 8, i64 32, i64 32, i64 0, i32 0, metadata !32} ; [ DW_TAG_member ] [u32] [line 8, size 32, align 32, offset 0] [from uint32_t]
!55 = metadata !{i32 786445, metadata !49, metadata !52, metadata !"", i32 9, i64 32, i64 32, i64 0, i32 0, metadata !56} ; [ DW_TAG_member ] [line 9, size 32, align 32, offset 0] [from ]
!56 = metadata !{i32 786451, metadata !49, metadata !52, metadata !"", i32 9, i64 32, i64 32, i32 0, i32 0, null, metadata !57, i32 0, null, null, null} ; [ DW_TAG_structure_type ] [line 9, size 32, align 32, offset 0] [def] [from ]
!57 = metadata !{metadata !58, metadata !59, metadata !60, metadata !61, metadata !62, metadata !63, metadata !64, metadata !65, metadata !66, metadata !67, metadata !68}
!58 = metadata !{i32 786445, metadata !49, metadata !56, metadata !"present", i32 11, i64 1, i64 32, i64 0, i32 0, metadata !32} ; [ DW_TAG_member ] [present] [line 11, size 1, align 32, offset 0] [from uint32_t]
!59 = metadata !{i32 786445, metadata !49, metadata !56, metadata !"read_write", i32 12, i64 1, i64 32, i64 1, i32 0, metadata !32} ; [ DW_TAG_member ] [read_write] [line 12, size 1, align 32, offset 1] [from uint32_t]
!60 = metadata !{i32 786445, metadata !49, metadata !56, metadata !"user_supervisor", i32 13, i64 1, i64 32, i64 2, i32 0, metadata !32} ; [ DW_TAG_member ] [user_supervisor] [line 13, size 1, align 32, offset 2] [from uint32_t]
!61 = metadata !{i32 786445, metadata !49, metadata !56, metadata !"writethrough", i32 14, i64 1, i64 32, i64 3, i32 0, metadata !32} ; [ DW_TAG_member ] [writethrough] [line 14, size 1, align 32, offset 3] [from uint32_t]
!62 = metadata !{i32 786445, metadata !49, metadata !56, metadata !"cachedisabled", i32 15, i64 1, i64 32, i64 4, i32 0, metadata !32} ; [ DW_TAG_member ] [cachedisabled] [line 15, size 1, align 32, offset 4] [from uint32_t]
!63 = metadata !{i32 786445, metadata !49, metadata !56, metadata !"accessed", i32 16, i64 1, i64 32, i64 5, i32 0, metadata !32} ; [ DW_TAG_member ] [accessed] [line 16, size 1, align 32, offset 5] [from uint32_t]
!64 = metadata !{i32 786445, metadata !49, metadata !56, metadata !"_zero", i32 17, i64 1, i64 32, i64 6, i32 0, metadata !32} ; [ DW_TAG_member ] [_zero] [line 17, size 1, align 32, offset 6] [from uint32_t]
!65 = metadata !{i32 786445, metadata !49, metadata !56, metadata !"page_size", i32 18, i64 1, i64 32, i64 7, i32 0, metadata !32} ; [ DW_TAG_member ] [page_size] [line 18, size 1, align 32, offset 7] [from uint32_t]
!66 = metadata !{i32 786445, metadata !49, metadata !56, metadata !"_ignored", i32 19, i64 1, i64 32, i64 8, i32 0, metadata !32} ; [ DW_TAG_member ] [_ignored] [line 19, size 1, align 32, offset 8] [from uint32_t]
!67 = metadata !{i32 786445, metadata !49, metadata !56, metadata !"avail", i32 20, i64 3, i64 32, i64 9, i32 0, metadata !32} ; [ DW_TAG_member ] [avail] [line 20, size 3, align 32, offset 9] [from uint32_t]
!68 = metadata !{i32 786445, metadata !49, metadata !56, metadata !"phys_addr", i32 21, i64 20, i64 32, i64 12, i32 0, metadata !32} ; [ DW_TAG_member ] [phys_addr] [line 21, size 20, align 32, offset 12] [from uint32_t]
!69 = metadata !{i32 52, i32 0, metadata !20, null}
!70 = metadata !{i32 786688, metadata !20, metadata !"phys_page", metadata !5, i32 54, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [phys_page] [line 54]
!71 = metadata !{i32 54, i32 0, metadata !20, null}
!72 = metadata !{i32 786688, metadata !20, metadata !"page_ok", metadata !5, i32 55, metadata !16, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [page_ok] [line 55]
!73 = metadata !{i32 55, i32 0, metadata !20, null}
!74 = metadata !{i32 57, i32 0, metadata !75, null}
!75 = metadata !{i32 786443, metadata !1, metadata !20, i32 57, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!76 = metadata !{i32 786688, metadata !77, metadata !"i", metadata !5, i32 60, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 60]
!77 = metadata !{i32 786443, metadata !1, metadata !78, i32 60, i32 0, i32 5} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!78 = metadata !{i32 786443, metadata !1, metadata !75, i32 58, i32 0, i32 4} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!79 = metadata !{i32 60, i32 0, metadata !77, null}
!80 = metadata !{i32 62, i32 0, metadata !81, null}
!81 = metadata !{i32 786443, metadata !1, metadata !82, i32 62, i32 0, i32 7} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!82 = metadata !{i32 786443, metadata !1, metadata !77, i32 61, i32 0, i32 6} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!83 = metadata !{i32 64, i32 0, metadata !84, null}
!84 = metadata !{i32 786443, metadata !1, metadata !81, i32 63, i32 0, i32 8} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!85 = metadata !{i32 65, i32 0, metadata !84, null}
!86 = metadata !{i32 66, i32 0, metadata !82, null}
!87 = metadata !{i32 67, i32 0, metadata !88, null}
!88 = metadata !{i32 786443, metadata !1, metadata !78, i32 67, i32 0, i32 9} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!89 = metadata !{i32 69, i32 0, metadata !90, null}
!90 = metadata !{i32 786443, metadata !1, metadata !88, i32 68, i32 0, i32 10} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!91 = metadata !{i32 71, i32 0, metadata !78, null}
!92 = metadata !{i32 73, i32 0, metadata !93, null}
!93 = metadata !{i32 786443, metadata !1, metadata !20, i32 73, i32 0, i32 11} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!94 = metadata !{i32 76, i32 0, metadata !95, null}
!95 = metadata !{i32 786443, metadata !1, metadata !93, i32 74, i32 0, i32 12} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!96 = metadata !{i32 786688, metadata !20, metadata !"start_virt_entry", metadata !5, i32 80, metadata !32, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [start_virt_entry] [line 80]
!97 = metadata !{i32 80, i32 0, metadata !20, null}
!98 = metadata !{i32 786688, metadata !20, metadata !"virt_base_addr", metadata !5, i32 83, metadata !32, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [virt_base_addr] [line 83]
!99 = metadata !{i32 83, i32 0, metadata !20, null}
!100 = metadata !{i32 86, i32 0, metadata !101, null}
!101 = metadata !{i32 786443, metadata !1, metadata !20, i32 86, i32 0, i32 13} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!102 = metadata !{i32 786688, metadata !103, metadata !"page_ok", metadata !5, i32 88, metadata !16, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [page_ok] [line 88]
!103 = metadata !{i32 786443, metadata !1, metadata !101, i32 87, i32 0, i32 14} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!104 = metadata !{i32 88, i32 0, metadata !103, null}
!105 = metadata !{i32 786688, metadata !106, metadata !"i", metadata !5, i32 89, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 89]
!106 = metadata !{i32 786443, metadata !1, metadata !103, i32 89, i32 0, i32 15} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!107 = metadata !{i32 89, i32 0, metadata !106, null}
!108 = metadata !{i32 786688, metadata !109, metadata !"entry", metadata !5, i32 91, metadata !46, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [entry] [line 91]
!109 = metadata !{i32 786443, metadata !1, metadata !106, i32 90, i32 0, i32 16} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!110 = metadata !{i32 91, i32 0, metadata !109, null}
!111 = metadata !{i32 92, i32 0, metadata !112, null}
!112 = metadata !{i32 786443, metadata !1, metadata !109, i32 92, i32 0, i32 17} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!113 = metadata !{i32 94, i32 0, metadata !114, null}
!114 = metadata !{i32 786443, metadata !1, metadata !112, i32 93, i32 0, i32 18} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!115 = metadata !{i32 95, i32 0, metadata !114, null}
!116 = metadata !{i32 96, i32 0, metadata !109, null}
!117 = metadata !{i32 97, i32 0, metadata !118, null}
!118 = metadata !{i32 786443, metadata !1, metadata !103, i32 97, i32 0, i32 19} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!119 = metadata !{i32 99, i32 0, metadata !120, null}
!120 = metadata !{i32 786443, metadata !1, metadata !118, i32 98, i32 0, i32 20} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!121 = metadata !{i32 101, i32 0, metadata !103, null}
!122 = metadata !{i32 786688, metadata !123, metadata !"i", metadata !5, i32 104, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 104]
!123 = metadata !{i32 786443, metadata !1, metadata !20, i32 104, i32 0, i32 21} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!124 = metadata !{i32 104, i32 0, metadata !123, null}
!125 = metadata !{i32 786688, metadata !126, metadata !"phys_addr", metadata !5, i32 107, metadata !32, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [phys_addr] [line 107]
!126 = metadata !{i32 786443, metadata !1, metadata !123, i32 105, i32 0, i32 22} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!127 = metadata !{i32 107, i32 0, metadata !126, null}
!128 = metadata !{i32 786688, metadata !126, metadata !"entry", metadata !5, i32 108, metadata !46, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [entry] [line 108]
!129 = metadata !{i32 108, i32 0, metadata !126, null}
!130 = metadata !{i32 109, i32 0, metadata !126, null}
!131 = metadata !{i32 110, i32 0, metadata !126, null}
!132 = metadata !{i32 111, i32 0, metadata !126, null}
!133 = metadata !{i32 112, i32 0, metadata !126, null}
!134 = metadata !{i32 115, i32 0, metadata !126, null}
!135 = metadata !{i32 116, i32 0, metadata !126, null}
!136 = metadata !{i32 119, i32 0, metadata !20, null}
!137 = metadata !{i32 120, i32 0, metadata !20, null}
!138 = metadata !{i32 786689, metadata !13, metadata !"addr", metadata !5, i32 16777246, metadata !12, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [addr] [line 30]
!139 = metadata !{i32 30, i32 0, metadata !13, null}
!140 = metadata !{i32 786688, metadata !13, metadata !"addr_u", metadata !5, i32 32, metadata !32, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [addr_u] [line 32]
!141 = metadata !{i32 32, i32 0, metadata !13, null}
!142 = metadata !{i32 33, i32 0, metadata !13, null}
!143 = metadata !{i32 786689, metadata !17, metadata !"addr", metadata !5, i32 16777252, metadata !12, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [addr] [line 36]
!144 = metadata !{i32 36, i32 0, metadata !17, null}
!145 = metadata !{i32 786689, metadata !17, metadata !"mapped", metadata !5, i32 33554468, metadata !16, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [mapped] [line 36]
!146 = metadata !{i32 786688, metadata !17, metadata !"addr_u", metadata !5, i32 38, metadata !32, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [addr_u] [line 38]
!147 = metadata !{i32 38, i32 0, metadata !17, null}
!148 = metadata !{i32 39, i32 0, metadata !149, null}
!149 = metadata !{i32 786443, metadata !1, metadata !17, i32 39, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!150 = metadata !{i32 41, i32 0, metadata !151, null}
!151 = metadata !{i32 786443, metadata !1, metadata !149, i32 40, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!152 = metadata !{i32 42, i32 0, metadata !151, null}
!153 = metadata !{i32 45, i32 0, metadata !154, null}
!154 = metadata !{i32 786443, metadata !1, metadata !149, i32 44, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!155 = metadata !{i32 47, i32 0, metadata !17, null}
!156 = metadata !{i32 786689, metadata !26, metadata !"m", metadata !5, i32 16777234, metadata !12, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [m] [line 18]
!157 = metadata !{i32 18, i32 0, metadata !26, null}
!158 = metadata !{i32 21, i32 0, metadata !26, null}
!159 = metadata !{i32 424}
!160 = metadata !{i32 22, i32 0, metadata !26, null}
!161 = metadata !{i32 786689, metadata !23, metadata !"addr", metadata !5, i32 16777338, metadata !12, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [addr] [line 122]
!162 = metadata !{i32 122, i32 0, metadata !23, null}
!163 = metadata !{i32 786689, metadata !23, metadata !"n_pages", metadata !5, i32 33554554, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [n_pages] [line 122]
!164 = metadata !{i32 786688, metadata !23, metadata !"mmaped_addr", metadata !5, i32 124, metadata !32, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [mmaped_addr] [line 124]
!165 = metadata !{i32 124, i32 0, metadata !23, null}
!166 = metadata !{i32 786688, metadata !23, metadata !"kpage_root", metadata !5, i32 126, metadata !46, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [kpage_root] [line 126]
!167 = metadata !{i32 126, i32 0, metadata !23, null}
!168 = metadata !{i32 786688, metadata !23, metadata !"kpage_entry", metadata !5, i32 127, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [kpage_entry] [line 127]
!169 = metadata !{i32 127, i32 0, metadata !23, null}
!170 = metadata !{i32 786688, metadata !171, metadata !"i", metadata !5, i32 130, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 130]
!171 = metadata !{i32 786443, metadata !1, metadata !23, i32 130, i32 0, i32 23} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!172 = metadata !{i32 130, i32 0, metadata !171, null}
!173 = metadata !{i32 786688, metadata !174, metadata !"entry", metadata !5, i32 132, metadata !46, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [entry] [line 132]
!174 = metadata !{i32 786443, metadata !1, metadata !171, i32 131, i32 0, i32 24} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/paging.c]
!175 = metadata !{i32 132, i32 0, metadata !174, null}
!176 = metadata !{i32 786688, metadata !174, metadata !"phys_addr", metadata !5, i32 135, metadata !32, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [phys_addr] [line 135]
!177 = metadata !{i32 135, i32 0, metadata !174, null}
!178 = metadata !{i32 138, i32 0, metadata !174, null}
!179 = metadata !{i32 141, i32 0, metadata !174, null}
!180 = metadata !{i32 142, i32 0, metadata !174, null}
!181 = metadata !{i32 145, i32 0, metadata !23, null}
