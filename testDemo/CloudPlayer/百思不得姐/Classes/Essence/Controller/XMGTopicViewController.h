//
//  XMGTopicViewController.h
//  百思不得姐
//
//  Created by hwawo on 16/7/8.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef enum {
//    XMGTopicTypeAll = 1,
//    XMGTopicTypeWord = 29,
//    XMGTopicTypeVideo = 41,
//    XMGTopicTypeVoice = 31,
//    XMGTopicTypePicture = 10
//} XMGTopicType;

@interface XMGTopicViewController : UITableViewController
/*
 帖子的类型交给子类去实现
 */
@property (nonatomic, assign) XMGTopicType type;
@end
