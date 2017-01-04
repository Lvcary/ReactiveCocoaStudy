//
//  RAC_Notifacation.m
//  ReactiveCocoaStudy
//
//  Created by 刘康蕤 on 2016/12/12.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "RAC_Notifacation.h"
#import "ReactiveCocoa.h"
#import "OtherViewController.h"

@interface RAC_Notifacation ()
@property(nonatomic, strong)UIButton * button;

@end

@implementation RAC_Notifacation

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"RAC_Notifacation";
    
    [self buildUI];
}

- (void)buildUI {
    self.button.frame = CGRectMake(100, 100, 80, 30);
    [self.view addSubview:self.button];
}

#pragma mark---lazy loading
- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] init];
        [_button setBackgroundColor:[UIColor redColor]];
        [_button setTitle:@"push" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(btnOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
#pragma mark--btnOnClick
- (void)btnOnClick {
    OtherViewController *twoVC = [[OtherViewController alloc] init];
    
    
    twoVC.subject = [RACSubject subject];
    [twoVC.subject subscribeNext:^(id x) {  // 这里的x便是sendNext发送过来的信号
        NSLog(@"%@", x);
        [self.button setTitle:x forState:UIControlStateNormal];
    }];
    
    [self.navigationController pushViewController:twoVC animated:YES];
}


@end
