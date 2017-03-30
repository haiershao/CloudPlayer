//
//  XMGTabBar.m
//  百思不得姐
//
//  Created by hwawo on 16/6/29.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGTabBar.h"
#import "XMGPublishViewController.h"
#import "XMGPostWordViewController.h"
#import "XMGNavigationController.h"
@interface XMGTabBar ()
@property (nonatomic, weak) UIButton *publishButton;
@end
@implementation XMGTabBar

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        _publishButton = button;
    }
    return self;
}

- (void)publishClick{

    XMGPublishViewController *publishVc = [XMGPublishViewController publishViewController];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:publishVc animated:NO completion:nil];
    
//    XMGPostWordViewController *postWordVc = [[XMGPostWordViewController alloc] init];
//    XMGNavigationController *nav = [[XMGNavigationController alloc] initWithRootViewController:postWordVc];
//    
//    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
//     [root presentViewController:nav animated:YES completion:nil];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    static BOOL added = NO;
    
    self.publishButton.bounds = CGRectMake(0, 0, self.publishButton.currentBackgroundImage.size.width, self.publishButton.currentBackgroundImage.size.height);
    self.publishButton.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
    
    CGFloat buttonX = 0;
    CGFloat buttonY = 0;
    CGFloat buttonW = self.frame.size.width/5;
    CGFloat buttonH = self.frame.size.height;
    NSInteger i = 0;
    for (UIControl *button in self.subviews) {
        if (![button isKindOfClass:[UIControl class]] || button == self.publishButton) continue;
        buttonX = buttonW*((i>1)?(i+1):i);
        i++;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        if (!added) {
            [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
}

- (void)buttonClick{

    [XMGNoteCenter postNotificationName:XMGTabBarDidSelectNotification object:nil userInfo:nil];
}
@end
