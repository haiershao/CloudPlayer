//
//  GHHPhotoManager.h
//  videoDemo
//
//  Created by 高瑞浩 on 2017/3/9.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GHHPhotoManager : NSObject

- (NSArray *)getAlbums;

- (NSArray *)getVideos;

- (void)getImageFromAsset:(PHAsset *)asset targetSize:(CGSize)size completeHandler:(void (^)(UIImage *))completeHandler;

- (AVURLAsset *)requestVideoWithAsset:(PHAsset *)asset;

@end
