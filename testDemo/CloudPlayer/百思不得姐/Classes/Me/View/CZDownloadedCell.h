//
//  CZDownloadedCell.h
//  Cloud Player
//
//  Created by hwawo on 17/3/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZFDownload/ZFDownloadManager.h>
@interface CZDownloadedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic  ) IBOutlet UIImageView *fileIconImage;
/** 下载信息模型 */
@property (nonatomic, strong) ZFFileModel *fileInfo;
@end
