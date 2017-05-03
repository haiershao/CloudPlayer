//
//  GHHImageItem.m
//  ThugLife
//
//  Created by 高瑞浩 on 2017/3/13.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "GHHImageItem.h"

@interface GHHImageItem()

@property(nonatomic, copy)NSString *title;
@property(nonatomic, strong)PHFetchResult *fetchResult;

@end

@implementation GHHImageItem

- (instancetype)initWithTitle:(NSString *)title fetchResult:(PHFetchResult *)fetchResult {
    self = [super init];
    if (self) {
        self.title = title;
        self.fetchResult = fetchResult;
    }
    return self;
}

@end
