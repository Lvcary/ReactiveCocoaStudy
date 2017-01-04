//
//  ViewController.m
//  ReactiveCocoaStudy
//
//  Created by 刘康蕤 on 16/5/31.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "LogonViewController.h"
#import "ReactiveCocoa.h"

@interface LogonViewController ()

@property (nonatomic, strong) UITextField * userNameTextField;
@property (nonatomic, strong) UITextField * keyTextField;

@property (nonatomic, weak) UIButton * submitBtn;  ///< 提交按钮

@end

@implementation LogonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录界面";
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    
    /// 用户输入框长度大于6 才可以输入密码
    // 方式1
    __weak LogonViewController *weakself = self;
    [self.userNameTextField.rac_textSignal subscribeNext:^(NSString * userName) {

        NSLog(@"x = %@",userName);
        weakself.keyTextField.enabled = userName.length>6 ? YES : NO;
        
    }];
    
    
    // 方式2
//    [[self.userNameTextField.rac_textSignal filter:^BOOL(id value) {
//        NSString * text = value;
//        weakself.keyTextField.enabled = text.length > 6? YES:NO;
//        return text.length > 6;
//    }]
//    subscribeNext:^(id x) {
//        
//        // 当用户名长度大于6 可执行此block
//        NSLog(@"userName = %@",weakself.userNameTextField.text);
//    }];
    
    // 次方法是将keyText的背景色属性与enabled属性绑定
    [RACObserve(self.keyTextField, enabled) subscribeNext:^(id x) {
       
        weakself.keyTextField.backgroundColor = [x boolValue] ? [UIColor whiteColor]:[UIColor redColor];
        
    }];
    
    
    
    RAC(self.userNameTextField,text) = self.userNameTextField.rac_textSignal;
    RAC(self.keyTextField,text) = self.keyTextField.rac_textSignal;
    
    /// 登录按钮能否点击的信号   聚合信号
    RACSignal *enableLoginSignal = [RACSignal combineLatest:@[RACObserve(self.userNameTextField, text),RACObserve(self.keyTextField, text)] reduce:^id(NSString *userName,NSString *key){
        
        return @(userName.length>6 && key.length>6);
    }];
    
    RAC(self.submitBtn,enabled) = enableLoginSignal;
    
    
    [[self.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       
        NSLog(@"点击了登录按钮");
        
        self.keyTextField.text = @"";
        
    }];
    
    /*
    // 1. 创建信号
    RACSignal *siganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // block调用时刻：每当有订阅者订阅信号，就会调用block
        
        // 2、发送信号
        [subscriber sendNext:@1];
        
        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            
            // 执行完Block后，当前信号就不在被订阅了。
            NSLog(@"信号呗销毁");
        }];
    }];
    
    // 3、订阅信号，才会激活信号
    [siganl subscribeNext:^(id x) {
       
        NSLog(@"接收到数据：%@",x);
    }]; //</racsubscriber></racsubscriber>
    */
    
//    [self racSubjectAndRacReplaySubject_simpleUse];
    
}

// RACSubject和RACReplaySubject简单使用
- (void)racSubjectAndRacReplaySubject_simpleUse {

    // RACSubject使用步骤
    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 3.发送信号 sendNext:(id)value
    
    // RACSubject:底层实现和RACSignal不一样。
    // 1.调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值了。
    // 2.调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。

    
    // 1、创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 2、订阅信号
    [subject subscribeNext:^(id x) {
       
        // block调用时刻：当信号发出新值，就会调用
        NSLog(@"第一个订阅者%@",x);
    }];
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第二个订阅者%@",x);
    }];
    
    // 3、发送信号
    [subject sendNext:@"1"];
    
    
    
    // RACReplaySubject使用步骤:
    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.可以先订阅信号，也可以先发送信号。
    // 2.1 订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 2.2 发送信号 sendNext:(id)value
    
    // RACReplaySubject:底层实现和RACSubject不一样。
    // 1.调用sendNext发送信号，把值保存起来，然后遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    // 2.调用subscribeNext订阅信号，遍历保存的所有值，一个一个调用订阅者的nextBlock
    
    // 如果想当一个信号被订阅，就重复播放之前所有值，需要先发送信号，在订阅信号。
    // 也就是先保存值，在订阅值。
    
    // 1、 创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    // 2、发送信号
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@2];
    
    // 3、 订阅信号
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"第一个订阅者接收到的数据%@",x);
        
    }];
    
    // 订阅信号
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"第二个订阅者接收到的数据%@",x);
    }];
    
}

@end
