//
//  YYCallStackSymbol.h
//  YYCallStack
//
//  Created by yans on 2017/9/26.
//

#ifndef YYCallStackSymbol_h
#define YYCallStackSymbol_h

#include <stdio.h>
#include <stdint.h>

typedef struct {
    uint64_t addr;
    uint64_t offset;
    const char *symbol;
    const char *machOName;
} FuncInfo;

typedef struct {
    FuncInfo *stacks;
    int allocLength;
    int length;
}CallStackInfo;

void callStackOfSymbol(uintptr_t *pcArr, int arrLen, CallStackInfo *csInfo);

#endif /* YYCallStackSymbol_h */
