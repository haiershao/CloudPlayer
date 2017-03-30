//
//  XMGSqaureButton.m
//  百思不得姐
//
//  Created by hwawo on 16/7/21.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGSqaureButton.h"
#import "XMGSquare.h"
#import <UIButton+WebCache.h>
@implementation XMGSqaureButton

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp{

    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
}

- (void)awakeFromNib{

    [self setUp];
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    self.imageView.lh_Y = self.lh_Height * 0.15;
    self.imageView.lh_Width = self.lh_Width * 0.5;
    self.imageView.lh_Height = self.imageView.lh_Width;
    self.imageView.lh_CenterX = self.lh_Width * 0.5;
    
    self.titleLabel.lh_X = 0;
    self.titleLabel.lh_Y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.lh_Width = self.lh_Width;
    self.titleLabel.lh_Height = self.lh_Height - self.titleLabel.lh_Y;
}

- (void)setSquare:(XMGSquare *)square{

    _square = square;
    
    [self setTitle:square.name forState:UIControlStateNormal];
    [self sd_setImageWithURL:[NSURL URLWithString:square.icon] forState:UIControlStateNormal];
}
@end
