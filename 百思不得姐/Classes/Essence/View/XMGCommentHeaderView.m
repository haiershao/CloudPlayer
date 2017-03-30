//
//  XMGCommentHeaderView.m
//  百思不得姐
//
//  Created by hwawo on 16/7/18.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGCommentHeaderView.h"
@interface XMGCommentHeaderView()
/** 文字标签 */
@property (nonatomic, weak) UILabel *label;
@end
@implementation XMGCommentHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView{

    static NSString *ID = @"header";
    XMGCommentHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!headerView) {
        headerView = [[XMGCommentHeaderView alloc] initWithReuseIdentifier:ID];
    }
    
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UILabel *label = [[UILabel alloc] init];
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        label.textColor = XMGRGBColor(67, 67, 67);
        label.lh_X = XMGTopicCellMargin;
        label.lh_Width = 200;
        [self.contentView addSubview:label];
        self.label = label;
    }
    return self;
    
}

- (void)setTitle:(NSString *)title{

    _title = [title copy];
    self.label.text = title;
    
}
@end
