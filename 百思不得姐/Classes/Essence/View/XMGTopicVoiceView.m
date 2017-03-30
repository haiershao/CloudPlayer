//
//  XMGTopicVoiceView.m
//  百思不得姐
//
//  Created by hwawo on 16/7/12.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGTopicVoiceView.h"
#import "XMGTopic.h"
#import <UIImageView+WebCache.h>
#import "XMGShowPictureViewController.h"
@interface XMGTopicVoiceView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *voicelengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@end
@implementation XMGTopicVoiceView

+ (instancetype)topicVoiceView{

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
    
    self.voicelengthLabel.text = [NSString stringWithFormat:@"%zd",topic.voicetime];
    
    NSInteger minute = topic.voicetime/60;
    NSInteger second = topic.voicetime%60;
    self.playcountLabel.text = [NSString stringWithFormat:@"%02zd:%02zd播放",minute, second];
}
@end
