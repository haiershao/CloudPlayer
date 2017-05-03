//
//  LHSliderMoveView.m
//  JLSlideDemo
//
//  Created by hwawo on 17/3/22.
//  Copyright © 2017年 job. All rights reserved.
//

#import "LHSliderMoveView.h"
#import "UIView+XMGExtension.h"

typedef enum : NSUInteger {
    SlideTypeLeft,
    SlideTypeRight,
    SlideTypeNone,
} SlideType;

@interface LHSliderMoveView(){
    CGFloat  iconwidth;
}
@property (strong, nonatomic) UILabel *leftLabel;
@property (strong, nonatomic) UILabel *rightLabel;

//是否重合
@property (assign, nonatomic) BOOL isCoincide;
@property (assign, nonatomic) SlideType slideType;
@property (assign, nonatomic) CGFloat coincideX;
@property (assign, nonatomic) CGFloat startX;
@end

@implementation LHSliderMoveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        self.userInteractionEnabled = YES;
        iconwidth = self.lh_Height;
        
        
        self.leftLabel = [self creatLabelWithFrame:CGRectMake(0, 0, iconwidth, self.lh_Height)];
        [self addSubview:self.leftLabel];
        UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(doLeftPanGesture:)];
        [self.leftLabel addGestureRecognizer:leftPan];
        
        
        self.rightLabel = [self creatLabelWithFrame:CGRectMake(self.lh_Width - iconwidth, 0, iconwidth, self.lh_Height)];
        [self addSubview:self.rightLabel];
        
        UIPanGestureRecognizer *rightPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(doRightPanGesture:)];
        [self.leftLabel addGestureRecognizer:rightPan];
        
        self.leftPosition  = self.leftLabel.lh_CenterX;
        self.rightPosition = self.rightLabel.lh_CenterX;
    }
    return self;
}




-(UILabel *)creatLabelWithFrame:(CGRect )frame {
    UILabel *label =  [[UILabel alloc]initWithFrame:frame];
    label.textColor = [UIColor darkGrayColor];
    label.backgroundColor = [UIColor whiteColor];
    label.layer.masksToBounds = YES;
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    return  label;
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"移动了");
    UITouch *touch  = [touches anyObject];
    CGPoint  point  = [touch locationInView:self];
    
    
    if(self.isCoincide){
        if (point.x > self.coincideX +1 ) {
            self.slideType = SlideTypeRight;
            self.isCoincide = NO;
        }
        if (point.x < self.coincideX -1 ) {
            self.slideType = SlideTypeLeft;
            self.isCoincide = NO;
        }
        return;
    }
    //超出滑动的位置则不可以控制---- 左边的位置大于右边的位置不能滑动
    if (point.y>self.lh_Height) {
        return;
    }
    //当滑动的位置不在两个
    if (self.slideType == SlideTypeNone) {
        return;
    }
    //当滑动左边的时候
    if (self.slideType == SlideTypeLeft ) {
        CGFloat maxRight = self.rightLabel.lh_CenterX;
        if (point.x < maxRight || self.rightLabel.lh_CenterX > self.leftLabel.lh_CenterX) {
            self.leftLabel.lh_CenterX = point.x;
            if (self.leftLabel.lh_CenterX < iconwidth/2) {
                self.leftLabel.lh_CenterX = iconwidth/2;
            }
            if (self.leftLabel.lh_CenterX > self.rightLabel.lh_CenterX) {
                self.leftLabel.lh_CenterX = self.rightLabel.lh_CenterX;
            }
            self.leftPosition = self.leftLabel.lh_CenterX ;
            if ([self.delegate respondsToSelector:@selector(slidMovedLeft:andRightPosition:)]) {
                [self.delegate slidMovedLeft:self.leftPosition andRightPosition:self.rightPosition];
            }
        }
    }
    //当滑动右边的时候
    if (self.slideType == SlideTypeRight) {
        CGFloat maxLeft = self.leftLabel.lh_CenterX;
        if (point.x > maxLeft || self.rightLabel.lh_CenterX > self.leftLabel.lh_CenterX) {
            self.rightLabel.lh_CenterX = point.x;
            if (self.rightLabel.lh_CenterX > self.lh_Width-iconwidth/2) {
                self.rightLabel.lh_CenterX = self.lh_Width-iconwidth/2;
            }
            if (self.leftLabel.lh_CenterX > self.rightLabel.lh_CenterX) {
                self.rightLabel.lh_CenterX = self.leftLabel.lh_CenterX;
            }
            self.rightPosition = self.rightLabel.lh_CenterX ;
            if ([self.delegate respondsToSelector:@selector(slidMovedLeft:andRightPosition:)]) {
                [self.delegate slidMovedLeft:self.leftPosition andRightPosition:self.rightPosition];
            }
            
        }
    }
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"开始点击");
    UITouch *touch  = [touches anyObject];
    CGPoint  point  = [touch locationInView:self];
    self.startX = point.x;
    //当手指点中下面的滑条时，才能滑动
    
    //如果重合
    if (self.rightLabel.lh_CenterX-5<self.leftLabel.lh_CenterX    &&  self.leftLabel.lh_CenterX< self.rightLabel.lh_CenterX+5 )  {
        self.isCoincide = YES;
        self.coincideX  = point.x;
        return;
    }else {
        self.isCoincide = NO;
    }
    
    //手指放在左边范围
    if (point.x <self.leftLabel.right && point.x >self.leftLabel.left) {
        self.slideType = SlideTypeLeft;
    }else  if (point.x <self.rightLabel.right && point.x >self.rightLabel.left) {
        self.slideType = SlideTypeRight;
    }else {
        self.slideType = SlideTypeNone;
    }
    
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(slidDidEndMovedLeft:andRightPosition:)]) {
        [self.delegate slidDidEndMovedLeft:self.leftPosition  andRightPosition:self.rightPosition];
    }
    
}


-(void)setIsRound:(BOOL)isRound {
    _isRound = isRound;
    if (isRound) {
        self.leftLabel.lh_Size    = CGSizeMake(self.lh_Height, self.lh_Height);
        self.leftLabel.layer.cornerRadius = self.leftLabel.lh_Height /2;
        self.rightLabel.lh_Size = CGSizeMake(self.lh_Height, self.lh_Height);
        self.rightLabel.layer.cornerRadius = self.rightLabel.lh_Height /2;
    }
}
-(void)setThumbColor:(UIColor *)thumbColor {
    _thumbColor = thumbColor;
    _leftLabel.backgroundColor = thumbColor;
    _rightLabel.backgroundColor = thumbColor;
}


-(void)doLeftPanGesture:(UIPanGestureRecognizer *)gesture {
    
    CGFloat startX = 0.0;
    CGPoint point = [gesture translationInView:self];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        startX = gesture.view.lh_CenterX;
        
    }if (gesture.state == UIGestureRecognizerStateChanged) {
        self.leftLabel.lh_CenterX = startX + point.x;
        
    }if (gesture.state == UIGestureRecognizerStateEnded) {
        
    }
    
}

-(void)doRightPanGesture:(UIPanGestureRecognizer *)gesture {
    
}

@end
