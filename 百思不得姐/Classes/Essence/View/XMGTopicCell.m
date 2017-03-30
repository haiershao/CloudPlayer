//
//  XMGTopicCell.m
//  百思不得姐
//
//  Created by hwawo on 16/7/7.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGTopicCell.h"
#import "XMGTopic.h"
#import <UIImageView+WebCache.h>
#import "XMGTopicPictureView.h"
#import "XMGTopicVoiceView.h"
#import "XMGTopicVideoView.h"
#import "XMGComment.h"
#import "XMGUser.h"

#import "ZFPlayer.h"
#import <Masonry/Masonry.h>
#import <AVFoundation/AVFoundation.h>
@interface XMGTopicCell ()
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
/** 顶 */
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
/** 踩 */
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
/** 分享 */
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
/** 评论 */
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
/** 新浪加V */
@property (weak, nonatomic) IBOutlet UIImageView *sinaVView;
/** 帖子的文字内容 */
@property (weak, nonatomic) IBOutlet UILabel *text_label;

/** 最热评论的内容 */
@property (weak, nonatomic) IBOutlet UILabel *topCmtContentLabel;
/** 最热评论的整体 */
@property (weak, nonatomic) IBOutlet UIView *topCmtView;

@property (weak, nonatomic) XMGTopicPictureView *pictureView;
@property (weak, nonatomic) XMGTopicVoiceView *voiceView;

@end
@implementation XMGTopicCell

+ (instancetype)topicCell{

    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

- (XMGTopicPictureView *)pictureView{

    if (!_pictureView) {
        XMGTopicPictureView *pictureView = [XMGTopicPictureView topicPictureView];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

- (XMGTopicVoiceView *)voiceView{

    if (!_voiceView) {
        XMGTopicVoiceView *voiceView = [XMGTopicVoiceView topicVoiceView];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}

- (XMGTopicVideoView *)videoView{
    
    if (!_videoView) {
        XMGTopicVideoView *videoView = [XMGTopicVideoView topicVideoView];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
    XMGLog(@"%@",_topic.videouri);
}

- (void)setTopic:(XMGTopic *)topic{

    _topic = topic;
    self.sinaVView.hidden = NO;
    
    [self.profileImageView setHeader:topic.profile_image];
    self.nameLabel.text = topic.name;
    self.createTimeLabel.text = topic.create_time;
    
    [self setUpButtonTitle:self.dingButton count:topic.ding placeholder:@"顶"];
    [self setUpButtonTitle:self.caiButton count:topic.cai placeholder:@"踩"];
    [self setUpButtonTitle:self.shareButton count:topic.repost placeholder:@"分享"];
    [self setUpButtonTitle:self.commentButton count:topic.comment placeholder:@"评论"];
    
    self.text_label.text = topic.text;
    
    if (topic.type == XMGTopicTypePicture) {

        self.pictureView.hidden = NO;
        self.pictureView.topic = topic;        
        self.pictureView.frame = topic.pictureF;
        
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
    }else if (topic.type == XMGTopicTypeVoice){
        
        self.voiceView.hidden = NO;
        self.voiceView.topic = topic;
        self.voiceView.frame = topic.voiceF;
        
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
    }else if (topic.type == XMGTopicTypeVideo){
        
        self.videoView.hidden = NO;
        self.videoView.topic = topic;
        self.videoView.frame = topic.videoF;
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
    }else{
    
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    }
    
    
    //处理最热评论
//    XMGComment *com = [topic.top_cmt firstObject];
    if (topic.top_cmt) {
        self.topCmtView.hidden = NO;
        self.topCmtContentLabel.text = [NSString stringWithFormat:@"%@ : %@",topic.top_cmt.user.username, topic.top_cmt.content];
    }else{
    
        self.topCmtView.hidden = YES;
    }
    
    [self setUpPlayBtn];
}

- (void)setUpPlayBtn{

    // 代码添加playerBtn到imageView上
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoView.imageView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.videoView.imageView);
        make.width.height.mas_equalTo(50);
    }];
}

- (void)setUpButtonTitle:(UIButton *)button count:(NSInteger )count placeholder:(NSString *)placeholder{

    if (count>10000) {
        placeholder = [NSString stringWithFormat:@"%.1ld万",count/10000];
    }else if (count>0){
    
        placeholder = [NSString stringWithFormat:@"%zd", count];
    }
    
    [button setTitle:placeholder forState:UIControlStateNormal];
}

- (void)setFrame:(CGRect)frame{

    static CGFloat margin = 10;
    
    frame.origin.x = margin;
    frame.size.width -= 2*margin;
    frame.size.height -= margin;
//    frame.size.height = self.topic.cellHeight - XMGTopicCellMargin;
    frame.origin.y += margin;
    [super setFrame:frame];
}

- (IBAction)more {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"收藏", @"举报", nil];
    [sheet showInView:self.window];
}

- (void)play:(UIButton *)sender {
    if (self.playBlock) {
        self.playBlock(sender);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
