//
//  RAC_Signal.m
//  ReactiveCocoaStudy
//
//  Created by 刘康蕤 on 2016/12/12.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "RAC_Signal.h"
#import "ReactiveCocoa.h"
@interface RAC_Signal ()

@end

@implementation RAC_Signal

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"RAC_Signal";
    
    [self signalAction];
}

- (void)signalAction {

    // 1.创建信号
    RACSignal * signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        // 3.发送信号
        [subscriber sendNext:@3];
        
        // 4.取消信号 如果信号被取消，就必须返回一个RACDisposable
        // 信号什么时候被取消：1.自动取消，当一个信号的订阅者被销毁的时候机会自动取消订阅，2.手动取消，
        //block什么时候调用：一旦一个信号被取消订阅就会调用
        //block作用：当信号被取消时用于清空一些资源
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"取消订阅");
        }];
    }];
    
    // 2.订阅信号
    RACDisposable * disposable = [signal subscribeNext:^(id x) {
        // 只要信号内部发出数据就会调用这个block
        NSLog(@"x = %@",x);
    }];
    
    NSLog(@"取消");
    // 取消订阅
    [disposable dispose];
}

/**
 *  RACSignal总结：
 一.核心：
 1.核心：信号类
 2.信号类的作用：只要有数据改变就会把数据包装成信号传递出去
 3.只要有数据改变就会有信号发出
 4.数据发出，并不是信号类发出，信号类不能发送数据
 一.使用方法：
 1.创建信号
 2.订阅信号
 二.实现思路：
 1.当一个信号被订阅，创建订阅者，并把nextBlock保存到订阅者里面。
 2.创建的时候会返回 [RACDynamicSignal createSignal:didSubscribe];
 3.调用RACDynamicSignal的didSubscribe
 4.发送信号[subscriber sendNext:value];
 5.拿到订阅者的nextBlock调用
 */


@end
