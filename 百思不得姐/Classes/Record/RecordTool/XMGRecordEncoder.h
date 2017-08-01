//
//  XMGRecordEncoder.h
//  Cloud Player
//
//  Created by XMG on 2017/8/1.
//  Copyright © 2017年 ichano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGRecordEncoder : NSObject
@property (nonatomic, readonly) NSString *path;
/**
 *  WCLRecordEncoder遍历构造器的
 *
 *  @param path 媒体存发路径
 *  @param cy   视频分辨率的高
 *  @param cx   视频分辨率的宽
 *  @param ch   音频通道
 *  @param rate 音频的采样比率
 *
 *  @return WCLRecordEncoder的实体
 */
+ (XMGRecordEncoder *)encoderForPath:(NSString*)path Height:(NSInteger)cy width:(NSInteger)cx channels: (int)ch samples:(Float64)rate;

- (void)finishWithCompletionHandler:(void (^)(void))handler;

/**
 *  通过这个方法写入数据
 *
 *  @param sampleBuffer 写入的数据
 *  @param isVideo      是否写入的是视频
 *
 *  @return 写入是否成功
 */
- (BOOL)encodeFrame:(CMSampleBufferRef)sampleBuffer isVideo:(BOOL)isVideo;
@end
