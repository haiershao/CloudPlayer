//
//  XMGGyroTool.h
//  Cloud Player
//
//  Created by jiyi on 2017/11/17.
//  Copyright © 2017年 ichano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGGyroTool : NSObject
+ (id)shareGyro;

//开启设备旋转监控
- (void)startMonitorDeviceRotate;

//关闭设备旋转监控
- (void)stopDeviceMotionUpdate;

//设备是否支持屏幕旋转
- (BOOL)canBeRotated;

//获取设备当前的方向状态
- (UIDeviceOrientation)deviceOrientation;
@end
