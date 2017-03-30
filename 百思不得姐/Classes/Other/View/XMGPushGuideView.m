//
//  XMGPushGuideView.m
//  百思不得姐
//
//  Created by hwawo on 16/7/6.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGPushGuideView.h"

@implementation XMGPushGuideView
//+ (instancetype)pushGuideView{
//
//    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
//}

+ (void)show{

    NSString *key = @"CFBundleShortVersionString";
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    if (![currentVersion isEqualToString:sanboxVersion]) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        XMGPushGuideView *guideView = [XMGPushGuideView viewFromXIB];
        guideView.frame = window.bounds;
        [window addSubview:guideView];
        
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (IBAction)close:(UIButton *)sender {
    [self removeFromSuperview];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
