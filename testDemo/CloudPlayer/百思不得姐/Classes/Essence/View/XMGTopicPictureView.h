//
//  XMGTopicPictureView.h
//  百思不得姐
//
//  Created by hwawo on 16/7/8.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMGTopic;
@interface XMGTopicPictureView : UIView
+ (instancetype)topicPictureView;
/** 帖子数据 */
@property (nonatomic, strong) XMGTopic *topic;
@end
