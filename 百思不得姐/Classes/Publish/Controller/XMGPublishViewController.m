//
//  XMGPublishViewController.m
//  百思不得姐
//
//  Created by hwawo on 16/7/11.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGPublishViewController.h"
#import "XMGVerticalButton.h"
#import <pop.h>
#import "CZDownloadViewController.h"
#import "XMGNavigationController.h"
#import "XMGPostWordViewController.h"
static CGFloat const XMGAnimationDelay = 0.1;
static CGFloat const XMGSpringFactor = 10;
@interface XMGPublishViewController ()

@end

@implementation XMGPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = NO;
    
    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    int maxCols = 3;
    CGFloat screenH = XMGScreenH;
    CGFloat screenW = XMGScreenW;
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 30;
    CGFloat buttonStartY = (screenH - 2*buttonH)/2;
    CGFloat buttonStartX = 20;
    CGFloat margin = (screenW - 2*buttonStartX - maxCols*buttonW)/(maxCols - 1);
    for (int i = 0; i < titles.count; i++) {
        XMGVerticalButton *button = [[XMGVerticalButton alloc] init];
        [self.view addSubview:button];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        int row = i / maxCols;
        int col = i % maxCols;

        CGFloat buttonX = buttonStartX + col*(margin + buttonW);
        CGFloat buttonEndY = buttonStartY + row*buttonH;
        CGFloat buttonBegainY = buttonEndY - XMGScreenH;
        
        
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonBegainY, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonEndY, buttonW, buttonH)];
        anim.springSpeed = XMGSpringFactor;
        anim.springBounciness = XMGSpringFactor;
        anim.beginTime = CACurrentMediaTime() + XMGAnimationDelay * i;
        [button pop_addAnimation:anim forKey:nil];
        
    }
    
    
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    [self.view addSubview:sloganView];
    
    CGFloat centerX = 0.5 * XMGScreenW;
    CGFloat centerEndY = 0.2*XMGScreenH;
    CGFloat centerBegainY = centerEndY - XMGScreenH;
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerBegainY)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerEndY)];
    anim.beginTime = CACurrentMediaTime() + images.count*XMGAnimationDelay;
    anim.springBounciness = XMGSpringFactor;
    anim.springSpeed = XMGSpringFactor;
    
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        self.view.userInteractionEnabled = YES;
    }];
    [sloganView pop_addAnimation:anim forKey:nil];
    
}

- (void)buttonClick:(UIButton *)button{

    [self cancelWithComplentionBlock:^{
        if (button.tag == 0) {
             XMGLog(@"发视频");
            
            
        }else if (button.tag == 1) {
        
            XMGLog(@"发图片");
        }else if (button.tag == 2) {
            
            XMGLog(@"发段子");
            XMGPostWordViewController *postWordVc = [[XMGPostWordViewController alloc] init];
            XMGNavigationController *nav = [[XMGNavigationController alloc] initWithRootViewController:postWordVc];
            
            UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
            [root presentViewController:nav animated:YES completion:nil];
        }else if (button.tag == 3) {
            
            XMGLog(@"发声音");
        
        }else if (button.tag == 4) {
            
            XMGLog(@"审帖");
        }else if (button.tag == 5) {
            
            XMGLog(@"离线下载");
            CZDownloadViewController *downloadVc = [CZDownloadViewController downloadViewController];
            UITabBarController *tabBarVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *navVc = (UINavigationController *)tabBarVc.selectedViewController;
            [navVc pushViewController:downloadVc animated:YES];
        }
    }];
}

- (void)cancelWithComplentionBlock:(void (^)())completionBlock{

    self.view.userInteractionEnabled = NO;
    
    int begainIndex = 2;
    for (int i = begainIndex; i < self.view.subviews.count; i++) {
        UIView *subview = self.view.subviews[i];
        
        CGFloat centerY = subview.lh_CenterY + XMGScreenH;
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(subview.lh_CenterX, centerY)];
        anim.beginTime = CACurrentMediaTime() + (i- begainIndex)*XMGAnimationDelay;
        [subview pop_addAnimation:anim forKey:nil];
        
        if (i == self.view.subviews.count - 1) {
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
                [self dismissViewControllerAnimated:nil completion:nil];
                !completionBlock ? : completionBlock();
            }];
        }
        
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self cancelWithComplentionBlock:nil];
}

+ (instancetype)publishViewController{

    return [[XMGPublishViewController alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (IBAction)cancel {
    
    [self cancelWithComplentionBlock:nil];
}

@end
