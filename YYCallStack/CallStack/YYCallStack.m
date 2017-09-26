//
//  YYCallStack.m
//  YYCallStack
//
//  Created by yans on 2017/9/26.
//

#import "YYCallStack.h"
#include "YYCallStackSymbol.h"

#if defined(__arm64__)
//#define DETAG_INSTRUCTION_ADDRESS(A) ((A) & ~(3UL))
#define YY_THREAD_STATE_COUNT ARM_THREAD_STATE64_COUNT
#define YY_THREAD_STATE ARM_THREAD_STATE64
#define YY_FRAME_POINTER __fp
#define YY_LINKER_POINTER __lr
#define YY_INSTRUCTION_ADDRESS __pc

#elif defined(__arm__)
//#define DETAG_INSTRUCTION_ADDRESS(A) ((A) & ~(1UL))
#define YY_THREAD_STATE_COUNT ARM_THREAD_STATE_COUNT
#define YY_THREAD_STATE ARM_THREAD_STATE
#define YY_FRAME_POINTER __r[7]
#define YY_LINKER_POINTER __lr
#define YY_INSTRUCTION_ADDRESS __pc

#elif defined(__x86_64__)
//#define DETAG_INSTRUCTION_ADDRESS(A) (A)
#define YY_THREAD_STATE_COUNT x86_THREAD_STATE64_COUNT
#define YY_THREAD_STATE x86_THREAD_STATE64
#define YY_FRAME_POINTER __rbp
#define YY_LINKER_POINTER __rlr
#define YY_INSTRUCTION_ADDRESS __rip

#elif defined(__i386__)
//#define DETAG_INSTRUCTION_ADDRESS(A) (A)
#define YY_THREAD_STATE_COUNT x86_THREAD_STATE32_COUNT
#define YY_THREAD_STATE x86_THREAD_STATE32
#define YY_FRAME_POINTER __ebp
#define YY_LINKER_POINTER __elr
#define YY_INSTRUCTION_ADDRESS __eip

#endif

typedef struct {
    const uintptr_t *fp; //stp fp, lr, ...
    const uintptr_t lr;
} StackFrameFP_LR;

static thread_t _main_thread;
static int StackMaxDepth = 32;

@implementation YYCallStack

+ (void)load
{
    _main_thread = mach_thread_self();
}

+ (NSString *)callStackWithType:(YYCallStackType)type
{
    NSString *result;
    if (type == YYCallStackTypeAll) {
        thread_act_array_t threads;
        mach_msg_type_number_t thread_count = 0;
        if (KERN_SUCCESS != task_threads(mach_task_self(), &threads, &thread_count)) {
            return @"fail get all threads!";
        }
        NSMutableString *resultStr = [NSMutableString string];
        [resultStr appendFormat:@"当前线程数量：%d\n", thread_count];
        for (int i = 0; i < thread_count; i++) {
            [resultStr appendFormat:@"%@", [self callStackWithThread_t:threads[i]]];
        }
        result = resultStr.copy;
    }
    else if (type == YYCallStackTypeMain)
    {
        if ([NSThread isMainThread]) {
            result = [self callStackSymbolsWithCurrentThread];
        }
        else
        {
            result = [self callStackWithThread_t:_main_thread];
        }
    }
    else
    {
        result = [self callStackSymbolsWithCurrentThread];
    }
    
    printf("\n⚠️⚠️⚠️⚠️⚠️⚠️👇堆栈👇⚠️⚠️⚠️⚠️⚠️⚠️\n");
    NSLog(@"\n%@", result);
    printf("⚠️⚠️⚠️⚠️⚠️⚠️👆堆栈👆⚠️⚠️⚠️⚠️⚠️⚠️\n\n");
    return result;
}

+ (NSString *)callStackSymbolsWithCurrentThread
{
    
    NSArray *arr = [NSThread callStackSymbols];
    NSMutableString *strM = [NSMutableString stringWithFormat:@"\ncallStack of thread: %@\n", [NSThread isMainThread]?@"main thread":[NSThread currentThread].name];
    for (NSString *symbol in arr) {
        [strM appendFormat:@"%@\n", symbol];
    }
    return strM.copy;
}

+ (NSString *)callStackWithThread_t:(thread_t)thread
{
    _STRUCT_MCONTEXT machineContext;
    if (!getMachineContext(thread, &machineContext)) {
        return [NSString stringWithFormat:@"fail get thread(%u) state", thread];
    }
    
    uintptr_t pc = machineContext.__ss.YY_INSTRUCTION_ADDRESS;
    uintptr_t fp = machineContext.__ss.YY_FRAME_POINTER;
    uintptr_t lr = machineContext.__ss.YY_LINKER_POINTER;

    uintptr_t pcArr[StackMaxDepth];
    int i = 0;
    pcArr[i++] = pc;
    StackFrameFP_LR frame = {(void *)fp, lr};
    vm_size_t len = sizeof(frame);
    while (frame.fp && i < StackMaxDepth) {
        pcArr[i++] = frame.lr;
        bool flag = readFPMemory(frame.fp, &frame, len);
        if (!flag || frame.fp==0 || frame.lr==0) {
            break;
        }
    }
    return generateSymbol(pcArr, i, thread);
}

NSString *generateSymbol(uintptr_t *pcArr, int arrLen, thread_t thread)
{
    CallStackInfo *csInfo = (CallStackInfo *)malloc(sizeof(CallStackInfo));
    if (csInfo == NULL) {
        return @"malloc fail";
    }
    csInfo->length = 0;
    csInfo->allocLength = arrLen;
    csInfo->stacks = (FuncInfo *)malloc(sizeof(FuncInfo) * csInfo->allocLength);
    if (csInfo->stacks == NULL) {
        return @"malloc fail";
    }
    callStackOfSymbol(pcArr, arrLen, csInfo);
    NSMutableString *strM = [NSMutableString stringWithFormat:@"\ncallStack of thread: %u\n", thread];
    for (int j = 0; j < csInfo->length; j++) {
        [strM appendFormat:@"%@", formatFuncInfo(csInfo->stacks[j])];
    }
//    NSLog(@"\n%@", strM);
    freeMemory(csInfo);
    return strM.copy;
}

NSString *formatFuncInfo(FuncInfo info)
{
    if (info.symbol == NULL) {
        return @"";
    }
    char *lastPath = strrchr(info.machOName, '/');
    NSString *fname = @"";
    if (lastPath == NULL) {
        fname = [NSString stringWithFormat:@"%-30s", info.machOName];
    }
    else
    {
        fname = [NSString stringWithFormat:@"%-30s", lastPath+1];
    }
    return [NSString stringWithFormat:@"%@ 0x%08" PRIxPTR " %s  +  %llu\n", fname, (uintptr_t)info.addr, info.symbol, info.offset];
}

void freeMemory(CallStackInfo *csInfo)
{
    if (csInfo->stacks) {
        free(csInfo->stacks);
    }
    if (csInfo) {
        free(csInfo);
    }
}

bool getMachineContext(thread_t thread, _STRUCT_MCONTEXT64 *machineContext)
{
    mach_msg_type_number_t state_count = YY_THREAD_STATE_COUNT;
    return KERN_SUCCESS == thread_get_state(thread, YY_THREAD_STATE, (thread_state_t
                                                                         )&machineContext->__ss, &state_count);
}

// 读取fp开始，len(16)字节长度的内存。因为stp fp, lr... ， fp占8字节，然后紧接着上面8字节是lr
bool readFPMemory(const void *fp, const void *dst, const vm_size_t len)
{
    vm_size_t bytesCopied = 0;
    kern_return_t kr = vm_read_overwrite(mach_task_self(), (vm_address_t)fp, len, (vm_address_t)dst, &bytesCopied);
    return KERN_SUCCESS == kr;
}

@end
