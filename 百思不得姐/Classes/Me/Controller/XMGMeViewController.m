//
//  XMGMeViewController.m
//  百思不得姐
//
//  Created by hwawo on 16/6/29.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGMeViewController.h"
#import "XMGMeCell.h"
#import "XMGMeFooterView.h"
#import "CZDownloadViewController.h"
#import <BabyBluetooth.h>
static NSString *XMGMeId = @"me";
@interface XMGMeViewController ()<UITableViewDataSource, UITableViewDelegate>{
    
    BabyBluetooth *_baby;
}

@end

@implementation XMGMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpNav];
    
    [self setUpTableView];
    
    //创建蓝牙
    [self setUpBabyBluetooth];
}

- (void)setUpBabyBluetooth{
        
    //初始化BabyBluetooth 蓝牙库
    _baby = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    //    [self babyDelegate];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态
    _baby.scanForPeripherals().begin();
    
    
}

- (void)setUpTableView{

//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
    self.tableView.backgroundColor = XMGGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[XMGMeCell class] forCellReuseIdentifier:XMGMeId];
    
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = XMGTopicCellMargin;
    
    self.tableView.contentInset = UIEdgeInsetsMake(XMGTopicCellMargin - 35, 0, 0, 0);
    
    self.tableView.tableFooterView = [[XMGMeFooterView alloc] init];
}

- (void)setUpNav{

    self.view.backgroundColor = XMGGlobalBg;
    
    self.navigationItem.title = @"我的";
    
    self.navigationItem.rightBarButtonItems = @[[UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)],
                                                [UIBarButtonItem itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" target:self action:@selector(moonClick)]];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    XMGMeCell *cell = [tableView dequeueReusableCellWithIdentifier:XMGMeId];
    
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"mine_icon_nearby"];
        cell.textLabel.text = @"登录/注册";
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"离线下载";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1) {
        CZDownloadViewController *downloadVc = [CZDownloadViewController downloadViewController];
        [self.navigationController pushViewController:downloadVc animated:YES];
    }
}

- (void)settingClick{
    XMGLogFunc;
}

- (void)moonClick{
    XMGLogFunc;
}
@end
