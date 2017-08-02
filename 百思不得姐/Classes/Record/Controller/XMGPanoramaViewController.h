//
//  XMGPanoramaViewController.h
//  Cloud Player
//
//  Created by jiyi on 2017/8/2.
//  Copyright © 2017年 ichano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMGPanoramaViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* spinner;
@property (nonatomic, weak) IBOutlet UIImageView* imageView;
@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;

+ (instancetype)panoramaViewController;
@end
