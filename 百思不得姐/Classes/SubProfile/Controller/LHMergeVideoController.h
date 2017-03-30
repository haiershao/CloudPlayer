//
//  LHMergeVideoController.h
//  Player
//
//  Created by hwawo on 17/3/23.
//  Copyright © 2017年 LH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHMergeVideoController : UIViewController
/** 视频URL */
@property (nonatomic, strong) NSURL *videoURL;

+ (instancetype)mergeVideoController;
@end
