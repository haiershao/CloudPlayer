//
//  GHHImageItem.h
//  ThugLife
//
//  Created by 高瑞浩 on 2017/3/13.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GHHImageItem : NSObject

@property(nonatomic, readonly)NSString *title;
@property(nonatomic, readonly)PHFetchResult *fetchResult;
- (instancetype)initWithTitle:(NSString *)title fetchResult:(PHFetchResult *)fetchResult;

@end
