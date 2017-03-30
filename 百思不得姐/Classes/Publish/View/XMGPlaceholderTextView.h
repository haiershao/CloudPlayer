//
//  XMGPlaceholderTextView.h
//  百思不得姐
//
//  Created by hwawo on 16/7/21.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMGPlaceholderTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
@end
