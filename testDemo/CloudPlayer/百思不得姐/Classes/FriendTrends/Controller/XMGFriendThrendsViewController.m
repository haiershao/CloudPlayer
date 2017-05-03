//
//  XMGFriendThrendsViewController.m
//  百思不得姐
//
//  Created by hwawo on 16/6/29.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGFriendThrendsViewController.h"
#import "XMGRecommendViewController.h"
#import "XMGLoginRegisterViewController.h"
@interface XMGFriendThrendsViewController ()

@end

@implementation XMGFriendThrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的关注";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon" target:self action:@selector(friendButtonClick)];
    
    self.view.backgroundColor = XMGGlobalBg;
}

- (void)friendButtonClick{

     XMGLogFunc;
    XMGRecommendViewController *recommendVc = [XMGRecommendViewController recommendViewController];
    [self.navigationController pushViewController:recommendVc animated:YES];
}
- (IBAction)loginRegister:(UIButton *)sender {
    XMGLoginRegisterViewController *loginRegisterVc = [XMGLoginRegisterViewController loginRegisterViewController];
    [self presentViewController:loginRegisterVc animated:YES completion:nil];
}
@end
