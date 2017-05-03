//
//  LHVideoRangeSlider.h
//  LHVideoRangeSlider
//
//  Created by hwawo on 16/6/29.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "LHSliderLeft.h"
#import "LHSliderRight.h"
#import "LHResizibleBubble.h"
#import <MediaPlayer/MediaPlayer.h>

@protocol LHVideoRangeSliderDelegate;

@interface LHVideoRangeSlider : UIView


@property (nonatomic, weak) id <LHVideoRangeSliderDelegate> delegate;
@property (nonatomic) CGFloat leftPosition;
@property (nonatomic) CGFloat rightPosition;
@property (nonatomic, strong) UILabel *bubleText;
@property (nonatomic, strong) UIView *topBorder;
@property (nonatomic, strong) UIView *bottomBorder;
@property (nonatomic, assign) NSInteger maxGap;
@property (nonatomic, assign) NSInteger minGap;

//左右两边颜色
@property (strong, nonatomic) UIColor *sliderLeftColor;
@property (strong, nonatomic) UIColor *sliderRightColor;

- (id)initWithFrame:(CGRect)frame videoUrl:(NSURL *)videoUrl;
- (void)setPopoverBubbleSize: (CGFloat) width height:(CGFloat)height;
+ (void)requestThumbnailImagesAtTimesMoviePlayer:(MPMoviePlayerController *)leftMoviePlayer leftPosition:(CGFloat)leftPosition;
+ (void)requestThumbnailImagesAtTimesMoviePlayer:(MPMoviePlayerController *)rightMoviePlayer rightPosition:(CGFloat)rightPosition;
@end


@protocol LHVideoRangeSliderDelegate <NSObject>

@optional

- (void)videoRange:(LHVideoRangeSlider *)videoRange didChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition;

- (void)videoRange:(LHVideoRangeSlider *)videoRange didGestureStateEndedLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition;


@end




