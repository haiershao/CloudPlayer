//
//  XMGCommentViewController.h
//  百思不得姐
//
//  Created by hwawo on 16/7/14.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMGTopic;
@interface XMGCommentViewController : UIViewController
/** 帖子模型 */
@property (nonatomic, strong) XMGTopic *topic;
+ (instancetype)commentViewController;
@end
