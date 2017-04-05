//
//  XMGPictureCollectionCell.h
//  Cloud Player
//
//  Created by hwawo on 17/3/31.
//  Copyright © 2017年 ichano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMGPictureCollectionCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UILabel *gifLable;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) id asset;

- (UIView *)snapshotView;
@end
