//
//  XMGPreviewView.m
//  Cloud Player
//
//  Created by XMG on 2017/8/2.
//  Copyright © 2017年 ichano. All rights reserved.
//

#import "XMGPreviewView.h"

@implementation XMGPreviewView

+ (Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session
{
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    return previewLayer.session;
}

- (void)setSession:(AVCaptureSession *)session
{
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    previewLayer.session = session;
}

@end
