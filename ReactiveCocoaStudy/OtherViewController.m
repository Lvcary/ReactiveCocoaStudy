//
//  OtherViewController.m
//  ReactiveCocoaStudy
//
//  Created by 刘康蕤 on 2016/12/12.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "OtherViewController.h"

@interface OtherViewController ()

@property(nonatomic, strong)UIButton *button;
@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"RAC_Notification";
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildUI];
}

- (void)buildUI {
    
    self.button.frame = CGRectMake(50, 100, 50, 30);
    self.view.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.button];
}

#pragma mark---lazy loading
- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] init];
        [_button setBackgroundColor:[UIColor grayColor]];
        [_button setTitle:@"pop" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(btnOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

#pragma mark -- btnOnClick
- (void)btnOnClick {
    
    [self.subject sendNext:@"ws"];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
