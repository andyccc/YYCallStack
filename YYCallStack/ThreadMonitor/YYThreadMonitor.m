//
//  YYThreadMonitor.m
//  YYCallStack
//
//  Created by yans on 2017/9/26.
//

#import "YYThreadMonitor.h"
#import "YYCallStack.h"
#include <pthread/introspection.h>

#ifndef yy_dispatch_main_async_safe
#define yy_dispatch_main_async_safe(block)\
if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {\
    block();\
} else {\
    dispatch_async(dispatch_get_main_queue(), block);\
}
#endif

static pthread_introspection_hook_t old_pthread_introspection_hook_t = NULL;
static int threadCount = 40;
#define YY_THRESHOLD 2
static const int threadIncreaseThreshold = 10;

//线程数量超过40，就会弹窗警告，并且控制台打印所有线程的堆栈；之后阈值每增加5条(45、50、55...)同样警告+打印堆栈；如果线程数量再次少于40条，阈值恢复到40
static int maxThreadCountThreshold = YY_THRESHOLD;
static dispatch_semaphore_t global_semaphore;
static int threadCountIncrease = 0;
static bool isMonitor = false;

@implementation YYThreadMonitor

+ (void)startMonitor
{
    global_semaphore = dispatch_semaphore_create(1);
    dispatch_semaphore_wait(global_semaphore, DISPATCH_TIME_FOREVER);
    mach_msg_type_number_t count;
    thread_act_array_t threads;
    task_threads(mach_task_self(), &threads, &count);
    threadCount = count; //加解锁之间，保证线程的数量不变
    old_pthread_introspection_hook_t = pthread_introspection_hook_install(yy_pthread_introspection_hook_t);
    dispatch_semaphore_signal(global_semaphore);
    
    isMonitor = true;
    yy_dispatch_main_async_safe(^{
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(clearThreadCountIncrease) userInfo:nil repeats:YES];
    });
}
+ (void)clearThreadCountIncrease
{
    threadCountIncrease = 0;
}

void yy_pthread_introspection_hook_t(unsigned int event,
pthread_t thread, void *addr, size_t size)
{
    if (old_pthread_introspection_hook_t) {
        old_pthread_introspection_hook_t(event, thread, addr, size);
    }
    if (event == PTHREAD_INTROSPECTION_THREAD_CREATE) {
        threadCount = threadCount + 1;
        if (isMonitor && (threadCount > maxThreadCountThreshold)) {
            maxThreadCountThreshold += 5;
            yy_Alert_Log_CallStack(false, 0);
        }
        threadCountIncrease = threadCountIncrease + 1;
        if (isMonitor && (threadCountIncrease > threadIncreaseThreshold)) {
            yy_Alert_Log_CallStack(true, threadCountIncrease);
        }
    }
    else if (event == PTHREAD_INTROSPECTION_THREAD_DESTROY){
        threadCount = threadCount - 1;
        if (threadCount < YY_THRESHOLD) {
            maxThreadCountThreshold = YY_THRESHOLD;
        }
        if (threadCountIncrease > 0) {
            threadCountIncrease = threadCountIncrease - 1;
        }
    }
}

void yy_Alert_Log_CallStack(bool isIncreaseLog, int num)
{
    dispatch_semaphore_wait(global_semaphore, DISPATCH_TIME_FOREVER);
    if (isIncreaseLog) {
        printf("\n🔥💥💥💥💥💥一秒钟开启 %d 条线程！💥💥💥💥💥🔥\n", num);
    }
    [YYCallStack callStackWithType:YYCallStackTypeAll];
    dispatch_semaphore_signal(global_semaphore);
}

@end
