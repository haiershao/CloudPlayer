//
//  XMGTopWindow.m
//  百思不得姐
//
//  Created by hwawo on 16/7/18.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGTopWindow.h"

@implementation XMGTopWindow
static UIWindow *window_;

+ (void)initialize{

    window_ = [[UIWindow alloc] init];
    CGFloat screenW = XMGScreenW;
    window_.frame  = CGRectMake(0, 0, screenW, 20);
    window_.windowLevel = UIWindowLevelAlert;
    window_.backgroundColor = [UIColor yellowColor];
    [window_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(windowClick)]];
}

+ (void)windowClick{

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self searchScrollViewInView:window];
}

+ (void)searchScrollViewInView:(UIView *)superView{

    for (UIScrollView *subview in superView.subviews) {
        
        if ([subview isKindOfClass:[UIScrollView class]]) {
            CGPoint offset = subview.contentOffset;
            offset.y = - subview.contentInset.top;
            [subview setContentOffset:offset];
        }
        
        [self searchScrollViewInView:subview];
    }
    
    
}

+ (void)show{

    window_.hidden = NO;

}

@end
