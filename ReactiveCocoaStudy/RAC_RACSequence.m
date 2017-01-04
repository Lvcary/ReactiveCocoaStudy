//
//  RAC_RACSequence.m
//  ReactiveCocoaStudy
//
//  Created by 刘康蕤 on 2016/12/12.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "RAC_RACSequence.h"
#import "ReactiveCocoa.h"
@interface RAC_RACSequence ()

@end

@implementation RAC_RACSequence

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"RAC_RACSequence";
    
    [self test2];
}

// 使用场景---： 可以快速高效的遍历数组和字典。
- (void)test1 {

    NSString * path = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    NSArray * dictArray = [NSArray arrayWithContentsOfFile:path];
    
    [dictArray.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"x = %@",x);
    } error:^(NSError *error){
        NSLog(@"===error===");
    } completed:^{
        NSLog(@"ok---完毕");
    }];
}

- (void)test2 {

    NSDictionary *dict = @{@"key":@1, @"key2":@2};
    [dict.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
//        NSString *key = x[0];
//        NSString *value = x[1];
        // RACTupleUnpack宏：专门用来解析元组
        // RACTupleUnpack 等会右边：需要解析的元组 宏的参数，填解析的什么样数据
        // 元组里面有几个值，宏的参数就必须填几个
        RACTupleUnpack(NSString *key1, NSString *value1) = x;
        NSLog(@"%@ %@", key1, value1);
    } error:^(NSError *error) {
        NSLog(@"===error");
    } completed:^{
        NSLog(@"-----ok---完毕");
    }];
    
}

@end
