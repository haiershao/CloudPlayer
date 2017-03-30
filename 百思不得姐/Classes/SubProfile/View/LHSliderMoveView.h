//
//  LHSliderMoveView.h
//  JLSlideDemo
//
//  Created by hwawo on 17/3/22.
//  Copyright © 2017年 job. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol slidMoveDelegate <NSObject>

-(void)slidMovedLeft:(CGFloat)leftPosition andRightPosition:(CGFloat) rightPosition;

-(void)slidDidEndMovedLeft:(CGFloat)leftPosition andRightPosition:(CGFloat) rightPosition;

@end

@interface LHSliderMoveView : UIView
@property (assign, nonatomic) CGFloat   leftPosition;
@property (assign, nonatomic) CGFloat   rightPosition;
@property (assign, nonatomic) BOOL isRound;
@property (strong, nonatomic) UIColor *thumbColor;
@property (weak,   nonatomic) id <slidMoveDelegate> delegate;
@end
