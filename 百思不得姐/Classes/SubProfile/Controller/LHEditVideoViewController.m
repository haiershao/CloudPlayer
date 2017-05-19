//
//  LHEditVideoViewController.m
//  Player
//
//  Created by hwawo on 17/3/21.
//  Copyright © 2017年 任子丰. All rights reserved.
//

#import "LHEditVideoViewController.h"
//#import <AVFoundation/AVFoundation.h>
#import <Masonry/Masonry.h>
#import <ZFDownload/ZFDownloadManager.h>
#import "ZFPlayer.h"
#import "ZFNavigationController.h"

#import "UIView+XMGExtension.h"
#import "LHSliderView.h"
#import <MBProgressHUD.h>
//#import <AssetsLibrary/AssetsLibrary.h>
#import "SAVideoRangeSlider.h"

//#import <MediaPlayer/MediaPlayer.h>
#import "GHHPhotoManager.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "LHVideoRangeSlider.h"
@interface LHEditVideoViewController () <ZFPlayerDelegate, SAVideoRangeSliderDelegate, LHVideoRangeSliderDelegate>{

    CGFloat startValue;
    CGFloat durationValue;
    float seconds;
    CGFloat _leftPosition;
    CGFloat _rightPosition;
}
@property (weak, nonatomic)  IBOutlet UIView *playerFatherView;
@property (strong, nonatomic) ZFPlayerView *playerView;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@property (nonatomic, strong) UIView *bottomView;
@property (weak, nonatomic) MBProgressHUD *hud;
@property(nonatomic, strong) AVAsset *videoAsset;

@property (strong, nonatomic) SAVideoRangeSlider *mySAVideoRangeSlider;
@property (strong, nonatomic) LHVideoRangeSlider *lhVideoRangeSlider;

@property(nonatomic, strong)GHHPhotoManager *manager;
@property(nonatomic, strong)AVURLAsset *avasset;
@property(nonatomic, strong)AVAssetImageGenerator *generator;
@property(nonatomic, strong)MPMoviePlayerController *moviePlayer;
@property(nonatomic, strong)MPMoviePlayerController *moviePlayer1;
@property(nonatomic, strong)UISlider *slider;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIButton *playBtn;
@property (nonatomic,strong) ALAssetsLibrary *assetLibrary;
@end

@implementation LHEditVideoViewController

- (ALAssetsLibrary *)assetLibrary{
    
    if (!_assetLibrary) {
        
        _assetLibrary = [[ALAssetsLibrary alloc] init];
        
    }
    return _assetLibrary;
}

- (instancetype)initWithAsset:(PHAsset *)asset {
    self = [super init];
    if (self) {
        self.asset = asset;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%@释放了",self.class);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.zf_interactivePopDisabled = YES;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    // pop回来时候是否自动播放
    if (self.navigationController.viewControllers.count == 2 && self.playerView && self.isPlaying) {
        self.isPlaying = NO;
        [self.playerView play];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    // push出下一级页面时候暂停
    if (self.navigationController.viewControllers.count == 3 && self.playerView && !self.playerView.isPauseByUser)
    {
        self.isPlaying = YES;
        [self.playerView pause];
    }
    
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.zf_interactivePopDisabled = NO;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self setUpPlayer];
    
    [self setUpSliderView];
    
    [self setUpStartCutBtn];
    
    startValue = 0;
    durationValue = seconds;
    
    [self setUpVideoRangeSlider];
    
//    [self setUpSlider];
    [self setUpImageView];
    
    
    [self setUpPlayBtn];
    [DZNotificationCenter addObserver:self selector:@selector(getSliderValue:) name:@"LHSliderMoveViewToValue" object:nil];
    
    
}

- (void)setUpImageView{

    self.imageView.image = [self.assetLibrary thumbnailImageForVideo:self.videoURL atTime:0];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:self.videoURL];
    self.moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
    self.moviePlayer.view.frame = self.imageView.bounds;
    self.moviePlayer.shouldAutoplay = NO;
    [self.moviePlayer prepareToPlay];
    
    self.moviePlayer1 = [[MPMoviePlayerController alloc] initWithContentURL:self.videoURL];
    self.moviePlayer1.controlStyle = MPMovieControlStyleEmbedded;
    self.moviePlayer1.view.frame = self.imageView.bounds;
    self.moviePlayer1.shouldAutoplay = NO;
    [self.moviePlayer1 prepareToPlay];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerThumbnailImageRequestDidFinish:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
    
}

- (void)setUpPlayBtn{
    
    // 代码添加playerBtn到imageView上
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imageView);
        make.width.height.mas_equalTo(50);
    }];
}

- (void)playBtnClick:(UIButton *)sender {
  
//    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
//    playerModel.title            = @"";
//    playerModel.videoURL         = self.videoURL;
//    
//    playerModel.placeholderImageURLString = @"";
//    playerModel.tableView        = @"";
//    playerModel.indexPath        = weakIndexPath;
//    // 赋值分辨率字典
//    //        playerModel.resolutionDic    = dic;
//    // player的父视图
//    playerModel.fatherView       = self.imageView;
//    
//    // 设置播放控制层和model
//    [weakSelf.playerView playerControlView:weakSelf.controlView playerModel:playerModel];
//    // 下载功能
//    weakSelf.playerView.hasDownload = YES;
//    // 自动播放
//    [weakSelf.playerView autoPlayTheVideo];
    [self setUpPlayer];
    
    [sender bringSubviewToFront:self.playerView];
}

- (void)setUpSlider{

    //test
    NSString *videoURLStr = [[NSBundle mainBundle] pathForResource:@"faceDemo" ofType:@"m4v"];
    NSURL *sampleURL = [NSURL fileURLWithPath:videoURLStr];
    
    self.imageView.image = [self.assetLibrary thumbnailImageForVideo:self.videoURL atTime:0];
    self.manager = [[GHHPhotoManager alloc] init];
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:self.videoURL];
    self.moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
    self.moviePlayer.view.frame = self.imageView.bounds;
    self.moviePlayer.shouldAutoplay = NO;
    [self.moviePlayer prepareToPlay];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerThumbnailImageRequestDidFinish:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(0, self.view.lh_Height - 130, ScreenWidth, 100)];
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.slider.maximumValue = [self getVideoDurationTime0:self.videoURL];
    self.slider.minimumValue = 0.0;
    [self.slider setThumbImage:[UIImage imageNamed:@"shuxianbaishe"] forState:UIControlStateNormal];
    [self.view addSubview:self.slider];
}

#pragma mark - Norification
- (void)moviePlayerThumbnailImageRequestDidFinish:(NSNotification *)notify {
    NSDictionary *userinfo = [notify userInfo];
    NSError* value = [userinfo objectForKey:MPMoviePlayerThumbnailErrorKey];
    if (value != nil) {
        NSLog(@"Error creating video thumbnail image. Details: %@", [value debugDescription]);
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
          self.imageView.image = [userinfo valueForKey:MPMoviePlayerThumbnailImageKey];
        });
        
    }
}

- (void)sliderValueChanged:(UISlider *)sender {
    XMGLog(@"sliderValueChanged  %f",sender.value);
    
        [self.moviePlayer requestThumbnailImagesAtTimes:[NSArray arrayWithObject:[NSNumber numberWithDouble:sender.value]] timeOption:MPMovieTimeOptionExact];


}

- (void)setUpVideoRangeSlider{
    
    CGFloat y = 480;
    LHVideoRangeSlider *lhVideoRangeSlider = [[LHVideoRangeSlider alloc] initWithFrame:CGRectMake(0, y, ScreenWidth, 70) videoUrl:self.videoURL];
    lhVideoRangeSlider.delegate = self;
    self.lhVideoRangeSlider = lhVideoRangeSlider;
    [lhVideoRangeSlider setPopoverBubbleSize:120 height:60];
    
    lhVideoRangeSlider.delegate = self;
    lhVideoRangeSlider.minGap = 0.1*[self getVideoDurationTime]; // optional, seconds
    lhVideoRangeSlider.maxGap = [self getVideoDurationTime]; // optional, seconds
    [self.view addSubview:lhVideoRangeSlider];
    
    self.lhVideoRangeSlider.bubleText.font = [UIFont systemFontOfSize:12];
    self.lhVideoRangeSlider.topBorder.backgroundColor = XMGRGBColor(225, 41, 64);
    self.lhVideoRangeSlider.bottomBorder.backgroundColor = XMGRGBColor(225, 41, 64);
    self.lhVideoRangeSlider.sliderLeftColor = XMGWordColor;
    self.lhVideoRangeSlider.sliderRightColor = XMGWordColor;
    self.lhVideoRangeSlider.bubbleColor = XMGWordColor;
    

//    CGFloat y = 480;
//    SAVideoRangeSlider *mySAVideoRangeSlider = [[SAVideoRangeSlider alloc] initWithFrame:CGRectMake(0, y, ScreenWidth, 70) videoUrl:self.videoURL];
//    self.mySAVideoRangeSlider = mySAVideoRangeSlider;
//    [mySAVideoRangeSlider setPopoverBubbleSize:120 height:60];
//    
//    mySAVideoRangeSlider.delegate = self;
//    mySAVideoRangeSlider.minGap = 10; // optional, seconds
//    mySAVideoRangeSlider.maxGap = [self getVideoDurationTime]; // optional, seconds
//    [self.view addSubview:mySAVideoRangeSlider];
//    
//    self.mySAVideoRangeSlider.bubleText.font = [UIFont systemFontOfSize:12];
//    self.mySAVideoRangeSlider.topBorder.backgroundColor = XMGRGBColor(225, 41, 64);
//    self.mySAVideoRangeSlider.bottomBorder.backgroundColor = XMGRGBColor(225, 41, 64);;
}

- (void)videoRange:(LHVideoRangeSlider *)videoRange didChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition{

    XMGLog(@"leftPosition:%f  rightPosition:%f",leftPosition, rightPosition);
    _leftPosition = leftPosition;
    _rightPosition = rightPosition;

     
//    [self.moviePlayer requestThumbnailImagesAtTimes:[NSArray arrayWithObject:[NSNumber numberWithDouble:leftPosition]] timeOption:MPMovieTimeOptionExact];
//    [self.moviePlayer1 requestThumbnailImagesAtTimes:[NSArray arrayWithObject:[NSNumber numberWithDouble:rightPosition]] timeOption:MPMovieTimeOptionExact];
    @autoreleasepool {
     
        [LHVideoRangeSlider requestThumbnailImagesAtTimesMoviePlayer:self.moviePlayer leftPosition:leftPosition];
        
        [LHVideoRangeSlider requestThumbnailImagesAtTimesMoviePlayer:self.moviePlayer1 rightPosition:rightPosition];
    }
}

- (void)setUpStartCutBtn{

    UIButton *startCut = [UIButton buttonWithType:UIButtonTypeCustom];
    startCut.backgroundColor = XMGWordColor;
    startCut.lh_X = 100;
    startCut.lh_Y = 410;
    startCut.lh_Width = 200;
    startCut.lh_Height = 50;
    [startCut setTitle:@"开始剪切" forState:UIControlStateNormal];
    [startCut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startCut setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [startCut addTarget:self action:@selector(startCutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startCut];
}

- (void)setUpPlayer{

//    [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(64);
//        make.leading.trailing.mas_equalTo(0);
//        // 这里宽高比16：9,可自定义宽高比
//        make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(9.0f/16.0f);
//    }];
    // 自动播放，默认不自动播放
    [self.playerView autoPlayTheVideo];
}

- (float)getVideoDurationTime{

    AVURLAsset * asset = [AVURLAsset assetWithURL:self.videoURL];
    CMTime   time = [asset duration];
    XMGLog(@"viewDidLoad %lld:%d",time.value , time.timescale);
    return ceil(time.value/time.timescale);
}

- (float)getVideoDurationTime0:(NSURL *)url{
    
    AVURLAsset * asset = [AVURLAsset assetWithURL:url];
    CMTime   time = [asset duration];
    XMGLog(@"viewDidLoad %lld:%d",time.value , time.timescale);
    return ceil(time.value/time.timescale);
}

- (void)setUpSliderView{

    AVURLAsset * asset = [AVURLAsset assetWithURL:self.videoURL];
    CMTime   time = [asset duration];
    XMGLog(@"viewDidLoad %lld:%d",time.value , time.timescale);
    seconds = [self getVideoDurationTime];
    
    LHSliderView *sliderView = [[LHSliderView alloc] initWithFrame:CGRectMake(0, 300, XMGScreenW, 60) sliderType:LHSliderTypeCenter];
    sliderView.minValue = 0;
    sliderView.maxValue = seconds;
    sliderView.thumbColor = XMGWordColor;
    [self.view addSubview:sliderView];
}

#pragma mark - Getter

- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            = @"这里设置视频标题";
        _playerModel.videoURL         = self.videoURL;
        _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        _playerModel.fatherView       = self.playerFatherView;
    }
    return _playerModel;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        
        /*****************************************************************************************
         *   // 指定控制层(可自定义)
         *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         ******************************************************************************************/
        [_playerView playerControlView:nil playerModel:self.playerModel];
        
        // 设置代理
        _playerView.delegate = self;
        
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
        
        // 打开下载功能（默认没有这个功能）
        _playerView.hasDownload    = YES;
        
        // 打开预览图
        self.playerView.hasPreviewView = YES;
        
    }
    return _playerView;
}

//裁剪视频
- (void)startCutBtnClick:(UIButton *)btn{

    if (!self.videoURL) {
        return;
    }
    
    [self.playerView pause];
    
    btn.selected = YES;
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.videoAsset = [AVAsset assetWithURL:self.videoURL];
    
    // 2 创建AVMutableComposition实例. apple developer 里边的解释 【AVMutableComposition is a mutable subclass of AVComposition you use when you want to create a new composition from existing assets. You can add and remove tracks, and you can add, remove, and scale time ranges.】
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    // 3 - 视频通道  工程文件中的轨道，有音频轨、视频轨等，里面可以插入各种对应的素材
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    NSError *error = nil;
    // 这块是裁剪,rangtime .前面的是开始时间,后面是裁剪多长 (我这裁剪的是从第二秒开始裁剪，裁剪2.55秒时长.)
//    CGFloat StartValue = 5.0f;
//    CGFloat durationValue = 5.0f;
    [videoTrack insertTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(startValue, 30), CMTimeMakeWithSeconds(durationValue, 30))
                        ofTrack:[[self.videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero
                          error:&error];
    
    // 3.1 AVMutableVideoCompositionInstruction 视频轨道中的一个视频，可以缩放、旋转等
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration);
    
    // 3.2 AVMutableVideoCompositionLayerInstruction 一个视频轨道，包含了这个轨道上的所有视频素材
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[self.videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
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
    [videolayerInstruction setOpacity:0.0 atTime:self.videoAsset.duration];
    
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    // AVMutableVideoComposition：管理所有视频轨道，可以决定最终视频的尺寸，裁剪需要在这里进行
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
    // 4 - Get path
    NSMutableString *outPutPath = [self createPathToMovie];
    [outPutPath appendString:self.videoURL.lastPathComponent];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPutPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:outPutPath error:nil];
    }
    
    NSURL *outPutUrl = [NSURL fileURLWithPath:outPutPath];
    
    // 5 - Create exporter
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL = outPutUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createAlbumPathName:@"视频剪辑大湿" patnMovie:outPutPath];
        });
    }];
}

- (NSMutableString *)createPathToMovie{
    
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *path = [NSMutableString stringWithString:[documents firstObject]];
    
    [path appendString:@"/LHPlayer/"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return path;
    
}

- (void)createAlbumPathName:(NSString *)name patnMovie:(NSString *)pathToMovie{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:pathToMovie] completionBlock:^(NSURL *assetURL, NSError *error) {
            
            if (error) {
                
                NSLog(@"writeVideoAtPathToSavedPhotosAlbum error[%@]", [error description]);
                
                return;
            }
            
            __block BOOL isAthomeGroupFound = NO;
            
            
            //遍历所有分组
            [library enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                
                //找到tempAlbumName
                if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:name]) {
                    
                    
                    isAthomeGroupFound = YES;
                    *stop = YES;
                    
                    
                    [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        
                        [group addAsset:asset];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            XMGLog(@"-视频裁剪--finished!!!!!");

                            [self.hud hideAnimated:YES];
                            [self.hud removeFromSuperViewOnHide];
                            
                            [[[UIAlertView alloc] initWithTitle:@"" message:@"已经成功写入相册！" delegate:nil cancelButtonTitle:@"好的"
                                              otherButtonTitles: nil] show];
                        });
                        
                    }
                            failureBlock:^(NSError *error) {
                                
                                XMGLog(@"exportVideoWriterToAlbum valueForProperty error %@",error);
                            }];
                    
                    return;
                    
                }
                
                
                //如果没有找到tempAlbumName,就需要先创建tempAlbumName
                if (!group && !isAthomeGroupFound){
                    [library addAssetsGroupAlbumWithName:name resultBlock:^(ALAssetsGroup *group1) {
                        
                        [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                            
                            [group1 addAsset:asset];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                XMGLog(@"-视频裁剪--finished!!!!!");
                                [self.hud hideAnimated:YES];
                                [self.hud removeFromSuperViewOnHide];
                                
                                [[[UIAlertView alloc] initWithTitle:@"" message:@"已经成功写入相册！" delegate:nil cancelButtonTitle:@"好的"
                                                  otherButtonTitles: nil] show];
                            });
                            
                            
                            
                        } failureBlock:^(NSError *error) {
                            XMGLog(@"exportVideoWriterToAlbum assetForURL error %@",error);
                        }];
                        
                    } failureBlock:^(NSError *error) {
                        XMGLog(@"exportVideoWriterToAlbum addAssetsGroupAlbumWithName error %@",error);
                    }];
                    
                }
                
            }
                                 failureBlock:^(NSError *error) {
                                     XMGLog(@"exportVideoWriterToAlbum error%@",error);
                                 }];
            
        }];
        
        
        
    });
    
    
}

- (void)getSliderValue:(NSNotification *)note{

    NSArray *arr = (NSArray *)note.object;
    for (NSInteger i=0; i<arr.count; i++) {
        UILabel *tempLabel = (UILabel *)arr[i];
        if (i == 0) {
            startValue = [[tempLabel.text componentsSeparatedByString:@"秒"].firstObject floatValue];
            XMGLog(@"getSliderValue startValue %f",startValue);
        }else if (i == 1){
        
            durationValue = [[tempLabel.text componentsSeparatedByString:@"秒"].firstObject floatValue] - startValue;
            XMGLog(@"getSliderValue durationValue %f",durationValue);
        }
        XMGLog(@"getSliderValue %@",tempLabel.text);
    }
    
}

+ (instancetype)editVideoViewController{

    return [[LHEditVideoViewController alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
