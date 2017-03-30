//
//  XMGCommentHeaderView.h
//  百思不得姐
//
//  Created by hwawo on 16/7/18.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMGCommentHeaderView : UITableViewHeaderFooterView
/** 文字数据 */
@property (nonatomic, copy) NSString *title;
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;
@end
