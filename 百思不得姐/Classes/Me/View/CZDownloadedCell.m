//
//  CZDownloadedCell.m
//  Cloud Player
//
//  Created by hwawo on 17/3/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CZDownloadedCell.h"

@implementation CZDownloadedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setFileInfo:(ZFFileModel *)fileInfo {
    _fileInfo = fileInfo;
    NSString *totalSize = [ZFCommonHelper getFileSizeString:fileInfo.fileSize];
    self.fileNameLabel.text = fileInfo.fileName;
    self.sizeLabel.text = totalSize;
}
@end
