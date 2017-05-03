//
//  XMGTopicVideoView.m
//  百思不得姐
//
//  Created by hwawo on 16/7/14.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGTopicVideoView.h"
#import <UIImageView+WebCache.h>
#import "XMGTopic.h"
#import "XMGShowPictureViewController.h"
@interface XMGTopicVideoView()

@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videotimeLabel;
@end
@implementation XMGTopicVideoView

+ (instancetype)topicVideoView{

    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{
    
    self.autoresizingMask = UIViewAutoresizingNone;
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}

- (void)showPicture{
    
    XMGShowPictureViewController *showPicture = [XMGShowPictureViewController showPictureViewController];
    showPicture.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
}

- (void)setTopic:(XMGTopic *)topic{
    _topic = topic;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    
    self.playcountLabel.text = [NSString stringWithFormat:@"%zd次播放",topic.playcount];
    
    NSInteger minute = topic.videotime/60;
    NSInteger second = topic.videotime%60;
    self.videotimeLabel.text = [NSString stringWithFormat:@"%.02zd:%.02zd",minute,second];
    
}

@end
