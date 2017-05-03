//
//  HWReportCell.m
//  HuaWo
//
//  Created by yjc on 2017/4/13.
//  Copyright © 2017年 HW. All rights reserved.
//

#import "HWReportCell.h"

@interface HWReportCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation HWReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
