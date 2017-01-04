//
//  RAC_zuhe.m
//  ReactiveCocoaStudy
//
//  Created by 刘康蕤 on 2016/12/9.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "RAC_zuhe.h"
#import "ReactiveCocoa.h"
#import <ReactiveCocoa/RACReturnSignal.h>
@interface RAC_zuhe ()

@property (nonatomic, strong) UITextField * userNameTextField;
@property (nonatomic, strong) UITextField * keyTextField;

@property (nonatomic, weak) UIButton * submitBtn;  ///< 提交按钮

@end

@implementation RAC_zuhe

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"RAC-组合";
    
    _userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, 200, 30)];
    _userNameTextField.layer.borderWidth = 1;
    _userNameTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _userNameTextField.placeholder = @"请输入用户名";
    [self.view addSubview:_userNameTextField];
    
    _keyTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 120, 200, 30)];
    _keyTextField.layer.borderWidth = 1;
    _keyTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _keyTextField.placeholder = @"请输入密码";
    [self.view addSubview:_keyTextField];
    
    UIButton * submit = [UIButton buttonWithType:UIButtonTypeSystem];
    submit.frame = CGRectMake(20, 180, 80, 30);
    [submit setTitle:@"提交" forState:0];
    [self.view addSubview:submit];
    _submitBtn = submit;
    
    [self concat];
    
}

// 聚合
- (void)combinSignal {

    // 把多个信号聚合成你想要的信号，使用场景：比如当多个输入框都有值得时候按钮才可以点击
    RACSignal * combinSignal = [RACSignal combineLatest:@[self.userNameTextField.rac_textSignal,self.keyTextField.rac_textSignal] reduce:^id(NSString * username,NSString * key){
        
        // reduce里的参数必须和combineLatest数组里的一一对应
        // block：只要源信号发送内容，就会调用，组合成一个新值
        NSLog(@"%@,%@",username,key);
        return @(username.length && key.length);
    }];
    
    // 订阅信号
    /*
    [combinSignal subscribeNext:^(id x) {
        self.submitBtn.enabled = [x boolValue];
    }];
    */
    
    // 可直接使用宏
    RAC(self.submitBtn,enabled) = combinSignal;
}

// 压缩
- (void)zipWith {

    // zipWith:把两个信号压缩成一个信号，只有当两个信号同时发出信号时，并且把两个信号的内容合并成一个元素，才会触发压缩流的next事件
    
    // 创建信号A
    RACSubject * signalA = [RACSubject subject];
    // 创建信号B
    RACSubject * signalB = [RACSubject subject];
    
    // 压缩成一个信号
    // 当一个界面多个请求的时候，要等所有的请求完成才更新UI
    // 等所有的信号都发送内容的时候才会调用
    RACSignal * zipSignal = [signalA zipWith:signalB];
    [zipSignal subscribeNext:^(id x) {
       
        NSLog(@"x = %@",x); //所有的值都被包装成了元组
        
    }];
    
    // 发送信号 交互顺序，元组内元素的顺序不会变，跟发送的顺序无关，而是跟压缩的顺序有关[signalA zipWith:signalB]---先是A后是B

    [signalA sendNext:@1];
    [signalB sendNext:@2];
    
}

// 合并
- (void)merge {

    // 任何一个信号请求完成都会被订阅到
    // merge：多个信号合并成一个信号，任何信号有新值就会调用
    
    // 创建信号A
    RACSubject * signalA = [RACSubject subject];
    // 创建信号B
    RACSubject * signalB = [RACSubject subject];
    // 合并信号
    RACSignal * mergeSignal = [signalA merge:signalB];
    
    // 订阅信号
    [mergeSignal subscribeNext:^(id x) {
        NSLog(@"x = %@",x);
    }];
    
    // 发送信号--交换位置则数据结果顺序也会交换
    [signalA sendNext:@1];
    [signalB sendNext:@2];
}

// then --- 使用需求：有两部分数据：想让上部分先进行网络请求但是过滤掉数据，然后进行下部分的，拿到下部分的数据
- (void)then {

    // 创建信号A
    RACSignal * signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    
        // 发送请求
        NSLog(@"---发送上部分请求---afn");
        
        [subscriber sendNext:@"上部分数据"];
        [subscriber sendCompleted];  //必须调用sendCompleted方法
        return nil;
    }];
    
    // 创建信号B
    RACSignal * signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 发送请求
        NSLog(@"---发送下部分请求---afn");
        
        [subscriber sendNext:@"下部分数据"];
//        [subscriber sendCompleted];  //不必调用sendCompleted方法
        return nil;
    }];
    
    // 创建then信号
    // then 忽略掉第一个信号的所有值
    RACSignal * thenSignal = [signalA then:^RACSignal *{
        // 返回的信号就是要组合的信号
        return signalB;
    }];
    // 订阅信号
    [thenSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

// concat ==== 使用需求：有两部分数据：想让上部分先执行，完了之后再让下部分执行（都可以获取值）
- (void)concat {
    // 创建信号A
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        
        NSLog(@"----发送上部分请求---afn");
        [subscriber sendNext:@"上部分数据"];
        [subscriber sendCompleted]; // 必须要调用sendCompleted方法！
        return nil;
    }];
    
    // 创建信号B，
    RACSignal *signalsB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        
        NSLog(@"--发送下部分请求--afn");
        [subscriber sendNext:@"下部分数据"];
        return nil;
    }];
    
    
    // concat:按顺序去链接
    //**-注意-**：concat，第一个信号必须要调用sendCompleted
    // 创建组合信号
    RACSignal *concatSignal = [signalA concat:signalsB];
    // 订阅组合信号
    [concatSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];

}

@end
