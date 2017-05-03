//
//  NSDate+XMGExtension.h
//  百思不得姐
//
//  Created by hwawo on 16/7/8.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (XMGExtension)
/**
 * 比较from和self的时间差值
 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;

/**
 * 是否为今年
 */
- (BOOL)isThisYear;

/**
 * 是否为今天
 */
- (BOOL)isToday;

/**
 * 是否为昨天
 */
- (BOOL)isYesterday;
@end
