//
//  RAC_RACCommand.m
//  ReactiveCocoaStudy
//
//  Created by 刘康蕤 on 2016/12/12.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "RAC_RACCommand.h"
#import "ReactiveCocoa.h"
// RACCommand:RAC中用于处理事件的类，可以把事件如何处理，事件中的数据如何传递，包装到这个类中，他可以很方便的监控事件的执行过程，比如看事件有没有执行完毕
// 使用场景：监听按钮点击，网络请求
@interface RAC_RACCommand ()

@end

@implementation RAC_RACCommand

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"RAC_RACCommand";
    
    [self test5];
}

// 普通做法
- (void)test1 {
    // RACCommand：处理事件
    // 不能返回空的信号
    // 1.创建命令
    RACCommand * command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
       // 此block，执行命令的时候就会调用
        NSLog(@"%@",input);  //input为执行命令传进来的参数
        // 这里的返回值不予许为nil
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           
            [subscriber sendNext:@"执行命令产生的数据"];
            return nil;
        }];
    }];
    
    // 2执行命令
    RACSignal * signal = [command execute:@2];  //这里其实用到的是replaySubject  可以先发送命令再订阅
    // 在这个类可以订阅信号
    [signal subscribeNext:^(id x) {
        NSLog(@"x= %@",x);
    }];
}

// 一般做法
- (void)test2 {

    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        //block调用，执行命令的时候就会调用
        NSLog(@"%@",input); // input 为执行命令传进来的参数
        // 这里的返回值不允许为nil
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"执行命令产生的数据"];
            return nil;
        }];
    }];
    
    // 方式二：
    // 订阅信号
    // 注意：这里必须是先订阅才能发送命令
    // executionSignals：信号源，信号中信号，signalofsignals:信号，发送数据就是信号
    [command.executionSignals subscribeNext:^(RACSignal *x) {
        [x subscribeNext:^(id x) {
            NSLog(@"%@", x);
        }];
        //        NSLog(@"%@", x);
    }];
    
    // 2.执行命令
    [command execute:@2];
}

// 高级做法
- (void)test3 {

    // 创建命令
    RACCommand * command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
       
        NSLog(@"%@",input);
        // 这里的返回值不允许为nil
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           
            [subscriber sendNext:@"发送信号"];
            return nil;
        }];
    }];
    
    // 方式三
    // switchToLatest获取最新发送的信号，只能用于信号中信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    // 2.执行命令
    [command execute:@3];
}

- (void)test4 {

    // 创建信号中的信号
    RACSubject * signalofSignals = [RACSubject subject];
    RACSubject * siganlA = [RACSubject subject];
    // 订阅信号
//    [signalofSignals subscribeNext:^(RACSignal *x) {
//       [x subscribeNext:^(id x) {
//           NSLog(@"x= %@",x);
//       }];
//    }];
    
    // switchToLatest  获取信号中信号 发送的最新信号
    [signalofSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];

    [signalofSignals sendNext:siganlA];
    [siganlA sendNext:@4];
    
}

// 监听事件有没有完成
- (void)test5 {

    // 注意：当前命令内部发送数据完成，一定要主动发送完成
    // 1、 创建命令
    RACCommand * command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"%@",input);
        // 这里的返回值不允许为nil
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           
            // 发送数据
            [subscriber sendNext:@"执行命令产生的数据"];
            
            // 发送完成
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    // 监听事件有没有完成
    [command.executing subscribeNext:^(id x) {
       
        if ([x boolValue] == YES) {
            NSLog(@"当前正在执行%@",x);
        }else {
            
            // 执行完成
            NSLog(@"执行完成/没有执行%@",x);
        }
    }];
    
    // 获取最新的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"x = %@",x);
    }];
    
    // 执行命令
    [command execute:@2];
    
}

@end
