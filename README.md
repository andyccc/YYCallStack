# YYCallStack
程序中获取调用堆栈。  

### 用法
```
typedef NS_ENUM(NSUInteger, YYCallStackType) {
    YYCallStackTypeAll,     //全部线程
    YYCallStackTypeMain,    //主线程
    YYCallStackTypeCurrent  //当前线程
};


//获取所有线程的调用堆栈
NSString *callStack = [YYCallStack callStackWithType:YYCallStackTypeAll];

//获取主线程的调用堆栈
NSString *callStack = [YYCallStack callStackWithType:YYCallStackTypeMain];

//获取当前线程的调用堆栈
NSString *callStack = [YYCallStack callStackWithType:YYCallStackTypeCurrent];

```
### 注意 
1. 在获取当前线程的调用堆栈，别人都是通过 [NSThread setName:xx(比如时间戳)] , 然后通过pthread_getname_np()。通过比对两者 name 一样，来关联NSThread 跟 pthread_t，而我直接用 [NSThread callStackSymbols] 获取当前线程的堆栈。
2. 这个项目目前主要是用来学习，所以都是硬编码，只支持arm64~ 



## YYThreadMonitor 说明
轻量级线程监控工具类，当线程数量过多或线程爆炸时候，就打印所有线程堆栈。

```
//在main函数里，或者任何你想开始监控的地方调用startMonitor，就可以了
//一般在main，或者application:didFinishLaunchingWithOptions:函数里。
[YYThreadMonitor startMonitor];

//在YYThreadMonitor.m文件里，可根据需求修改这两个值
#define YY_THRESHOLD 40   //表示线程数量超过40，就打印所有线程堆栈(根据自己项目来定！！！)
static const int threadIncreaseThreshold = 10;  //表示一秒钟新增加的线程数量（新建的线程数量 - 销毁的线程数量）超过10，就打印所有的线程堆栈
```


### 效果
当线程爆炸或线程数量过多时候，控制台打印所有的线程堆栈~

```

🔥💥💥💥💥💥一秒钟开启 59 条线程！💥💥💥💥💥🔥

⚠️⚠️⚠️⚠️⚠️⚠️👇堆栈👇⚠️⚠️⚠️⚠️⚠️⚠️
2021-09-26 16:21:03.520546+0800 YYCallStack[3790:5349310] 
当前线程数量：66

callStack of thread: 771
libsystem_kernel.dylib         0x18026b190 mach_msg_trap  +  8
libsystem_kernel.dylib         0x18026a5c4 mach_msg  +  72
CoreFoundation                 0x180415320 <redacted>  +  148
CoreFoundation                 0x18040ff60 <redacted>  +  1160
CoreFoundation                 0x18040fa8c CFRunLoopRunSpecific  +  424
GraphicsServices               0x18a5592ec GSEventRunModal  +  160
UIKitCore                      0x184541aa0 UIApplicationMain  +  1932
YYCallStack                    0x100005b90 main  +  128
libdyld.dylib                  0x1802977fc <redacted>  +  4

callStack of thread: 3335
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 10499
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 5891
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 11523
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 8451
libsystem_kernel.dylib         0x18026b190 mach_msg_trap  +  8
libsystem_kernel.dylib         0x18026a5c4 mach_msg  +  72
CoreFoundation                 0x180415320 <redacted>  +  148
CoreFoundation                 0x18040ff60 <redacted>  +  1160
CoreFoundation                 0x18040fa8c CFRunLoopRunSpecific  +  424
Foundation                     0x180752ae8 <redacted>  +  228
Foundation                     0x180752a54 <redacted>  +  88
UIKitCore                      0x1845e40c8 <redacted>  +  152
Foundation                     0x180881680 <redacted>  +  848
libsystem_pthread.dylib        0x1801adcfc _pthread_start  +  156

callStack of thread: 17675
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 16131
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 42499
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 22275
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 40711
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 40195
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872

libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 38915
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 23299
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 23811
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 24067
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 24579
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 37635
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 15115
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 36099
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 35843
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 35331
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 35075
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 25859
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 26123
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 34051
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 27395
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 32515
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 29707
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 30475
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 30987
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 43531
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 44051
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 44555
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 44811
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 85515
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 45323
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 85011
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 46347
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 84235
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 47115
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 83467
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_clien
⚠️⚠️⚠️⚠️⚠️⚠️👆堆栈👆⚠️⚠️⚠️⚠️⚠️⚠️


⚠️⚠️⚠️⚠️⚠️⚠️👇堆栈👇⚠️⚠️⚠️⚠️⚠️⚠️
2021-09-26 16:21:03.708184+0800 YYCallStack[3790:5349311] 
当前线程数量：67

callStack of thread: 771
libsystem_kernel.dylib         0x18026b190 mach_msg_trap  +  8
libsystem_kernel.dylib         0x18026a5c4 mach_msg  +  72
CoreFoundation                 0x180415320 <redacted>  +  148
CoreFoundation                 0x18040ff60 <redacted>  +  1160
CoreFoundation                 0x18040fa8c CFRunLoopRunSpecific  +  424
GraphicsServices               0x18a5592ec GSEventRunModal  +  160
UIKitCore                      0x184541aa0 UIApplicationMain  +  1932
YYCallStack                    0x100005b90 main  +  128
libdyld.dylib                  0x1802977fc <redacted>  +  4

callStack of thread: 3335
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 10499
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 5891
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 11523
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 8451
libsystem_kernel.dylib         0x18026b190 mach_msg_trap  +  8
libsystem_kernel.dylib         0x18026a5c4 mach_msg  +  72
CoreFoundation                 0x180415320 <redacted>  +  148
CoreFoundation                 0x18040ff60 <redacted>  +  1160
CoreFoundation                 0x18040fa8c CFRunLoopRunSpecific  +  424
Foundation                     0x180752ae8 <redacted>  +  228
Foundation                     0x180752a54 <redacted>  +  88
UIKitCore                      0x1845e40c8 <redacted>  +  152
Foundation                     0x180881680 <redacted>  +  848
libsystem_pthread.dylib        0x1801adcfc _pthread_start  +  156

callStack of thread: 17675
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 16131
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 42499
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 22275
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 40711
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 40195
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872

libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 38915
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 23299
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 23811
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 24067
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 24579
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 37635
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 15115
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 36099
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 35843
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 35331
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 35075
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 25859
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 26123
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 34051
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 27395
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 32515
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 29707
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 30475
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 30987
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 43531
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 44051
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 44555
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 44811
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 85515
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 45323
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 85011
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 46347
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 84235
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 47115
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_client_callout  +  16
libdispatch.dylib              0x00005b20 _dispatch_queue_override_invoke  +  872
libdispatch.dylib              0x00014bfc _dispatch_root_queue_drain  +  376
libdispatch.dylib              0x00015600 _dispatch_worker_thread2  +  152
libsystem_pthread.dylib        0x1801aea64 _pthread_wqthread  +  212

callStack of thread: 83467
libsystem_kernel.dylib         0x18028d0fc __semwait_signal  +  8
libsystem_c.dylib              0x1800f537c nanosleep  +  220
libsystem_c.dylib              0x1800f5224 sleep  +  44
YYCallStack                    0x1000059fc __57-[AppDelegate application:didFinishLaunchingWithOptions:]_block_invoke  +  40
libdispatch.dylib              0x00002320 _dispatch_call_block_and_release  +  24
libdispatch.dylib              0x00003720 _dispatch_clien
⚠️⚠️⚠️⚠️⚠️⚠️👆堆栈👆⚠️⚠️⚠️⚠️⚠️⚠️

```

### 起因
有一定iOS开发基础的，应该都知道不合理创建线程，是会造成性能问题的。而业务的积累和迭代过程，可能就不可避免造成子线程过多或线程爆炸等问题。所以我们需要一个工具来监控子线程过多或线程爆炸等问题。网上没有找到这样的工具，只好自己动手了~

### 不合理创建/使用线程造成的问题
合理使用多线程，将耗时操作放到子线程，可以提高App的流畅。但是如果不加控制创建子线程，造成线程爆炸，会造成性能问题。不合理使用线程有如下问题：

* 创建子线程过多，是会造成性能问题的，因为创建线程需要占用内存空间（默认的情况下，主线程占1M,子线程占用512KB）。
* 不合理创建和使用线程，容易引发数据一致性（线程安全）和死锁问题。

所以我们要合理使用线程，将整个App的子线程数量控制在合理的范围内。如何合理使用，不是本文的讨论范围；本文介绍如何发现整个App线程数量过多和线程爆炸问题。

### 获取线程数量

task_threads可以获取到整个App的线程数量。

```
kern_return_t task_threads
(
	task_inspect_t target_task,
	thread_act_array_t *act_list,
	mach_msg_type_number_t *act_listCnt
);
```
最开始，我是想通过计时器定时调用task_threads函数，来获取线程数量和增长速度。确实可以通过这个方式来做，但是间隔多久调用（涉及精度），大量调用这个函数的性能问题等，都表明这不是一个好的方案。
很明显，如果我们知道了线程的创建函数跟销毁函数，通过hook这两个函数，是不是就可以实时获取到线程数量了。幸运的是，系统提供了这个函数：

```
//在#include <pthread/introspection.h>文件里

/**
定义函数指针：pthread_introspection_hook_t
event  : 线程处于的生命周期（下面枚举了线程的4个生命周期）
thread ：线程
addr   ：线程栈内存基址
size   ：线程栈内存可用大小
*/
typedef void (*pthread_introspection_hook_t)(unsigned int event,
		pthread_t thread, void *addr, size_t size);
		
enum {
	PTHREAD_INTROSPECTION_THREAD_CREATE = 1, //创建线程
	PTHREAD_INTROSPECTION_THREAD_START, // 线程开始运行
	PTHREAD_INTROSPECTION_THREAD_TERMINATE,  //线程运行终止
	PTHREAD_INTROSPECTION_THREAD_DESTROY, //销毁线程
};

/**
看这个函数名，很像我们平时hook函数一样的。
返回值是上面声明的pthread_introspection_hook_t函数指针：返回原线程生命周期函数。
参数也是函数指针：传入的是我们自定义的线程生命周期函数
*/
__attribute__((__nonnull__, __warn_unused_result__))
extern pthread_introspection_hook_t
pthread_introspection_hook_install(pthread_introspection_hook_t hook);

```

所以我们可以通过"hook"线程生命周期函数，来获得线程的新建跟销毁。

### 线程安全

调用startMonitor函数，开始监控线程数量。在这个函数里用global_semaphore来保证，task_threads获取的线程数量，到hook完成，线程数量不会变化（加解锁之间，没有线程新建跟销毁）。

```

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
    ...
}

```

### 线程状态改变，改变线程数量

```
//定时器每一秒都将线程增长数置0
+ (void)clearThreadCountIncrease
{
    threadCountIncrease = 0;
}


void yy_pthread_introspection_hook_t(unsigned int event,
pthread_t thread, void *addr, size_t size)
{
    ...
    //创建线程，则线程数量和线程增长数都加1
    if (event == PTHREAD_INTROSPECTION_THREAD_CREATE) {
        threadCount = threadCount + 1;
        ...
        threadCountIncrease = threadCountIncrease + 1;
        ...
    }
    //销毁线程，则线程数量和线程增长数都加1
    else if (event == PTHREAD_INTROSPECTION_THREAD_DESTROY){
        threadCount = threadCount - 1;
        ...
        if (threadCountIncrease > 0) {
            threadCountIncrease = threadCountIncrease - 1;
        }
    }
}
```

### 打印所有线程堆栈

这里使用CallStack工具，如何打印线程堆栈，保留调用现场的方案很多，原理都是：回溯栈帧，获得函数调用地址，然后通过解析MachO文件获得函数名。具体过程可以参考其它方案~
