//
//  XMGRecommendTagCell.m
//  百思不得姐
//
//  Created by hwawo on 16/7/5.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGRecommendTagCell.h"
#import "XMGRecommendTag.h"
#import <UIImageView+WebCache.h>

@interface XMGRecommendTagCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageListImageView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;
@end
@implementation XMGRecommendTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setRecommendTag:(XMGRecommendTag *)recommendTag{
    _recommendTag = recommendTag;
    [self.imageListImageView setHeader:recommendTag.image_list];
    
    self.themeNameLabel.text = recommendTag.theme_name;
    
    NSString *subNumber = nil;
    if (recommendTag.sub_number < 10000) {
        subNumber = [NSString stringWithFormat:@"%zd人订阅",recommendTag.sub_number];
    }else{
        subNumber = [NSString stringWithFormat:@"%.1f万人订阅",(long)recommendTag.sub_number / 10000.0];
    }
    
    self.subNumberLabel.text = subNumber;
}

- (void)setFrame:(CGRect)frame{

    frame.origin.x = 5;
    frame.size.width = frame.size.width - 2*frame.origin.x;
    frame.size.height = frame.size.height - 1;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
