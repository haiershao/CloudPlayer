//
//  UIImage+XMGImageExtension.m
//  Cloud Player
//
//  Created by XMG on 17/4/29.
//  Copyright © 2017年 ichano. All rights reserved.
//

#import "UIImage+XMGImageExtension.h"
#import "GPUImage.h"
@implementation UIImage (XMGImageExtension)
GPUImageMovie *movieFile;
GPUImageBrightnessFilter *filter;
GPUImageAlphaBlendFilter *landBlendFilter;
GPUImageUIElement *landInput;
GPUImageTransformFilter *landTransformFilter;
GPUImageMovieWriter *movieWriter;
- (void )addWaterPictureToEditVideoUrl:(NSURL *)url outToPath:(NSString *)savePath waterPicture:(UIImageView *)imageView imageViewCenter:(CGPoint)center finish:(void (^)(BOOL isFinish))finish{

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
    
    NSString *pathToMovie = savePath;
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
    }];
}

- (void)addWaterPictureByPath:(NSURL *)inUrl andSavePath:(NSString*)savePath waterPictureName:(NSString *)pictureName waterPictureFrame:(CGRect)pictureFrame finish:(void (^)(BOOL isFinish))finish{
    
    NSLog(@"addWaterPictureByPath \nv_strVideoPath = %@ \nv_strSavePath = %@\n ",inUrl,savePath);
    AVAsset *avAsset = [AVAsset assetWithURL:inUrl];
    CGSize movieSize = avAsset.naturalSize;
    CMTime assetTime = [avAsset duration];
    Float64 duration = CMTimeGetSeconds(assetTime);
    NSLog(@"addWaterPictureByPath 视频时长 %f\n",duration);
    
    AVMutableComposition *avMutableComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *avMutableCompositionTrack = [avMutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *audioMutableCompositionTrack = [avMutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *avAssetTrack = nil;
    if ([avAsset tracksWithMediaType:AVMediaTypeVideo].count!=0) {
        if ([[avAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]) {
            avAssetTrack = [[avAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        }
    }
    
    AVAssetTrack *audioAssetTrack = nil;
    if ([avAsset tracksWithMediaType:AVMediaTypeAudio].count!=0) {
        if ([[avAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]) {
            audioAssetTrack = [[avAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
        }
    }
    
    [audioMutableCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, avAsset.duration) ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil];
    
    NSError *error = nil;
    // 这块是裁剪,rangtime .前面的是开始时间,后面是裁剪多长
    [avMutableCompositionTrack insertTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(0.0f, 30), CMTimeMakeWithSeconds(duration, 30))
                                       ofTrack:avAssetTrack
                                        atTime:kCMTimeZero
                                         error:&error];
    
    AVMutableVideoComposition *avMutableVideoComposition = [AVMutableVideoComposition videoComposition];
    
    avMutableVideoComposition.renderSize = CGSizeMake(movieSize.width, movieSize.height);
    avMutableVideoComposition.frameDuration = CMTimeMake(1, 30);
    
    //     CALayer *animatedTitleLayer = [self buildAnimatedTitleLayerForSize:CGSizeMake(320, 88)];
    
    UIImage *waterMarkImage = [UIImage imageNamed:pictureName];
    CALayer *waterMarkLayer = [CALayer layer];
//    waterMarkLayer.frame = CGRectMake(10, 0.9*movieSize.height, 100, 40);
    waterMarkLayer.frame = pictureFrame;
    waterMarkLayer.contents = (id)waterMarkImage.CGImage;
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, movieSize.width, movieSize.height);
    videoLayer.frame = CGRectMake(0, 0, movieSize.width, movieSize.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:waterMarkLayer];
    avMutableVideoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    AVMutableVideoCompositionInstruction *avMutableVideoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    
    [avMutableVideoCompositionInstruction setTimeRange:CMTimeRangeMake(kCMTimeZero, [avMutableComposition duration])];
    
    AVMutableVideoCompositionLayerInstruction *avMutableVideoCompositionLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:avAssetTrack];
    [avMutableVideoCompositionLayerInstruction setTransform:avAssetTrack.preferredTransform atTime:kCMTimeZero];
    
    avMutableVideoCompositionInstruction.layerInstructions = [NSArray arrayWithObject:avMutableVideoCompositionLayerInstruction];
    
    
    avMutableVideoComposition.instructions = [NSArray arrayWithObject:avMutableVideoCompositionInstruction];
    
    AVAssetExportSession *avAssetExportSession = [[AVAssetExportSession alloc] initWithAsset:avMutableComposition presetName:AVAssetExportPreset640x480];
    [avAssetExportSession setVideoComposition:avMutableVideoComposition];
    [avAssetExportSession setOutputURL:[NSURL fileURLWithPath:savePath]];
    avAssetExportSession.outputFileType = AVFileTypeQuickTimeMovie;
    //     [avAssetExportSession setOutputFileType:AVFileTypeQuickTimeMovie];//这句话要是要的话，会出错的。。。
    [avAssetExportSession setShouldOptimizeForNetworkUse:YES];
    [avAssetExportSession exportAsynchronouslyWithCompletionHandler:^(void){
        //其实只要进入这个方法合成就已经成功了。。。。不需要再用下面的switch 了。。。这个问题我找了三天。。。终于发现了。。。。。。。把下面的switch语句删除就行了。，直接把成功以后的代码写到本方法就ok了。。。。。。。。。。。。。。。。。。。
        finish(YES);
    }];
    if (avAssetExportSession.status != AVAssetExportSessionStatusCompleted){
        NSLog(@"addWaterPictureByPath Retry export");
    }
}

AVAsset *videoAsset;
- (void )addWaterCharacterToEditVideoUrl:(NSURL *)url outToPath:(NSString *)savePath waterCharacter:(NSString *)content characterFont:(NSString *)fontStr characterFontSize:(int)fontSize characterAlignmentMode:(NSString *)alignmentMode characterColor:(UIColor *)color  characterHeight:(float)height finish:(void (^)(BOOL isFinish))finish{
    
    if (!url) {
        return;
    }
    NSURL *sampleURL = url;
    
    //1 创建AVAsset实例 AVAsset包含了video的所有信息
    videoAsset = [AVAsset assetWithURL:sampleURL];
    //2 创建AVMutableComposition实例. apple developer 里边的解释
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    //3 视频通道  工程文件中的轨道，有音频轨、视频轨等，里面可以插入各种对应的素材
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    //把视频轨道数据加入到可变轨道中 这部分可以做视频裁剪TimeRange
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
    
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
    
    //3.1 AVMutableVideoCompositionInstruction 视频轨道中的一个视频，可以缩放、旋转等
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    
    // 3.2 AVMutableVideoCompositionLayerInstruction 一个视频轨道，包含了这个轨道上的所有视频素材
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
//    AVMutableVideoCompositionLayerInstruction *audiolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:audioTrack];
    
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
//    AVAssetTrack *audioAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];

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
//    [audiolayerInstruction setTransform:audioAssetTrack.preferredTransform atTime:kCMTimeZero];
//    [audiolayerInstruction setOpacity:0.0 atTime:videoAsset.duration];
    
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction, nil];
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
    
    [subtitle1Text setFont:(__bridge CFTypeRef _Nullable)(fontStr)];
    [subtitle1Text setFontSize:fontSize];
    [subtitle1Text setFrame:CGRectMake(0, 0, naturalSize.width, 100)];
    [subtitle1Text setString:content];
    [subtitle1Text setAlignmentMode:kCAAlignmentCenter];
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
//                        [self exportDidFinish:exporter];
            finish(YES);
        });
    }];
}

- (void )addBGMusicToEditVideoUrl:(NSURL *)url BGMusicUrl:(NSURL *)musicUrl outToPath:(NSString *)savePath finish:(void (^)(BOOL isFinish))finish{

    //视频 声音 来源
    NSURL * videoInputUrl = url;
    NSURL * audioInputUrl = musicUrl;
    
    //时间起点
    CMTime nextClistartTime = kCMTimeZero;
    //创建可变的音视频组合
    AVMutableComposition * comosition = [AVMutableComposition composition];
    
    //视频采集
    AVURLAsset * videoAsset = [[AVURLAsset alloc] initWithURL:videoInputUrl options:nil];
    //视频时间范围
    CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    // 视频通道 枚举 kCMPersistentTrackID_Invalid = 0
    AVMutableCompositionTrack * videoTrack = [comosition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    //视频采集通道
    AVAssetTrack * videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    //把采集轨道数据加入到可变轨道中
    [videoTrack insertTimeRange:videoTimeRange ofTrack:videoAssetTrack atTime:nextClistartTime error:nil];
    
    
    
    //声音采集
    AVURLAsset * audioAsset = [[AVURLAsset alloc] initWithURL:audioInputUrl options:nil];
    //因为视频较短 所以直接用了视频的长度 如果想要自动化需要自己写判断
    CMTimeRange audioTimeRange = videoTimeRange;
    //音频通道
    AVMutableCompositionTrack * audioTrack = [comosition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //音频采集通道
    AVAssetTrack * audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    //加入合成轨道中
    [audioTrack insertTimeRange:audioTimeRange ofTrack:audioAssetTrack atTime:nextClistartTime error:nil];
    
    
    
#warning test
    // 3.1 - Create AVMutableVideoCompositionInstruction
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    
    // 3.2 - Create an AVMutableVideoCompositionLayerInstruction for the video track and fix the orientation.
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
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
#warning test end 如果没有这段代码，合成后的视频会旋转90度
    
    //创建输出
    NSString *outPutPath = savePath;
    NSURL *outPutUrl = [NSURL fileURLWithPath:outPutPath];
 
    AVAssetExportSession * assetExport = [[AVAssetExportSession alloc] initWithAsset:comosition presetName:AVAssetExportPresetMediumQuality];
    assetExport.outputURL = outPutUrl;//输出路径
    assetExport.outputFileType = AVFileTypeQuickTimeMovie;//输出类型
    assetExport.shouldOptimizeForNetworkUse = YES;//是否优化   不太明白
    assetExport.videoComposition = mainCompositionInst;
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            finish(YES);
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
