//
//  FristViewController.m
//  ReactiveCocoaStudy
//
//  Created by 刘康蕤 on 2016/12/9.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "RAC_map.h"
#import "ReactiveCocoa.h"
#import <ReactiveCocoa/RACReturnSignal.h>
@interface RAC_map ()

@property (nonatomic, copy) NSString * count;

@property (nonatomic, strong) UITextField * userNameTextField;
@property (nonatomic, strong) UITextField * keyTextField;

@property (nonatomic, weak) UIButton * submitBtn;  ///< 提交按钮

@end

@implementation RAC_map

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"RAC-map映射";
    
    
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
    
    [self mapAction];
    [self flatternMapAction];
    [self mapAndFlatternMapAction];
}

- (void)countAction {

     _count = @"222";
     [[RACObserve(self, count)
     filter:^(NSString* value){
     if ([value hasPrefix:@"2"]) {
     return YES;
     } else {
     return NO;
     }
     }]
     subscribeNext:^(NSString* x){
     NSLog(@"x = %@",x);
     }];
     
}

- (void)mapAction {
    
    /*
     // 监听文本框的内容改变，把结构重新映射成一个新值.
     
     // Map作用:把源信号的值映射成一个新的值
     
     // Map使用步骤:
     // 1.传入一个block,类型是返回对象，参数是value
     // 2.value就是源信号的内容，直接拿到源信号的内容做处理
     // 3.把处理好的内容，直接返回就好了，不用包装成信号，返回的值，就是映射的值。
     
     // Map底层实现:
     // 0.Map底层其实是调用flatternMap,Map中block中的返回的值会作为flatternMap中block中的值。
     // 1.当订阅绑定信号，就会生成bindBlock。
     // 3.当源信号发送内容，就会调用bindBlock(value, *stop)
     // 4.调用bindBlock，内部就会调用flattenMap的block
     // 5.flattenMap的block内部会调用Map中的block，把Map中的block返回的内容包装成返回的信号。
     // 5.返回的信号最终会作为bindBlock中的返回信号，当做bindBlock的返回信号。
     // 6.订阅bindBlock的返回信号，就会拿到绑定信号的订阅者，把处理完成的信号内容发送出来。
     */
    
    //  map从上一个next事件接收数据，通过执行block吧返回值传给下一个next事件
    //  map以NSString为输入，取字符串的长度，返回一个NSNumber
    //  可以使用map操作来吧接收的数据转换成想要的数据类型
    [[[self.userNameTextField.rac_textSignal
       map:^id(NSString * text) {
           
        return @(text.length);
    }] filter:^BOOL(NSNumber * lenght) {
        
        return [lenght integerValue] > 3;
    }] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    
    RACSignal * validUsernameSigal = [self.userNameTextField.rac_textSignal
                                      map:^id(NSString * text) {
                                          return @([self isValidUsername:text]);
                                      }];
    RACSignal * validKeySigal = [self.keyTextField.rac_textSignal
                                 map:^id(NSString * text) {
                                     return @([self isValidkey:text]);
                                 }];
    
    /*
     // 改变背景颜色
    [[validKeySigal map:^id(NSNumber * boolValid) {
        return [boolValid boolValue]?[UIColor whiteColor]:[UIColor redColor];
    }] subscribeNext:^(UIColor * color) {
        self.keyTextField.backgroundColor = color;
    }];
     */
    
    RAC(self.keyTextField,backgroundColor) = [validKeySigal map:^id(NSNumber * keyValid) {
        return [keyValid boolValue]?[UIColor whiteColor]:[UIColor redColor];
    }];
    
    RAC(self.userNameTextField,backgroundColor) = [validUsernameSigal map:^id(NSNumber * usernameValid) {
        return [usernameValid boolValue]?[UIColor whiteColor]:[UIColor redColor];
    }];
    
    
    
    
    
}

- (void)flatternMapAction {

    /*
     // 监听文本框的内容改变，把结构重新映射成一个新值.
     
     // flattenMap作用:把源信号的内容映射成一个新的信号，信号可以是任意类型。
     
     // flattenMap使用步骤:
     // 1.传入一个block，block类型是返回值RACStream，参数value
     // 2.参数value就是源信号的内容，拿到源信号的内容做处理
     // 3.包装成RACReturnSignal信号，返回出去。
     
     // flattenMap底层实现:
     // 0.flattenMap内部调用bind方法实现的,flattenMap中block的返回值，会作为bind中bindBlock的返回值。
     // 1.当订阅绑定信号，就会生成bindBlock。
     // 2.当源信号发送内容，就会调用bindBlock(value, *stop)
     // 3.调用bindBlock，内部就会调用flattenMap的block，flattenMap的block作用：就是把处理好的数据包装成信号。
     // 4.返回的信号最终会作为bindBlock中的返回信号，当做bindBlock的返回信号。
     // 5.订阅bindBlock的返回信号，就会拿到绑定信号的订阅者，把处理完成的信号内容发送出来。
     
     */
    
    // flatternMap
    [[self.userNameTextField.rac_textSignal flattenMap:^RACStream *(id value) {
        return [RACReturnSignal return:[NSString stringWithFormat:@"%@",value]];
    }] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
}

- (void)mapAndFlatternMapAction {

    /*
     FlatternMap和Map的区别
     
     1.FlatternMap中的Block返回信号。
     2.Map中的Block返回对象。
     3.开发中，如果信号发出的值不是信号，映射一般使用Map
     4.开发中，如果信号发出的值是信号，映射一般使用FlatternMap。
     */
    
    // 创建信号中的信号
    RACSubject * signalOfSignals = [RACSubject subject];
    RACSubject * signal = [RACSubject subject];
    
    [[signalOfSignals flattenMap:^RACStream *(id value) {
       
        // 当signalOfsignals的signals发出信号才会调用
        return value;
        
    }] subscribeNext:^(id x) {
        
        // 只有signalOfsignals的signal发出信号才会调用，因为内部订阅了bindBlock中返回的信号，也就是flattenMap返回的信号。
        // 也就是flattenMap返回的信号发出内容，才会调用。
        NSLog(@"signal = %@",x);
        
    }];
    
    // 信号的信号发送信号
    [signalOfSignals sendNext:signal];
    
    // 信号发送内容
    [signal sendNext:@1];
    
}

- (BOOL)isValidUsername:(NSString *)text {
    return YES;
}
- (BOOL)isValidkey:(NSString *)text {
    return YES;
}


@end
