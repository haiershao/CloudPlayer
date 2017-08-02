//
//  XMGRecordEngine.h
//  Cloud Player
//
//  Created by XMG on 2017/8/1.
//  Copyright © 2017年 ichano. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol WCLRecordEngineDelegate <NSObject>

@end

@interface XMGRecordEngine : NSObject
@property (atomic, strong) NSString *videoPath;//视频路径
@property (weak, nonatomic) id<WCLRecordEngineDelegate>delegate;
@property (strong, nonatomic) UIView *recordView;
//捕获到的视频呈现的layer
- (AVCaptureVideoPreviewLayer *)previewLayer;
//启动录制功能
- (void)startUp;
//关闭录制功能
- (void)shutdown;
//开始录制
- (void) startCapture;
//停止录制
- (void) stopCaptureHandler:(void (^)(UIImage *movieImage))handler;
@end
