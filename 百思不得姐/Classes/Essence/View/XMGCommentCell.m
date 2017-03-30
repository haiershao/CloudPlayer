//
//  XMGCommentCell.m
//  百思不得姐
//
//  Created by hwawo on 16/7/15.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGCommentCell.h"
#import <UIImageView+WebCache.h>
#import "XMGComment.h"
#import "XMGUser.h"
@interface XMGCommentCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@end
@implementation XMGCommentCell
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    

}

- (void)setComment:(XMGComment *)comment{

    _comment = comment;
    
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:comment.user.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    self.sexView.image = [comment.user.sex isEqualToString:XMGUserSexMale]? [UIImage imageNamed:@"Profile_manIcon"]: [UIImage imageNamed:@"Profile_womanIcon"];
    
    self.contentLabel.text = comment.content;
    
    self.usernameLabel.text = comment.user.username;
    
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd", comment.like_count];
    
    if (comment.voiceuri.length) {
        self.voiceButton.hidden = NO;
        [self.voiceButton setTitle:[NSString stringWithFormat:@"%zd''",comment.voicetime] forState:UIControlStateNormal];
    }else{
    
        self.voiceButton.hidden = YES;
    }
}

- (void)setFrame:(CGRect)frame{

    frame.origin.x = XMGTopicCellMargin;
    frame.size.width -= 2*XMGTopicCellMargin;
    
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
