//
//  LHSliderView.h
//  JLSlideDemo
//
//  Created by hwawo on 17/3/22.
//  Copyright © 2017年 job. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LHSliderType) {
    //滑动的在轴上
    LHSliderTypeCenter = 0,
    LHSliderTypeBottom = 1,
};

@protocol LHSliderViewDelegate <NSObject>

-(void)sliderViewDidSliderLeft:(NSUInteger )leftValue right:(NSUInteger )rightValue;

@end

@interface LHSliderView : UIView
@property (strong, nonatomic) UIColor *thumbColor;

@property (strong, nonatomic) UIColor *bgColor;

@property (assign, nonatomic) NSUInteger minValue;


@property (assign, nonatomic) NSUInteger maxValue;

@property (assign, nonatomic) LHSliderType sliderType;

@property (assign, nonatomic, readonly) NSUInteger currentMinValue;

@property (assign, nonatomic, readonly) NSUInteger currentMaxValue;

@property (assign, nonatomic) id<LHSliderViewDelegate> delegate;


-(instancetype)initWithFrame:(CGRect)frame sliderType:(LHSliderType )type;
@end
