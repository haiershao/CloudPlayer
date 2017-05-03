//
//  UIView+XMGExtension.m
//  百思不得姐
//
//  Created by hwawo on 16/6/29.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "UIView+XMGExtension.h"

@implementation UIView (XMGExtension)
- (void)setLh_Center:(CGPoint)lh_Center{

    CGPoint center = self.center;
    center = lh_Center;
    self.center = center;
}

- (void)setLh_Size:(CGSize)lh_Size{

    CGRect frame = self.frame;
    frame.size = lh_Size;
    self.frame = frame;
}

- (void)setLh_Width:(CGFloat)lh_Width{

    CGRect frame = self.frame;
    frame.size.width = lh_Width;
    self.frame = frame;
}

- (void)setLh_Height:(CGFloat)lh_Height{

    CGRect frame = self.frame;
    frame.size.height = lh_Height;
    self.frame = frame;
}

- (void)setLh_X:(CGFloat)lh_X{

    CGRect frame = self.frame;
    frame.origin.x = lh_X;
    self.frame = frame;
}

- (void)setLh_Y:(CGFloat)lh_Y{

    CGRect frame = self.frame;
    frame.origin.y = lh_Y;
    self.frame = frame;
}

- (void)setLh_CenterX:(CGFloat)lh_CenterX{

    CGPoint center = self.center;
    center.x = lh_CenterX;
    self.center = center;
}

- (void)setLh_CenterY:(CGFloat)lh_CenterY{

    CGPoint center = self.center;
    center.y = lh_CenterY;
    self.center = center;
}

- (CGPoint)lh_Center{
    
    return self.center;
}

- (CGSize)lh_Size{

    return self.frame.size;
}

- (CGFloat)lh_Width{

    return self.frame.size.width;
}

- (CGFloat)lh_Height{

    return self.frame.size.height;
}

- (CGFloat)lh_X{

    return self.frame.origin.x;
}

- (CGFloat)lh_Y{

    return self.frame.origin.y;
}

- (CGFloat)lh_CenterX{

    return self.center.x;
}

- (CGFloat)lh_CenterY{

    return self.center.y;
}

- (void)setTop:(CGFloat)t
{
    self.frame = CGRectMake(self.left, t, self.lh_Width, self.lh_Height);
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setBottom:(CGFloat)b
{
    self.frame = CGRectMake(self.left, b - self.lh_Height, self.lh_Width, self.lh_Height);
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setLeft:(CGFloat)l
{
    self.frame = CGRectMake(l, self.top, self.lh_Width, self.lh_Height);
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setRight:(CGFloat)r
{
    self.frame = CGRectMake(r - self.lh_Width, self.top, self.lh_Width, self.lh_Height);
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (BOOL)isShowingOnKeyWindow{

    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    CGRect newFrame = [keyWindow convertRect:self.frame fromView:self.superview];
    CGRect winBounds = keyWindow.bounds;
    
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    
    return !self.hidden && self.alpha > 0.01 && self.window == keyWindow && intersects;
}

+ (instancetype)viewFromXIB{

    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}
@end
