//
//  ViewController.m
//  YYCallStack
//
//  Created by yans on 2017/9/26.
//

#import "ViewController.h"
#import "YYCallStack.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [YYCallStack callStackWithType:YYCallStackTypeAll];
    
}


@end
