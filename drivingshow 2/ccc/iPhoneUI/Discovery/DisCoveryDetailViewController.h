//
//  DisCoveryDetailViewController.h
//  HuaWo
//
//  Created by circlely on 2/29/16.
//  Copyright © 2016 circlely. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisCoveryDetailViewController : UIViewController
@property (strong, nonatomic) NSURL *requestUrl;

- (void)share:(NSString *)urlStr;
@end
