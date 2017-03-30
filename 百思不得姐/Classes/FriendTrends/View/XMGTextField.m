//
//  XMGTextField.m
//  百思不得姐
//
//  Created by hwawo on 16/7/6.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGTextField.h"
static NSString * const XMGPlacerholderColorKeyPath = @"_placeholderLabel.textColor";
@implementation XMGTextField
//改变占位符颜色有KVC drawPlaceholderInRect
//-(void)drawPlaceholderInRect:(CGRect)rect{
//
//    [self.placeholder drawInRect:CGRectMake(0, 10, rect.size.width, 25) withAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:self.font}];
//}

- (void)awakeFromNib{
    //光标颜色
    self.tintColor = self.textColor;
    
    [self resignFirstResponder];
}

- (BOOL)becomeFirstResponder{

    [self setValue:self.textColor forKeyPath:XMGPlacerholderColorKeyPath];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder{

    [self setValue:[UIColor grayColor] forKeyPath:XMGPlacerholderColorKeyPath];
    return [super resignFirstResponder];
}
@end
