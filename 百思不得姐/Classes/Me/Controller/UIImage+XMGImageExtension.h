//
//  UIImage+XMGImageExtension.h
//  Cloud Player
//
//  Created by XMG on 17/4/29.
//  Copyright © 2017年 ichano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XMGImageExtension)
// 添加水印图片
- (void )addWaterPictureToEditVideoUrl:(NSURL *)url outToPath:(NSString *)savePath waterPicture:(UIImageView *)imageView imageViewCenter:(CGPoint)center finish:(void (^)(BOOL isFinish))finish;

// 添加水印图片(轻量级)
- (void)addWaterPictureByPath:(NSURL *)inUrl andSavePath:(NSString*)savePath waterPictureName:(NSString *)pictureName waterPictureFrame:(CGRect)pictureFrame finish:(void (^)(BOOL isFinish))finish;

//添加水印文字
- (void )addWaterCharacterToEditVideoUrl:(NSURL *)url outToPath:(NSString *)savePath waterCharacter:(NSString *)content characterFont:(NSString *)fontStr characterFontSize:(int)fontSize characterAlignmentMode:(NSString *)alignmentMode characterColor:(UIColor *)color  characterHeight:(float)height finish:(void (^)(BOOL isFinish))finish;

//添加背景音乐
- (void )addBGMusicToEditVideoUrl:(NSURL *)url BGMusicUrl:(NSURL *)musicUrl outToPath:(NSString *)savePath finish:(void (^)(BOOL isFinish))finish;

//合并视频
- (void)mergeAndExportVideos:(NSArray*)videosPathArray withOutPath:(NSString*)outpath finish:(void (^)(BOOL isFinish))finish;
@end
