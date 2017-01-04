//
//  RAC_MulticastConnection.m
//  ReactiveCocoaStudy
//
//  Created by 刘康蕤 on 2016/12/12.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "RAC_MulticastConnection.h"
#import "ReactiveCocoa.h"
@interface RAC_MulticastConnection ()

@end

@implementation RAC_MulticastConnection

/*
 *  当有多个订阅者，但是我们只想发送一个信号的时候，就可以用RACMulticastConnection来实现。
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"RAC_MulticastConnection";
    
    [self test2];
}

// 普通写法，有缺点：每订阅一次信号就得重新创建并发送请求
- (void)test {

    RACSignal * signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        // didSubscribeblock中的代码都统称为副作用。
        // 发送请求---比如afn
        NSLog(@"发送请求啦");
        // 发送信号
        [subscriber sendNext:@"ws"];
        return nil;
        
    }];
 
    [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

// 比较好的做法。 使用RACMulticastConnection，无论有多少个订阅者，无论订阅多少次，我只发送一个。
- (void)test2 {

    // 1、发送请求，用一个信号内包装，不光多个个订阅者，只发一次请求
    RACSignal * signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 发送请求
        NSLog(@"发送请求了");
        // 发送信号
        [subscriber sendNext:@"哈哈"];
        return nil;
        
    }];
    
    // 2、创建连接类
    RACMulticastConnection * connection = [signal publish];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"x = %@",x);
    }];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"x = %@",x);
    }];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"x = %@",x);
    }];
    // 3、连接。只有连接了才会把信号源变成热信号
    [connection connect];
}

@end
