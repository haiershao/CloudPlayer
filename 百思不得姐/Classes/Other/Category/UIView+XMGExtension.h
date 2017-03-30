//
//  UIView+XMGExtension.h
//  百思不得姐
//
//  Created by hwawo on 16/6/29.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XMGExtension)
@property (nonatomic, assign) CGSize lh_Size;
@property (nonatomic, assign) CGPoint lh_Center;
@property (nonatomic, assign) CGFloat lh_Width;
@property (nonatomic, assign) CGFloat lh_Height;
@property (nonatomic, assign) CGFloat lh_X;
@property (nonatomic, assign) CGFloat lh_Y;
@property (nonatomic, assign) CGFloat lh_CenterX;
@property (nonatomic, assign) CGFloat lh_CenterY;

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;

- (BOOL)isShowingOnKeyWindow;
+ (instancetype)viewFromXIB; 
@end
