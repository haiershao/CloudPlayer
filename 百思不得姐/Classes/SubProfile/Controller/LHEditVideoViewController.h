//
//  LHEditVideoViewController.h
//  Player
//
//  Created by hwawo on 17/3/21.
//  Copyright © 2017年 任子丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHEditVideoViewController : UIViewController
/** 视频URL */
@property (nonatomic, strong) NSURL *videoURL;


+ (instancetype)editVideoViewController;

@end
