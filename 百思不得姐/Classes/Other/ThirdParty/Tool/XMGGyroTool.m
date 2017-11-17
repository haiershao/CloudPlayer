//
//  XMGGyroTool.m
//  Cloud Player
//
//  Created by jiyi on 2017/11/17.
//  Copyright © 2017年 ichano. All rights reserved.
//

#import "XMGGyroTool.h"
#import <CoreMotion/CoreMotion.h>
@interface XMGGyroTool () {
    
    BOOL canRotate;//标志位：判断现在能不能旋转屏幕
    
    UIDeviceOrientation deviceOrientation;
}
@property (nonatomic, strong) CMMotionManager * motionManager;//陀螺仪
@end

@implementation XMGGyroTool
+ (id)shareGyro
{
    static dispatch_once_t onceToken;
    static XMGGyroTool *gyroTool;
    dispatch_once(&onceToken, ^{
        gyroTool = [[self alloc] init];
    });
    return gyroTool;
}

#pragma mark - 判断屏幕是否支持旋转
- (void)startMonitorDeviceRotate
{
    canRotate = NO;//这个参数是整个问题解决的核心，注意它的变化
    
    [self startMotionManager];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDeviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}

//这个是系统横竖屏通知过来，自己需要操作的方法
- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation
{
    //1.获取 当前设备 实例
    UIDevice *device = [UIDevice currentDevice] ;
    /**
     *  2.取得当前Device的方向，Device的方向类型为Integer
     *
     *  必须调用beginGeneratingDeviceOrientationNotifications方法后，此orientation属性才有效，否则一直是0。orientation用于判断设备的朝向，与应用UI方向无关
     *
     *  @param device.orientation
     *
     */
    
    switch (device.orientation) {
            //其他情况屏幕方向就不一一列举出来了
        case UIDeviceOrientationLandscapeLeft:
            //            NSLog(@"屏幕向左横置");
            canRotate = YES;//只有当用户把手机旋转到横屏的时候来去触发判断是否支持横屏，如果不支持就提醒用户
            break;
            
        case UIDeviceOrientationLandscapeRight:
            //            NSLog(@"屏幕向右橫置");
            canRotate = YES;
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            //            NSLog(@"屏幕上下换位");
            canRotate = YES;
            break;
            
        case UIDeviceOrientationFaceUp:
            //            NSLog(@"屏幕向上");
            canRotate = YES;
            break;
            
        case UIDeviceOrientationFaceDown:
            //            NSLog(@"屏幕向下");
            canRotate = YES;
            break;
            
        default:
            break;
    }
    deviceOrientation = device.orientation;
    
}

//初始化
- (void)startMotionManager{
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    _motionManager.deviceMotionUpdateInterval = 1/15.0;//多长时间刷新一次
    if (_motionManager.deviceMotionAvailable) {
        //        NSLog(@"Device Motion Available");
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.name = @"com.gyro.queue";
        [_motionManager startDeviceMotionUpdatesToQueue:queue
                                            withHandler: ^(CMDeviceMotion *motion, NSError *error){
                                                [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
                                                
                                            }];
    } else {
        //        NSLog(@"No device motion on device.");
        [self setMotionManager:nil];
    }
}

//这里是重力感应的处理方法
- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion{
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    if (fabs(y) >= fabs(x))
    {
        if (y >= 0){
            // UIDeviceOrientationPortraitUpsideDown;
            deviceOrientation = UIDeviceOrientationPortraitUpsideDown;
        }
        else{
            // UIDeviceOrientationPortrait;
            deviceOrientation = UIDeviceOrientationPortrait;
        }
    }
    else
    {
        if(canRotate == NO)
        {
            //已关闭横竖屏切换
        }
        if (x >= 0){
            // UIDeviceOrientationLandscapeRight;
            deviceOrientation = UIDeviceOrientationLandscapeRight;
        }
        else{
            // UIDeviceOrientationLandscapeLeft;
            deviceOrientation = UIDeviceOrientationLandscapeLeft;
        }
    }
}

//关掉陀螺仪的监听及设备横竖屏切换的通知
- (void)stopDeviceMotionUpdate
{
    [_motionManager stopDeviceMotionUpdates];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (BOOL)canBeRotated
{
    return canRotate;
}


- (UIDeviceOrientation)deviceOrientation
{
    return deviceOrientation;
}
@end
