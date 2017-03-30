//
//  LHMergeVideoController.m
//  Player
//
//  Created by hwawo on 17/3/23.
//  Copyright © 2017年 LH. All rights reserved.
//

#import "LHMergeVideoController.h"
#import "ZFPlayer.h"
#import <ZFDownloadManager.h>
#import "ZFNavigationController.h"
#import <MBProgressHUD.h>
#import <AVFoundation/AVFoundation.h>
#import <Masonry.h>
#import "UIView+XMGExtension.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface LHMergeVideoController ()<ZFPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIView *playerFatherView0;
@property (weak, nonatomic) IBOutlet UIView *playerFatherView1;

@property (strong, nonatomic) ZFPlayerView *playerView0;
@property (strong, nonatomic) ZFPlayerView *playerView1;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) ZFPlayerModel *playerModel0;
@property (nonatomic, strong) ZFPlayerModel *playerModel1;
@property (nonatomic, strong) UIView *bottomView;
@property (weak, nonatomic) MBProgressHUD *hud;
@property(nonatomic, strong) AVAsset *videoAsset;
@property (nonatomic, strong) NSURL *videoURLTwo;
@end

@implementation LHMergeVideoController

- (void)dealloc {
    NSLog(@"%@释放了",self.class);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.zf_interactivePopDisabled = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    // pop回来时候是否自动播放
    if (self.navigationController.viewControllers.count == 2 && self.playerView0 &&self.playerView1 && self.isPlaying) {
        self.isPlaying = NO;
        [self.playerView0 play];
        [self.playerView1 play];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    // push出下一级页面时候暂停
    if (self.navigationController.viewControllers.count == 3 && self.playerView0 && self.playerView1 && !self.playerView0.isPauseByUser && !self.playerView1.isPauseByUser)
    {
        self.isPlaying = YES;
        [self.playerView0 pause];
        [self.playerView1 pause];
    }
    
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.zf_interactivePopDisabled = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpPlayer];
    
    [self setUpMergeButton];
}

- (void)setUpMergeButton{

    UIButton *mergeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mergeBtn.backgroundColor = XMGWordColor;
    mergeBtn.lh_X = 100;
    mergeBtn.lh_Y = CGRectGetMaxY(self.playerFatherView1.frame) + 30;
    mergeBtn.lh_Width = 200;
    mergeBtn.lh_Height = 50;
    [mergeBtn setTitle:@"开始合并" forState:UIControlStateNormal];
    [mergeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mergeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [mergeBtn addTarget:self action:@selector(mergeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mergeBtn];
}

- (void)mergeBtnClick:(UIButton *)btn{

    if (!self.videoURL || !self.videoURLTwo) {
        return;
    }
    
    [self.playerView0 pause];
    [self.playerView1 pause];
    
    btn.selected = YES;
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AVAsset *firstAsset = [AVAsset assetWithURL:self.videoURL];
    AVAsset *secondAsset = [AVAsset assetWithURL:self.videoURLTwo];
    
    // 1 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    // 2 - Video track
    AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration)
                        ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration)
                        ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:firstAsset.duration error:nil];
    // 3 - Audio track
    //这一段貌似是添加背景音乐的
    //    if (audioAsset!=nil){
    //        AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
    //                                                                            preferredTrackID:kCMPersistentTrackID_Invalid];
    //        [AudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeAdd(firstAsset.duration, secondAsset.duration))
    //                            ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    //    }
    
    
    // 4 - Get path
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
//                             [NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
//    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    
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
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createAlbumPathName:@"视频剪辑大湿" patnMovie:outPutPath];
        });
    }];
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
                            
                            XMGLog(@"-视频合并--finished!!!!!");
                            
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
                                
                                XMGLog(@"-视频合并--finished!!!!!");
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

- (void)setUpPlayer{
    
    [self.playerFatherView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.leading.trailing.mas_equalTo(0);
        // 这里宽高比16：9,可自定义宽高比
        make.height.mas_equalTo(self.playerFatherView0.mas_width).multipliedBy(9.0f/16.0f);
    }];
    // 自动播放，默认不自动播放
    [self.playerView0 autoPlayTheVideo];
    
    [self.playerFatherView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat viewY = CGRectGetMaxY(self.playerFatherView0.frame) + 64;
        make.top.mas_equalTo(viewY);
        make.leading.trailing.mas_equalTo(0);
        // 这里宽高比16：9,可自定义宽高比
        make.height.mas_equalTo(self.playerFatherView1.mas_width).multipliedBy(9.0f/16.0f);
    }];
    // 自动播放，默认不自动播放
    [self.playerView1 autoPlayTheVideo];
}

#pragma mark - Getter

- (ZFPlayerModel *)playerModel0 {
    if (!_playerModel0) {
        _playerModel0                  = [[ZFPlayerModel alloc] init];
        _playerModel0.title            = @"这里设置视频标题";
        _playerModel0.videoURL         = self.videoURL;
        _playerModel0.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        _playerModel0.fatherView       = self.playerFatherView0;
    }
    return _playerModel0;
}

- (ZFPlayerModel *)playerModel1 {
    if (!_playerModel1) {
        _playerModel1                  = [[ZFPlayerModel alloc] init];
        _playerModel1.title            = @"这里设置视频标题";
        NSString *videoURL = [[NSBundle mainBundle] pathForResource:@"faceDemo" ofType:@"m4v"];
        NSURL *sampleURL = [NSURL fileURLWithPath:videoURL];
        self.videoURLTwo = sampleURL;
        _playerModel1.videoURL         = sampleURL;
        _playerModel1.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        _playerModel1.fatherView       = self.playerFatherView1;
    }
    return _playerModel1;
}

- (ZFPlayerView *)playerView0 {
    if (!_playerView0) {
        _playerView0 = [[ZFPlayerView alloc] init];
        
        /*****************************************************************************************
         *   // 指定控制层(可自定义)
         *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         ******************************************************************************************/
        [_playerView0 playerControlView:nil playerModel:self.playerModel0];
        
        // 设置代理
        _playerView0.delegate = self;
        
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
        
        // 打开下载功能（默认没有这个功能）
        _playerView0.hasDownload    = YES;
        
        // 打开预览图
        self.playerView0.hasPreviewView = YES;
        
    }
    return _playerView0;
}

- (ZFPlayerView *)playerView1 {
    if (!_playerView1) {
        _playerView1 = [[ZFPlayerView alloc] init];
        
        /*****************************************************************************************
         *   // 指定控制层(可自定义)
         *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         ******************************************************************************************/
        [_playerView1 playerControlView:nil playerModel:self.playerModel1];
        
        // 设置代理
        _playerView1.delegate = self;
        
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
        
        // 打开下载功能（默认没有这个功能）
        _playerView1.hasDownload    = YES;
        
        // 打开预览图
        self.playerView1.hasPreviewView = YES;
        
    }
    return _playerView1;
}

+ (instancetype)mergeVideoController{

    return [[LHMergeVideoController alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
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
