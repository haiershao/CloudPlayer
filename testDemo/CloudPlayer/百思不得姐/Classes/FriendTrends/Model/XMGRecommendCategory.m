//
//  XMGRecommendCategory.m
//  百思不得姐
//
//  Created by hwawo on 16/7/1.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGRecommendCategory.h"

@implementation XMGRecommendCategory
- (NSMutableArray *)users{
    
    if (!_users) {
        _users = [NSMutableArray array];
    }
    return _users;
}

@end
