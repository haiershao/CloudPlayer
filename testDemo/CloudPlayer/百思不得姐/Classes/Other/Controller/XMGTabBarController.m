//
//  XMGTabBarController.m
//  百思不得姐
//
//  Created by hwawo on 16/6/29.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGTabBarController.h"
#import "XMGEssenceViewController.h"
#import "XMGNewViewController.h"
#import "XMGFriendThrendsViewController.h"
#import "XMGMeViewController.h"
#import "XMGTabBar.h"
#import "XMGNavigationController.h"
@interface XMGTabBarController ()

@end

@implementation XMGTabBarController

+ (void)initialize{
    
    

    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor greenColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setUpChildVc:[[XMGEssenceViewController alloc] init] title:@"精华" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    
    [self setUpChildVc:[[XMGNewViewController alloc] init] title:@"新帖" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    
    [self setUpChildVc:[[XMGFriendThrendsViewController alloc] init] title:@"关注" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    
    [self setUpChildVc:[[XMGMeViewController alloc] initWithStyle:UITableViewStyleGrouped] title:@"我" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
    //更换tabbar
    [self setValue:[[XMGTabBar alloc] init] forKeyPath:@"tabBar"];
    
    
//    UIViewController *vc01 = [[UIViewController alloc] init];
//    vc01.title = @"精华";
//    vc01.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
//    vc01.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_essence_click_icon"];
//    
////    [vc01 .tabBarItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
////    [vc01.tabBarItem setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
//    
//    vc01.view.backgroundColor = [UIColor redColor];
//    [self addChildViewController:vc01];
//    
//    UIViewController *vc02 = [[UIViewController alloc] init];
//    vc02.title = @"新帖";
//    vc02.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon"];
//    vc02.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_new_click_icon"];
//    
//    vc02.view.backgroundColor = [UIColor grayColor];
//    [self addChildViewController:vc02];
//    
//    UIViewController *vc03 = [[UIViewController alloc] init];
//    vc03.title = @"关注";
//    vc03.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
//    vc03.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_friendTrends_click_icon"];
//    
//    vc03.view.backgroundColor = [UIColor greenColor];
//    [self addChildViewController:vc03];
//    
//    UIViewController *vc04 = [[UIViewController alloc] init];
//    vc04.title = @"我";
//    vc04.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
//    vc04.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_me_click_icon"];
//    
//    vc04.view.backgroundColor = [UIColor blueColor];
//    [self addChildViewController:vc04];
}

- (void)setUpChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{

    vc.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    XMGNavigationController *nav = [[XMGNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
