//
//  RAC_Define.m
//  ReactiveCocoaStudy
//
//  Created by 刘康蕤 on 2016/12/12.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "RAC_Define.h"
#import "ReactiveCocoa.h"

@interface RAC_Define ()

@property (nonatomic, strong) UITextField * userNameTextField;
@property (nonatomic, strong) UILabel * label;

@property (nonatomic, strong) RACSignal * signal;

@end

@implementation RAC_Define

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"RAC_Define";
    
    _userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, 200, 30)];
    _userNameTextField.layer.borderWidth = 1;
    _userNameTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _userNameTextField.placeholder = @"请输入用户名";
    [self.view addSubview:_userNameTextField];
    
    
    [self test4];
}

/*
 *  RAC宏
 */
- (void)test {

    // RAC : 把一个对象的某个属性绑定一个信号，只要发出信号，就会把信号的内容给对象的属性复制
    // 给label的text属性绑定了文本框改变的信号
    RAC(self.label,text) = self.userNameTextField.rac_textSignal;
    
    // 等同与
    /*
    [self.userNameTextField.rac_textSignal subscribeNext:^(id x) {
       
        self.label.text = x;
        
    }];
    */
}

/*
 * KVO
 * RACObserval ： 快速监听某个对象的某个属性改变
 * 返回的是一个信号，对象的某个属性改变的信号
 */
- (void)test2 {

    [RACObserve(self.userNameTextField, text) subscribeNext:^(id x) {
       
        NSLog(@"%@",x);
    }];
}

/// textfield输入的值赋值给label，监听label文字改变
- (void)testAndTest2 {

    RAC(self.label,text) = self.userNameTextField.rac_textSignal;
    
    [RACObserve(self.label, text) subscribeNext:^(id x) {
       
        NSLog(@"label的文字变为%@",x);
    }];
}

/*
 *  循环引用
 */
- (void)test3 {

    @weakify(self)
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        @strongify(self);
        
        NSLog(@"%@",self.view);
        
        return nil;
    }];
    _signal = signal;
    
}

/*
 *  元组
 *  快速包装一个元组
 *  把包装的类型放在宏的参数里面，就会自动包装
 */
- (void)test4 {

    RACTuple * tuple = RACTuplePack(@1,@1,@3);
    // 宏的参数类型要和元组中元素类型一直，右边为要解析的元组
    RACTupleUnpack_(NSNumber *num1, NSNumber *num2, NSNumber * num3) = tuple;   // 元组
    
    // 快速包装一个元组
    // 把包装的类型放在宏的参数里面，就会自动包装
    NSLog(@"%@ %@ %@",num1,num2,num3);
}


@end
