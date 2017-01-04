//
//  RootViewController.m
//  ReactiveCocoaStudy
//
//  Created by 刘康蕤 on 2016/12/8.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "RootViewController.h"
#import "LogonViewController.h"
#import "RAC_map.h"
#import "RAC_guolv.h"
#import "RAC_zuhe.h"
#import "RAC_bind.h"
#import "RAC_Define.h"
#import "RAC_RACCommand.h"
#import "RAC_MulticastConnection.h"
#import "RAC_RACSequence.h"
#import "RAC_Signal.h"
#import "RAC_Notifacation.h"
@interface RootViewController ()

@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [NSMutableArray arrayWithObjects:@"登录界面-聚合信号",@"RAC-map映射",@"RAC-过滤",@"RAC-组合",@"RAC_bind",@"RAC_define",@"RAC_RACCommand",@"RAC_MulticastConnection.h",@"RAC_RACSequence",@"RAC_Signal",@"RAC_Notifacation", nil];
    
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString * indefiter = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indefiter];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indefiter];
    }
    
    cell.textLabel.text = [_dataSource objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        LogonViewController * logon = [[LogonViewController alloc] init];
        [self.navigationController pushViewController:logon animated:YES];
    }else if (indexPath.row == 1) {
        RAC_map * frist = [[RAC_map alloc] init];
        [self.navigationController pushViewController:frist animated:YES];
    }else if(indexPath.row == 2) {
        
        RAC_guolv * guolv = [[RAC_guolv alloc] init];
        [self.navigationController pushViewController:guolv animated:YES];
    }else if(indexPath.row == 3) {
        
        RAC_zuhe * guolv = [[RAC_zuhe alloc] init];
        [self.navigationController pushViewController:guolv animated:YES];
    }else if(indexPath.row == 4) {
        
        RAC_bind * guolv = [[RAC_bind alloc] init];
        [self.navigationController pushViewController:guolv animated:YES];
    }else if(indexPath.row == 5) {
        
        RAC_Define * guolv = [[RAC_Define alloc] init];
        [self.navigationController pushViewController:guolv animated:YES];
    }else if(indexPath.row == 6) {
        
        RAC_RACCommand * guolv = [[RAC_RACCommand alloc] init];
        [self.navigationController pushViewController:guolv animated:YES];
    }else if(indexPath.row == 7) {
        
        RAC_MulticastConnection * guolv = [[RAC_MulticastConnection alloc] init];
        [self.navigationController pushViewController:guolv animated:YES];
    }else if(indexPath.row == 8) {
        
        RAC_RACSequence * guolv = [[RAC_RACSequence alloc] init];
        [self.navigationController pushViewController:guolv animated:YES];
    }else if(indexPath.row == 9) {
        
        RAC_Signal * guolv = [[RAC_Signal alloc] init];
        [self.navigationController pushViewController:guolv animated:YES];
    }else if(indexPath.row == 10) {
        
        RAC_Notifacation * guolv = [[RAC_Notifacation alloc] init];
        [self.navigationController pushViewController:guolv animated:YES];
    }
}

@end
