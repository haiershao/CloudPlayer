//
//  XMGVerticalButton.m
//  百思不得姐
//
//  Created by hwawo on 16/7/6.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGVerticalButton.h"

@implementation XMGVerticalButton
- (void)setUp{

    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib{

    [self setUp];
}

- (void)layoutSubviews{

    [super layoutSubviews];
    self.imageView.lh_X = 0;
    self.imageView.lh_Y = 0;
    self.imageView.lh_Width = self.lh_Width;
    self.imageView.lh_Height = self.imageView.lh_Width;
    
    self.titleLabel.lh_X = 0;
    self.titleLabel.lh_Y = self.imageView.lh_Height;
    self.titleLabel.lh_Width = self.lh_Width;
    self.titleLabel.lh_Height = self.lh_Height - self.titleLabel.lh_Y;
    
}
@end
