//
//  CZDownloadingCell.h
//  Cloud Player
//
//  Created by hwawo on 17/3/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZFDownload/ZFDownloadManager.h>

typedef void(^ZFBtnClickBlock)(void);

@interface CZDownloadingCell : UITableViewCell
@property (weak, nonatomic  ) IBOutlet UILabel          *fileNameLabel;
@property (weak, nonatomic  ) IBOutlet UIProgressView   *progress;
@property (weak, nonatomic  ) IBOutlet UILabel          *progressLabel;
@property (weak, nonatomic  ) IBOutlet UILabel          *speedLabel;
@property (weak, nonatomic  ) IBOutlet UIButton         *downloadBtn;


/** 下载按钮点击回调block */
@property (nonatomic, copy  ) ZFBtnClickBlock  btnClickBlock;
/** 下载信息模型 */
@property (nonatomic, strong) ZFFileModel      *fileInfo;
/** 该文件发起的请求 */
@property (nonatomic,retain ) ZFHttpRequest    *request;
@end
