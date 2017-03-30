//
//  LHSliderView.m
//  JLSlideDemo
//
//  Created by hwawo on 17/3/22.
//  Copyright © 2017年 job. All rights reserved.
//

#import "LHSliderView.h"
#import "LHSliderMoveView.h"
#import "UIView+XMGExtension.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define iconwidth   80
#define iconheight  28

@interface LHSliderView()<slidMoveDelegate>

@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) LHSliderMoveView *moveView;
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UILabel *leftTopLabel;
@property (strong, nonatomic) UILabel *rightTopLabel;


@property (assign, nonatomic) CGFloat moveVHeight;

@property (assign, nonatomic) CGFloat lineVHeight;

@property (assign, nonatomic, readwrite) NSUInteger currentMinValue;

@property (assign, nonatomic, readwrite) NSUInteger currentMaxValue;
@end

@implementation LHSliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame sliderType:(LHSliderType )type {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView];
        self.sliderType = type;
    }
    return self;
}

- (void)setMaxValue:(NSUInteger)maxValue{

    _maxValue = maxValue;
    self.rightTopLabel.text = [NSString stringWithFormat:@"%lu秒", (unsigned long)self.maxValue];
    
}

- (void)setMinValue:(NSUInteger)minValue{

    _minValue = minValue;
    self.leftTopLabel.text = [NSString stringWithFormat:@"%lu秒", (unsigned long)self.minValue];
    
}


-(void)initView {
    self.moveVHeight = 50;
    self.lineVHeight = 3;
    self.userInteractionEnabled = YES;
//    self.minValue = 0;
//    self.maxValue = 100;
    
    self.currentMaxValue = 100;
    self.currentMinValue = 0.5*self.currentMaxValue;
    [self initMoveView];
    //顶部左边脚标
    self.leftTopLabel = [self  creatLabelWithFrame:CGRectMake(self.lineView.left - iconwidth/2 , 0, iconwidth, iconheight)];
    
//    self.leftTopLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.minValue];
    [self addSubview:self.leftTopLabel];
    //顶部右边脚标
    self.rightTopLabel = [self  creatLabelWithFrame:CGRectMake(self.lineView.right - iconwidth/2 , 0, iconwidth, iconheight)];
    
//    self.rightTopLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.maxValue];
    [self addSubview:self.rightTopLabel];
    
    
}

-(UILabel *)creatLabelWithFrame:(CGRect )frame {
    UILabel *label =  [[UILabel alloc]initWithFrame:frame];
    label.textColor = [UIColor whiteColor];
    label.font      = [UIFont systemFontOfSize:14];
    label.layer.cornerRadius = 5;
    label.layer.masksToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = XMGWordColor;
    return  label;
}





-(void)initMoveView {
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(30, iconheight +self.moveVHeight/2 + 5, kScreenWidth - 60, self.lineVHeight)];
    self.bgView.backgroundColor = [UIColor lightGrayColor];
    self.bgView.layer.cornerRadius = self.bgView.lh_Height/2                                                            ;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.bgView];
    //改变颜色的线
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(30, iconheight +self.moveVHeight/2 + 5, kScreenWidth - 60, self.lineVHeight)];
    self.bgView.backgroundColor = self.bgColor;
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(30, iconheight +self.moveVHeight/2 + 5, kScreenWidth - 60, self.lineVHeight)];
    self.lineView.backgroundColor = self.thumbColor;
    self.lineView.layer.cornerRadius = self.lineView.lh_Height/2                                                            ;
    self.lineView.layer.masksToBounds = YES;
    [self addSubview:self.lineView];
    
    //手指移动的视图
    self.moveView = [[LHSliderMoveView alloc]initWithFrame:CGRectMake(self.lineView.left-self.moveVHeight/2 , self.lineView.bottom, self.lineView.lh_Width+self.moveVHeight, self.moveVHeight)];
    self.moveView.delegate = self;
    [self addSubview:self.moveView];
}

-(void)setSliderType:(LHSliderType)sliderType {
    if (sliderType == LHSliderTypeCenter) {
        self.moveView.lh_CenterY = self.lineView.lh_CenterY;
        self.moveView.isRound = YES;
    }else if (sliderType == LHSliderTypeBottom){
        self.moveView.top = self.lineView.bottom+10;
        self.moveView.isRound = NO;
        self.moveView.thumbColor = self.thumbColor;
    }
}

-(void)setThumbColor:(UIColor *)thumbColor {
    _thumbColor = thumbColor;
    self.lineView.backgroundColor = thumbColor;
}

-(void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.bgView.backgroundColor = bgColor;
}


#pragma mark --- 代理方法
-(void)slidMovedLeft:(CGFloat)leftPosition andRightPosition:(CGFloat)rightPosition {
    self.lineView.lh_X = 30+leftPosition-10;
    self.lineView.lh_Width = rightPosition - leftPosition;
    
    self.leftTopLabel.lh_CenterX  = leftPosition + 30 -10;
    self.rightTopLabel.lh_CenterX = rightPosition + 30 - 10;
    
    NSUInteger width = self.maxValue - self.minValue;
    NSUInteger left  = self.minValue +(int) (self.lineView.lh_X - self.bgView.lh_X)/self.bgView.lh_Width * width;
    NSUInteger right  = self.minValue +(int) (self.lineView.right - self.bgView.lh_X)/self.bgView.lh_Width * width;
    self.currentMinValue = left;
    self.currentMaxValue = right;
    self.rightTopLabel.text = [NSString stringWithFormat:@"%lu秒", (unsigned long)right];
    self.leftTopLabel.text  = [NSString stringWithFormat:@"%lu秒", (unsigned long)left];
    
    XMGLog(@"touchesMoved : %@--%@",self.leftTopLabel.text, self.rightTopLabel.text);
    NSMutableArray *tempArr = [NSMutableArray array];
    tempArr[0] = self.leftTopLabel;
    tempArr[1] = self.rightTopLabel;
    [DZNotificationCenter postNotificationName:@"LHSliderMoveViewToValue" object:tempArr];
    
    if (self.lineView.lh_Width == 0) {
        self.lineView.lh_Width = 1;
    }
}

-(void)slidDidEndMovedLeft:(CGFloat)leftPosition andRightPosition:(CGFloat)rightPosition {
    
    if ([self.delegate respondsToSelector:@selector(sliderViewDidSliderLeft:right:)]) {
        [self.delegate sliderViewDidSliderLeft:[self.leftTopLabel.text integerValue] right:[self.rightTopLabel.text integerValue]];
    }
}

@end
