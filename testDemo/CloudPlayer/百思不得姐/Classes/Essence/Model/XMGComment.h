//
//  XMGComment.h
//  百思不得姐
//
//  Created by hwawo on 16/7/14.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XMGUser;
@interface XMGComment : NSObject
/** id */
@property (nonatomic, copy) NSString *ID;
/** 音频文件的时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 评论的文字内容 */
@property (nonatomic, copy) NSString *content;
/** 音频文件的路径 */
@property (nonatomic, copy) NSString *voiceuri;
/** 被点赞的数量 */
@property (nonatomic, assign) NSInteger like_count;
/** 用户 */
@property (nonatomic, strong) XMGUser *user;
@end
