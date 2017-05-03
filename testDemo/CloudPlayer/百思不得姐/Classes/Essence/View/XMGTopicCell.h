//
//  XMGTopicCell.h
//  百思不得姐
//
//  Created by hwawo on 16/7/7.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^PlayBtnCallBackBlock)(UIButton *);

@class XMGTopic;
@class XMGTopicVideoView;
@interface XMGTopicCell : UITableViewCell
@property (nonatomic, strong) XMGTopic *topic;
@property (weak, nonatomic) XMGTopicVideoView *videoView;
@property (strong, nonatomic) UIButton *playBtn;

/** 播放按钮block */
@property (nonatomic, copy  ) PlayBtnCallBackBlock playBlock;
+ (instancetype)topicCell;
@end
