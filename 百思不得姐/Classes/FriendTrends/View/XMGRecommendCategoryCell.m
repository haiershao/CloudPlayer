//
//  XMGRecommendCategoryCell.m
//  百思不得姐
//
//  Created by hwawo on 16/7/1.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGRecommendCategoryCell.h"
#import "XMGRecommendCategory.h"
@interface XMGRecommendCategoryCell ()
@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;

@end
@implementation XMGRecommendCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = XMGRGBColor(244, 244, 244);
    self.selectedIndicator.backgroundColor = XMGRGBColor(219, 21, 26);
}

- (void)setCategory:(XMGRecommendCategory *)category{

    _category = category;
    self.textLabel.text = category.name;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    self.textLabel.lh_Y = 2;
    self.textLabel.lh_Height = self.contentView.lh_Height - 2*self.textLabel.lh_Y;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectedIndicator.hidden = !selected;
    
    self.textLabel.textColor = selected? self.selectedIndicator.backgroundColor : XMGRGBColor(78, 78, 78); 
}

@end
