//
//  UIImageView+XMGExtension.m
//  百思不得姐
//
//  Created by hwawo on 16/7/20.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "UIImageView+XMGExtension.h"
#import <UIImageView+WebCache.h>
@implementation UIImageView (XMGExtension)
- (void)setHeader:(NSString *)url{

    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image ? [image circleImage]:placeholder;
    }];
}
@end
