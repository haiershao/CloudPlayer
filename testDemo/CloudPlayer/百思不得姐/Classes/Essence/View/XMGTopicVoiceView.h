//
//  XMGTopicVoiceView.h
//  百思不得姐
//
//  Created by hwawo on 16/7/12.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMGTopic;
@interface XMGTopicVoiceView : UIView
/** 帖子数据 */
@property (nonatomic, strong) XMGTopic *topic;
+ (instancetype)topicVoiceView;
@end
