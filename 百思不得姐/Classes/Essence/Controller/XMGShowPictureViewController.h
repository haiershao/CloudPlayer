//
//  XMGShowPictureViewController.h
//  百思不得姐
//
//  Created by hwawo on 16/7/9.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMGTopic;
@interface XMGShowPictureViewController : UIViewController
@property (nonatomic, strong) XMGTopic *topic;
+ (instancetype)showPictureViewController;
@end
