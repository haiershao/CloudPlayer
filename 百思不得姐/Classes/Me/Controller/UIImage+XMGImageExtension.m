//
//  UIImage+XMGImageExtension.m
//  Cloud Player
//
//  Created by XMG on 17/4/29.
//  Copyright © 2017年 ichano. All rights reserved.
//

#import "UIImage+XMGImageExtension.h"
#import <GPUImage.h>
@implementation UIImage (XMGImageExtension)
GPUImageMovie *movieFile;
GPUImageBrightnessFilter *filter;
GPUImageAlphaBlendFilter *landBlendFilter;
GPUImageUIElement *landInput;
GPUImageTransformFilter *landTransformFilter;
GPUImageMovieWriter *movieWriter;
- (void )addWaterPictureToEditVideoUrl:(NSURL *)url outToPath:(NSMutableString *)savePath waterPicture:(UIImageView *)imageView imageViewCenter:(CGPoint)center finish:(void (^)(BOOL isFinish))finish{

    if(!url) {
        NSLog(@"url为空");
        return;
    }
    NSURL *sampleURL = url;
    
    //    NSString *videoURL = [[NSBundle mainBundle] pathForResource:@"faceDemo" ofType:@"m4v"];
    //    NSURL *sampleURL = [NSURL fileURLWithPath:videoURL];
    
    movieFile = [[GPUImageMovie alloc] initWithURL:sampleURL];
    movieFile.runBenchmark = YES;
    movieFile.playAtActualSpeed = NO;
    
    filter = [[GPUImageBrightnessFilter alloc] init];
    filter.brightness = 0.0f;
    
    //获取视频的大小(画面大小)，来确定水印的位置和大小;
    AVAsset *fileas = [AVAsset assetWithURL:sampleURL];
    CGSize movieSize = fileas.naturalSize;
    

    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, movieSize.width, movieSize.height)];
    imageView.center = center;
    [vi addSubview:imageView];
    
    landBlendFilter = [[GPUImageAlphaBlendFilter alloc] init];
    //mix即为叠加后的透明度,这里就直接写1.0了
    landBlendFilter.mix = 0.5f;
    landInput = [[GPUImageUIElement alloc] initWithView:vi];
    landTransformFilter = [[GPUImageTransformFilter alloc] init];
    
    __unsafe_unretained GPUImageUIElement *weakLandInput = landInput;
    
    [filter setFrameProcessingCompletionBlock:^(GPUImageOutput * filter, CMTime time){
        NSLog(@"setFrameProcessingCompletionBlock time.value:%lld time.timescale:%d  %lld",time.value,time.timescale,time.value/time.timescale);
        
        [weakLandInput update];
    }];
    
    NSMutableString *pathToMovie = savePath;
    NSString *urlStr = [NSString stringWithFormat:@"%@",url];
    NSString *appendStr = [urlStr lastPathComponent];
    [pathToMovie appendString:appendStr];
    unlink([pathToMovie UTF8String]); //如果视频存在，删掉！
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(movieSize.width, movieSize.height)];
    movieWriter.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    if (movieFile) {
        [movieFile removeAllTargets];
    }
    [movieFile addTarget:filter];
    
    if (filter) {
        [filter removeAllTargets];
    }
    [filter addTarget:landBlendFilter];
    
    if (landInput) {
        [landInput removeAllTargets];
    }
    [landInput addTarget:landBlendFilter];
    
    if (landBlendFilter) {
        [landBlendFilter removeAllTargets];
    }
    
    
    [landInput addTarget:landTransformFilter];
    [landTransformFilter addTarget:landBlendFilter];
    NSLog(@" %@",landBlendFilter);
    [landBlendFilter addTarget:movieWriter];
    
//    __weak CZDownloadViewController *weakSelf = self;
    movieWriter.shouldPassthroughAudio = YES;
    movieFile.audioEncodingTarget = movieWriter;
    [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];

    [movieWriter startRecording];
    [movieFile startProcessing];
    
    __weak GPUImageMovieWriter *weakMovieWriter = movieWriter;
    [movieWriter setCompletionBlock:^{
        [filter removeTarget:weakMovieWriter];
        [weakMovieWriter finishRecording];
        
        BOOL isFinish = YES;
        finish(isFinish);
//        [weakSelf createAlbumPathName:@"视频剪辑大湿" patnMovie:pathToMovie];
    }];
}

AVAsset *videoAsset;
- (void )addWaterCharacterToEditVideoUrl:(NSURL *)url outToPath:(NSString *)savePath waterCharacter:(NSString *)content characterFont:(NSString *)fontStr characterFontSize:(int)fontSize characterAlignmentMode:(NSString *)alignmentMode characterColor:(UIColor *)color  characterHeight:(float)height finish:(void (^)(BOOL isFinish))finish{

    if (!url) {
        return;
    }
    NSURL *sampleURL = url;
    
    //    NSString *videoURL = [[NSBundle mainBundle] pathForResource:@"faceDemo" ofType:@"m4v"];
    //    NSURL *sampleURL = [NSURL fileURLWithPath:videoURL];
    //1 创建AVAsset实例 AVAsset包含了video的所有信息
    videoAsset = [AVAsset assetWithURL:sampleURL];
    //2 创建AVMutableComposition实例. apple developer 里边的解释
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    //3 视频通道  工程文件中的轨道，有音频轨、视频轨等，里面可以插入各种对应的素材
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    //把视频轨道数据加入到可变轨道中 这部分可以做视频裁剪TimeRange
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
    
    //3.1 AVMutableVideoCompositionInstruction 视频轨道中的一个视频，可以缩放、旋转等
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    
    // 3.2 AVMutableVideoCompositionLayerInstruction 一个视频轨道，包含了这个轨道上的所有视频素材
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ = UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
        videoAssetOrientation_ =  UIImageOrientationUp;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
        videoAssetOrientation_ = UIImageOrientationDown;
    }
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:videoAsset.duration];
    
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    //AVMutableVideoComposition：管理所有视频轨道，可以决定最终视频的尺寸，裁剪需要在这里进行
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    
    // 1 - Set up the text layer
    CATextLayer *subtitle1Text = [[CATextLayer alloc] init];
    
    [subtitle1Text setFont:@"Helvetica-Bold"];
    [subtitle1Text setFontSize:fontSize];
    [subtitle1Text setFrame:CGRectMake(0, 0, naturalSize.width, height)];
    [subtitle1Text setString:content];
    [subtitle1Text setAlignmentMode:alignmentMode];
    [subtitle1Text setForegroundColor:[color CGColor]];
    
    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:subtitle1Text];
    overlayLayer.frame = CGRectMake(0, 0, naturalSize.width, naturalSize.height);
    [overlayLayer setMasksToBounds:YES];
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, naturalSize.width, naturalSize.height);
    videoLayer.frame = CGRectMake(0, 0, naturalSize.width, naturalSize.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    
    mainCompositionInst.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    NSString *myPathDocs = savePath;
    
    NSURL *videoUrl = [NSURL fileURLWithPath:myPathDocs];
    
    // 5 - 视频文件输出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL = videoUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //这里是输出视频之后的操作，做你想做的
            BOOL isFinish = YES;
            finish(isFinish);
        });
    }];
}

- (void)mergeAndExportVideos:(NSArray*)videosPathArray withOutPath:(NSString*)outpath finish:(void (^)(BOOL isFinish))finish{
    if (videosPathArray.count == 0) {
        return;
    }
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    CMTime totalDuration = kCMTimeZero;
    for (int i = 0; i < videosPathArray.count; i++) {
        AVURLAsset *asset = [AVURLAsset assetWithURL:videosPathArray[i]];
        NSError *erroraudio = nil;
        //获取AVAsset中的音频 或者视频
        AVAssetTrack *assetAudioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
        //向通道内加入音频或者视频
        BOOL ba = [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                      ofTrack:assetAudioTrack
                                       atTime:totalDuration
                                        error:&erroraudio];
        
        NSLog(@"erroraudio:%@%d",erroraudio,ba);
        NSError *errorVideo = nil;
        AVAssetTrack *assetVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo]firstObject];
        BOOL bl = [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                      ofTrack:assetVideoTrack
                                       atTime:totalDuration
                                        error:&errorVideo];
        
        NSLog(@"errorVideo:%@%d",errorVideo,bl);
        totalDuration = CMTimeAdd(totalDuration, asset.duration);
    }
    NSLog(@"%@",NSHomeDirectory());
    
    NSURL *mergeFileURL = [NSURL fileURLWithPath:outpath];
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPreset640x480];
    exporter.outputURL = mergeFileURL;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        NSLog(@"exporter%@",exporter.error);
        BOOL isFinish = YES;
        finish(isFinish);
    }];
}
@end
