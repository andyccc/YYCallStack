# YYCallStack
程序中获取调用堆栈。  

## 用法
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
## 注意 
1. 在获取当前线程的调用堆栈，别人都是通过 [NSThread setName:xx(比如时间戳)] , 然后通过pthread_getname_np()。通过比对两者 name 一样，来关联NSThread 跟 pthread_t，而我直接用 [NSThread callStackSymbols] 获取当前线程的堆栈。
2. 这个项目目前主要是用来学习，所以都是硬编码，只支持arm64~ 



