//
//  XMGTopic.m
//  百思不得姐
//
//  Created by hwawo on 16/7/7.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGTopic.h"
#import "XMGComment.h"
#import "XMGUser.h"
#import <MJExtension.h>
@implementation XMGTopic{
    //加了readonly只生成get方法，property生成get，set方法和下划线的成员变量
    CGFloat _cellHeight;
    
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{

    return @{
             @"small_image" : @"image0",
             @"large_image" : @"image1",
             @"middle_image" : @"image2",
             @"ID" : @"id",
             @"top_cmt" : @"top_cmt[0]"
             };
}

//+ (NSDictionary *)mj_objectClassInArray{
//
//    return @{@"top_cmt" : @"XMGComment"};
//}

- (NSString *)create_time{

    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *create = [fmt dateFromString:_create_time];
    
    if (create.isThisYear) {
        if (create.isToday) {
            NSDateComponents *cmps = [[NSDate date] deltaFrom:create];
            if (cmps.hour > 1) {
                
                return [NSString stringWithFormat:@"%zd小时前",cmps.hour];
            }else if (cmps.minute > 1){
            
                return [NSString stringWithFormat:@"%zd分钟前",cmps.minute];
            }else {
            
                return @"刚刚";
            }
        }else if (create.isYesterday){
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:create];
        }else{
        
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:create];
        }
    }else{
    
        return _create_time;
    }
}

- (CGFloat)cellHeight{
    if (!_cellHeight) {
       
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 4*XMGTopicCellMargin, MAXFLOAT);
        //计算文本的高度
        CGFloat textH = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
        _cellHeight = XMGTopicCellTextY + textH + XMGTopicCellMargin;
        
        if (self.type == XMGTopicTypePicture) {
            
            CGFloat pictureW = maxSize.width;
            CGFloat pictureH = pictureW * self.height/self.width;
            
            if (pictureH>=XMGTopicCellPictureMaxH) {
                pictureH = XMGTopicCellPictureBreakH;
                self.bigPicture = YES;
            }
            
            CGFloat pictureX = XMGTopicCellMargin;
            CGFloat pictureY = XMGTopicCellTextY + textH + XMGTopicCellMargin;
            _pictureF = CGRectMake(pictureX, pictureY, pictureW, pictureH);
            _cellHeight += pictureH + XMGTopicCellMargin;
            
        }else if (self.type == XMGTopicTypeVoice){
        
            CGFloat voiceX = XMGTopicCellMargin;
            CGFloat voiceY = XMGTopicCellTextY + textH + XMGTopicCellMargin;
            CGFloat voiceW = maxSize.width;
            CGFloat voiceH = voiceW*self.height/self.width;
            _voiceF = CGRectMake(voiceX, voiceY, voiceW, voiceH);
            _cellHeight += voiceH + XMGTopicCellMargin;
        }else if (self.type == XMGTopicTypeVideo){
        
            CGFloat videoX = XMGTopicCellMargin;
            CGFloat videoY = XMGTopicCellTextY + textH + XMGTopicCellMargin;
            CGFloat videoW = maxSize.width;
            CGFloat videoH = videoW*self.height/self.width;
            _videoF = CGRectMake(videoX, videoY, videoW, videoH);
            _cellHeight += videoH + XMGTopicCellMargin;
        }
        
//        XMGComment *top_cmt = [self.top_cmt firstObject];
        if (self.top_cmt) {
            NSString *content = [NSString stringWithFormat:@"%@ : %@",self.top_cmt.user.username, self.top_cmt.content];
            CGFloat contentH = [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont  systemFontOfSize:13]} context:nil].size.height;
            _cellHeight += XMGTopicCellTopCmtTitleH + contentH + XMGTopicCellMargin;
            
            NSLog(@"contentH---%f",contentH);
        }
        _cellHeight += XMGTopicCellBottomBarH + XMGTopicCellMargin;
    }
    
    return _cellHeight;
}
@end
