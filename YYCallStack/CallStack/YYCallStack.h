//
//  YYCallStack.h
//  YYCallStack
//
//  Created by yans on 2017/9/26.
//

#import <Foundation/Foundation.h>
#include <mach/mach.h>


typedef NS_ENUM(NSUInteger, YYCallStackType) {
    YYCallStackTypeAll,     //全部线程
    YYCallStackTypeMain,    //主线程
    YYCallStackTypeCurrent  //当前线程
};

NS_ASSUME_NONNULL_BEGIN

@interface YYCallStack : NSObject

+ (NSString *)callStackWithType:(YYCallStackType)type;
//+ (NSString *)callStackWithThread_t:(thread_t)thread;

@end

NS_ASSUME_NONNULL_END
