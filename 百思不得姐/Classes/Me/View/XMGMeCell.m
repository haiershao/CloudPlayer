//
//  XMGMeCell.m
//  百思不得姐
//
//  Created by hwawo on 16/7/20.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGMeCell.h"

@implementation XMGMeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"mainCellBackground"];
        self.backgroundView = imageView;
        
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.textLabel.font = [UIFont systemFontOfSize:16];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (!self.imageView.image) return;

    self.imageView.lh_Width = 30;
    self.imageView.lh_Height = self.imageView.lh_Width;
    self.imageView.lh_CenterY = self.contentView.lh_Height * 0.5;
    
    self.textLabel.lh_X = CGRectGetMaxX(self.imageView.frame) + XMGTopicCellMargin;
}
@end
