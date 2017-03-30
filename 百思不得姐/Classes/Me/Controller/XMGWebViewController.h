//
//  XMGWebViewController.h
//  百思不得姐
//
//  Created by hwawo on 16/7/21.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMGWebViewController : UIViewController
/** 链接 */
@property (nonatomic, copy) NSString *url;
+ (instancetype)webViewController;
@end
