//
//  XMGTagButton.m
//  百思不得姐
//
//  Created by hwawo on 16/7/22.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGTagButton.h"

@implementation XMGTagButton
- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.backgroundColor = XMGTagBg;
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{

    [super setTitle:title forState:state];

    [self sizeToFit];
    
    self.lh_Width += 3*XMGTagMargin;
}


- (void)layoutSubviews{

    [super layoutSubviews];
    self.titleLabel.lh_X = XMGTagMargin;
    self.imageView.lh_X = CGRectGetMaxX(self.titleLabel.frame) + XMGTagMargin;
    
}
@end
