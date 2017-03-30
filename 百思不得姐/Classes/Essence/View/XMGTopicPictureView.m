//
//  XMGTopicPictureView.m
//  百思不得姐
//
//  Created by hwawo on 16/7/8.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGTopicPictureView.h"
#import "XMGTopic.h"
#import <UIImageView+WebCache.h>
#import "XMGProgressView.h"
#import "XMGShowPictureViewController.h"
@interface XMGTopicPictureView()
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** gif标识 */
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
/** 查看大图按钮 */
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;
/** 进度条控件 */
@property (weak, nonatomic) IBOutlet XMGProgressView *progressView;
@end
@implementation XMGTopicPictureView
+ (instancetype)topicPictureView{

    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{

    self.autoresizingMask = UIViewAutoresizingNone;
    
    // 给图片添加监听器
    self.imageView.userInteractionEnabled = YES;
    ;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}

- (IBAction)showPicture{

    XMGShowPictureViewController *showVc = [XMGShowPictureViewController showPictureViewController];
    showVc.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showVc animated:YES completion:nil];
}

- (void)setTopic:(XMGTopic *)topic{

    _topic = topic;

    [self.progressView setProgress:topic.pictureProgress animated:NO];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        topic.pictureProgress = 1.0*receivedSize/expectedSize;
        [self.progressView setProgress:topic.pictureProgress animated:NO];
        
        if ([self.progressView.progressLabel.text isEqualToString:@"100%"]) {
            self.progressView.hidden = YES;
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.progressView.hidden = YES;
        if (!topic.isBigPicture) return ;
        UIGraphicsBeginImageContextWithOptions(topic.pictureF.size, YES, 0.0);
        
        CGFloat width = topic.pictureF.size.width;
        CGFloat height = width*image.size.height/image.size.width;
        [image drawInRect:CGRectMake(0, 0, width, height)];
        
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }];
    
    NSString *extension = topic.large_image.pathExtension;
    self.gifView.hidden = ![extension.lowercaseString isEqualToString:@"gif"];
    
    if (topic.isBigPicture) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.seeBigButton.hidden = NO;
    }else{
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.seeBigButton.hidden = YES;
    }
}
@end
