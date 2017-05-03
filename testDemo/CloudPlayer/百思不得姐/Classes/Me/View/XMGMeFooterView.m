//
//  XMGMeFooterView.m
//  百思不得姐
//
//  Created by hwawo on 16/7/21.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGMeFooterView.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "XMGSquare.h"
#import "XMGSqaureButton.h"
#import "XMGWebViewController.h"
@implementation XMGMeFooterView
- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
        
        [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
            NSArray *squares = [XMGSquare mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
            
            [self createSquares:squares];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    return self;
}

- (void)createSquares:(NSArray *)squares{

    int maxCols = 4;
    
    CGFloat buttonW = XMGScreenW / maxCols;
    CGFloat buttonH = buttonW;
    for (int i=0; i<squares.count; i++) {
        XMGSqaureButton *btn = [XMGSqaureButton buttonWithType:UIButtonTypeCustom];
        btn.square = squares[i];
        
        CGFloat row = i/maxCols;
        CGFloat col = i%maxCols;
        CGFloat buttonX = col * buttonW;
        CGFloat buttonY = row * buttonH;
        btn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [self addSubview:btn];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    NSUInteger rows = (squares.count + maxCols -1)/maxCols;
    self.lh_Height = rows * buttonH;
    [self setNeedsDisplay];

}

- (void)btnClick:(XMGSqaureButton *)button{

    if (![button.square.url hasPrefix:@"http://"]) return;
    
    XMGWebViewController *webVc = [XMGWebViewController webViewController];
    webVc.title = button.square.name;
    webVc.url = button.square.url;
    
    UITabBarController *tabBarVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *navVc = (UINavigationController *)tabBarVc.selectedViewController;
    [navVc pushViewController:webVc animated:YES];
}
@end
