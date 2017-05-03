//
//  XMGRecommendUserCell.m
//  百思不得姐
//
//  Created by hwawo on 16/7/1.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGRecommendUserCell.h"
#import "XMGRecommendUser.h"
#import <UIImageView+WebCache.h>
@interface XMGRecommendUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;
@end
@implementation XMGRecommendUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.backgroundColor = XMGGlobalBg;
    
}

- (void)setUser:(XMGRecommendUser *)user{

    _user = user;
    
    self.fansCountLabel.text = [NSString stringWithFormat:@"%zd人关注",user.fans_count];
    [self.headerImageView setHeader:user.header];
    self.screenNameLabel.text = user.screen_name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
