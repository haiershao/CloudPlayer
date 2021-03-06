//
//  CZDownloadViewController.m
//  Cloud Player
//
//  Created by hwawo on 17/3/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CZDownloadViewController.h"
#import "ZFPlayer.h"
#import "CZDownloadedCell.h"
#import "CZDownloadingCell.h"
#import <ZFDownload/ZFDownloadManager.h>
#import <MJRefresh/UIView+MJExtension.h>

#import <GPUImage/GPUImage.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MBProgressHUD.h>
#import "CZDownloadingCell.h"
#import "LHMergeVideoController.h"
#import "LHEditVideoViewController.h"
#import "UIView+XMGExtension.h"
#import "UIImage+XMGImageExtension.h"

#define  DownloadManager  [ZFDownloadManager sharedDownloadManager]
#define AUDIO_URL [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"月半弯" ofType:@"mp3"]]
@interface CZDownloadViewController ()<UITableViewDataSource,UITableViewDelegate,ZFDownloadDelegate>{
    
    BOOL _isWaterPicture;
    BOOL _isWaterCharacter;
    BOOL _isCaijianVideo;
    BOOL _isBGMusicToVideo;
    BOOL _isMergeVideo;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (atomic, strong ) NSMutableArray *downloadObjectArr;

@property (weak, nonatomic) UIView *titleView;
@property (strong, nonatomic) NSMutableArray *downloadedCells;
@property (weak, nonatomic) CZDownloadedCell *downloadedCell;
@property (weak, nonatomic) UIView *cellView;
@property (strong, nonatomic) NSMutableArray *cellViews;
@property (strong, nonatomic) NSMutableArray *titleBtns;
@property (strong, nonatomic) NSMutableArray *mp4Paths;
@property (strong, nonatomic) GPUImageMovie *movieFile;
@property (strong, nonatomic) GPUImageUIElement *landInput;
@property (strong, nonatomic) GPUImageAlphaBlendFilter *landBlendFilter;
@property (strong, nonatomic) GPUImageMovieWriter *movieWriter;
@property (strong, nonatomic) GPUImageBrightnessFilter *brightnessFilter;
@property (strong, nonatomic) GPUImageBrightnessFilter *filter;
@property (weak, nonatomic) UIButton *selectBtn;
@property (strong, nonatomic) GPUImageTransformFilter *landTransformFilter;
@property (weak, nonatomic) UIButton *selectTitleBtn;
@property(nonatomic, strong) AVAsset *videoAsset;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) NSMutableArray *videoNames;
@property (strong, nonatomic) NSMutableArray *videoIconImages;

@end

@implementation CZDownloadViewController
- (NSMutableArray *)videoIconImages{
    
    if (!_videoIconImages) {
        _videoIconImages = [NSMutableArray array];
    }
    return _videoIconImages;
}

- (NSMutableArray *)videoNames{
    
    if (!_videoNames) {
        _videoNames = [NSMutableArray array];
    }
    return _videoNames;
}

- (NSMutableArray *)titleBtns{
    
    if (!_titleBtns) {
        _titleBtns = [NSMutableArray array];
    }
    return _titleBtns;
}

- (NSMutableArray *)downloadedCells{
    
    if (!_downloadedCells) {
        _downloadedCells = [NSMutableArray array];
    }
    return _downloadedCells;
}

- (NSMutableArray *)cellViews{
    
    if (!_cellViews) {
        _cellViews = [NSMutableArray array];
    }
    return _cellViews;
}

- (NSMutableArray *)mp4Paths{
    
    if (!_mp4Paths) {
        _mp4Paths = [NSMutableArray array];
    }
    return _mp4Paths;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    // 更新数据源
    [self initData];
    
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [self.downloadedCells removeAllObjects];
    
    for (NSInteger i = 0; i < self.cellViews.count; i++) {
        UIView *cellView = self.cellViews[i];
        [cellView removeFromSuperview];
    }
    [self.cellViews removeAllObjects];
    self.selectTitleBtn.selected = NO;
    
    for (NSInteger i = 0; i < self.titleBtns.count; i++) {
        UIButton *btn = (UIButton *)self.titleBtns[i];
        if (btn.selected) {
            btn.selected = NO;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _isWaterPicture = NO;
    _isWaterCharacter = NO;
    _isCaijianVideo = NO;
    _isBGMusicToVideo = NO;
    _isMergeVideo = NO;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -49, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    DownloadManager.downloadDelegate = self;
    // NSLog(@"%@", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES));
    
    //===
    self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    
    [self readVideoAndPngFile];
    //    [self getVideoPath];
    [self setUpTitleView];
    
    [self setUpRightBarButtonItems];
    
//    [self setUpLeftBarButtonItem];
}

- (void)setUpLeftBarButtonItem{

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick:)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)cancelBtnClick:(UIBarButtonItem *)leftItem{

    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)setUpRightBarButtonItems{

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"全部开始" style:UIBarButtonItemStylePlain target:self action:@selector(startAll:)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"全部暂停" style:UIBarButtonItemStylePlain target:self action:@selector(pauseAll:)];
    self.navigationItem.rightBarButtonItems = @[rightItem, leftItem];
}

+ (instancetype)downloadViewController{

    return [[CZDownloadViewController alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
}


- (void)setUpTitleView{
    
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(0, 64, XMGScreenW, 40);
    //    titleView.backgroundColor = [UIColor redColor];
    [self.view addSubview:titleView];
    self.titleView = titleView;
    
    NSArray *titles = @[@"水印图片", @"水印文字", @"裁剪视频", @"添加背景音乐", @"视频合并"];
    CGFloat width = XMGScreenW/titles.count;
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        btn.mj_w = width;
        btn.mj_h = titleView.mj_h;
        btn.mj_x = i*width;
        btn.mj_y = 0;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:XMGWordColor forState:UIControlStateSelected];
        //        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [titleView addSubview:btn];
        [self.titleBtns addObject:btn];
        //        if (btn.tag == 0) {
        //            self.selectTitleBtn = btn;
        //        }
        
    }
}

- (void)btnClick:(UIButton *)btn{
    XMGLog(@"btnClick btn.tag %ld",(long)btn.tag);
    
    for (NSInteger i = 0; i<self.titleBtns.count; i++) {
        UIButton *button = (UIButton *)self.titleBtns[i];
        
        if (button.tag == btn.tag) {
            btn.selected = !btn.selected;
        }else{
            
            button.selected = NO;
        }
        
    }
    
    if (btn.tag == 0) {
        
        
        _isWaterPicture = YES;
        _isWaterCharacter = NO;
        _isCaijianVideo = NO;
        _isBGMusicToVideo = NO;
        _isMergeVideo = NO;
        
        for (NSInteger i = 0; i < self.cellViews.count; i++) {
            self.cellView = self.cellViews[i];
            [self.cellView removeFromSuperview];
        }
        XMGLog(@"===========水印图片==========");
        
        if (btn.selected) {
            
            [self setUpCellView];
            
        }else{
            
            for (NSInteger i = 0; i < self.cellViews.count; i++) {
                self.cellView = self.cellViews[i];
                [self.cellView removeFromSuperview];
            }
            
        }
    }else if(btn.tag == 1){
        
        XMGLog(@"===========水印文字==========");
        _isWaterCharacter = YES;
        _isWaterPicture = NO;
        _isCaijianVideo = NO;
        _isBGMusicToVideo = NO;
        _isMergeVideo = NO;
        
        for (NSInteger i = 0; i < self.cellViews.count; i++) {
            self.cellView = self.cellViews[i];
            [self.cellView removeFromSuperview];
        }
        
        if (btn.selected) {
            
            XMGLog(@"===========titleBtn选中==========");
            [self setUpCellView];
            
        }else{
            XMGLog(@"===========titleBtn未选中==========");
            for (NSInteger i = 0; i < self.cellViews.count; i++) {
                XMGLog(@"cellView 水印文字");
                self.cellView = self.cellViews[i];
                [self.cellView removeFromSuperview];
            }
        }
        
    }else if (btn.tag == 2){
        
        _isCaijianVideo = YES;
        _isWaterCharacter = NO;
        _isWaterPicture = NO;
        _isBGMusicToVideo = NO;
        _isMergeVideo = NO;
        
        XMGLog(@"===========裁剪视频==========");
        
        for (NSInteger i = 0; i < self.cellViews.count; i++) {
            self.cellView = self.cellViews[i];
            [self.cellView removeFromSuperview];
        }
        
        if (btn.selected) {
            
            XMGLog(@"===========titleBtn2选中==========");
            [self setUpCellView];
            
        }else{
            XMGLog(@"===========titleBtn2未选中==========");
            for (NSInteger i = 0; i < self.cellViews.count; i++) {
                XMGLog(@"cellView 裁剪视频");
                self.cellView = self.cellViews[i];
                [self.cellView removeFromSuperview];
            }
        }
    }else if (btn.tag == 3){
        
        _isBGMusicToVideo = YES;
        _isCaijianVideo = NO;
        _isWaterCharacter = NO;
        _isWaterPicture = NO;
        _isMergeVideo = NO;
        
        XMGLog(@"===========添加背景音乐==========");
        
        for (NSInteger i = 0; i < self.cellViews.count; i++) {
            self.cellView = self.cellViews[i];
            [self.cellView removeFromSuperview];
        }
        
        if (btn.selected) {
            
            XMGLog(@"===========titleBtn3选中==========");
            [self setUpCellView];
            
        }else{
            XMGLog(@"===========titleBtn3未选中==========");
            for (NSInteger i = 0; i < self.cellViews.count; i++) {
                XMGLog(@"cellView 添加背景音乐");
                self.cellView = self.cellViews[i];
                [self.cellView removeFromSuperview];
            }
        }
    }else if (btn.tag == 4){
        
        _isMergeVideo = YES;
        _isBGMusicToVideo = NO;
        _isCaijianVideo = NO;
        _isWaterCharacter = NO;
        _isWaterPicture = NO;
        
        XMGLog(@"===========合并视频==========");
        
        for (NSInteger i = 0; i < self.cellViews.count; i++) {
            self.cellView = self.cellViews[i];
            [self.cellView removeFromSuperview];
        }
        
        if (btn.selected) {
            
            XMGLog(@"===========titleBtn4选中==========");
            [self setUpCellView];
            
        }else{
            XMGLog(@"===========titleBtn4未选中==========");
            for (NSInteger i = 0; i < self.cellViews.count; i++) {
                XMGLog(@"cellView 合并视频");
                self.cellView = self.cellViews[i];
                [self.cellView removeFromSuperview];
            }
        }
    }
    
}

- (void)setUpCellView{
    
    if (self.cellViews) {
        [self.cellViews removeAllObjects];
    }
    XMGLog(@"setUpCellView %@",self.downloadedCells);
    for (NSInteger i = 0; i < self.downloadedCells.count; i++) {
        UIView *cellView = [[UIView alloc] init];
        cellView.frame = self.downloadedCell.bounds;
        self.downloadedCell = (CZDownloadedCell *)self.downloadedCells[i];
        [self.downloadedCell addSubview:cellView];
        
        [self.cellViews addObject:cellView];
        
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = 10 + i;
        btn.backgroundColor = [UIColor whiteColor];
        btn.mj_w = self.downloadedCell.mj_h;
        btn.mj_h = btn.mj_w - 4;
        btn.mj_x = self.downloadedCell.mj_w - btn.mj_w;
        btn.mj_y = 2;
        
        [btn setImage:[UIImage imageNamed:@"bg_dealcell"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"ic_choosed"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:btn];
    }
    
}

- (void)cellBtnClick:(UIButton *)btn{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.selectBtn.selected = NO;
        self.selectBtn = nil;
        self.selectBtn = btn;
        XMGLog(@"cellBtnClick self.selectBtn.tag %ld",(long)self.selectBtn.tag);
        XMGLog(@"cellBtnClick self.downloadObjectArr %@",self.downloadObjectArr[0][self.selectBtn.tag - 10]);
        ZFFileModel *fileInfo = self.downloadObjectArr[0][self.selectBtn.tag - 10];
        XMGLog(@"cellBtnClick fileInfo.fileName %@",fileInfo.fileName);
        if (_isWaterPicture) {
            
            [self readyToEditVideoPath:FILE_PATH(fileInfo.fileName)];
        }else if(_isWaterCharacter){
            
            [self readyAddWaterCharacterToVideoPatn:FILE_PATH(fileInfo.fileName)];
        }else if (_isCaijianVideo){
            
            XMGLog(@"cellBtnClick 裁剪视频");
            [self readyCutVideoPath:FILE_PATH(fileInfo.fileName)];
        }else if (_isBGMusicToVideo){
            
            XMGLog(@"cellBtnClick 添加背景音乐");
            [self readyAddBGMusicToVideoPath:FILE_PATH(fileInfo.fileName)];
        }else if (_isMergeVideo){
            
            XMGLog(@"cellBtnClick 合并视频");
            [self readyMergeVideoToVideoPath:FILE_PATH(fileInfo.fileName)];
        }
    }
}

- (void)readyMergeVideoToVideoPath:(NSString *)urlStr{
    
    [self.hud hideAnimated:YES];
    LHMergeVideoController *mergeVc = [LHMergeVideoController mergeVideoController];
    mergeVc.videoURL = [NSURL fileURLWithPath:urlStr];
    [self.navigationController pushViewController:mergeVc animated:YES];
}

- (void)readyAddBGMusicToVideoPath:(NSString *)urlStr{
    
    //视频 声音 来源
//    NSURL * videoInputUrl = [NSURL fileURLWithPath:urlStr];
    
    NSString *videoURL = [[NSBundle mainBundle] pathForResource:@"faceDemo" ofType:@"m4v"];
    NSURL *videoInputUrl = [NSURL fileURLWithPath:videoURL];
    
    NSURL * audioInputUrl = AUDIO_URL;
    
    UIImage *image = [[UIImage alloc] init];
    NSString *outPutPath = [[self createPathToMovie] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[urlStr lastPathComponent]]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPutPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:outPutPath error:nil];
    }
    __weak CZDownloadViewController *weakSelf = self;
    [image addBGMusicToEditVideoUrl:videoInputUrl BGMusicUrl:audioInputUrl outToPath:outPutPath finish:^(BOOL isFinish) {
        
        if (isFinish) {
          [weakSelf createAlbumPathName:@"视频剪辑大湿" patnMovie:outPutPath];
        }
    }];
}

- (void)readyCutVideoPath:(NSString *)urlStr{
    
    [self.hud hideAnimated:YES];
    
    LHEditVideoViewController *editVc = [LHEditVideoViewController editVideoViewController];
    editVc.videoURL = [NSURL fileURLWithPath:urlStr];
    [self.navigationController pushViewController:editVc animated:YES];
}

- (void)readyAddWaterCharacterToVideoPatn:(NSString *)urlStr{
    
    XMGLog(@"readyAddWaterCharacterToVideoPatn 水印文字");
    if (!urlStr) {
        return;
    }
//    NSURL *sampleURL = [NSURL fileURLWithPath:urlStr];
    
        NSString *videoURL = [[NSBundle mainBundle] pathForResource:@"faceDemo" ofType:@"m4v"];
        NSURL *sampleURL = [NSURL fileURLWithPath:videoURL];
    
    UIImage *image = [[UIImage alloc] init];
    NSString *myPathDocs = [[self createPathToMovie] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[sampleURL lastPathComponent]]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
    {
        [[NSFileManager defaultManager] removeItemAtPath:myPathDocs error:nil];
    }
    NSString *contentStr = @"哈哈  这是水印文字";
    NSString *contentFontStr = @"Helvetica-Bold";
    int contentFont = 36;
    UIColor *contentColor = [UIColor redColor];
    CGFloat height = 100;
    __weak CZDownloadViewController *weakSelf = self;
    [image addWaterCharacterToEditVideoUrl:sampleURL outToPath:myPathDocs waterCharacter:contentStr characterFont:contentFontStr characterFontSize:contentFont characterAlignmentMode:kCAAlignmentCenter characterColor:contentColor characterHeight:height finish:^(BOOL isFinish) {
        if (isFinish) {
           
            [weakSelf createAlbumPathName:@"视频剪辑大湿" patnMovie:myPathDocs];
        }
    }];
    
}

- (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition size:(CGSize)size
{
    XMGLog(@"applyVideoEffectsToComposition");
    // 1 - Set up the text layer
    CATextLayer *subtitle1Text = [[CATextLayer alloc] init];
    
    [subtitle1Text setFont:@"Helvetica-Bold"];
    [subtitle1Text setFontSize:36];
    [subtitle1Text setFrame:CGRectMake(0, 0, size.width, 100)];
    [subtitle1Text setString:@"哈哈  这是水印文字"];
    [subtitle1Text setAlignmentMode:kCAAlignmentCenter];
    [subtitle1Text setForegroundColor:[[UIColor redColor] CGColor]];
    
    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:subtitle1Text];
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [overlayLayer setMasksToBounds:YES];
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
}

- (void)readyToEditVideoPath:(NSString *)urlStr{
    XMGLog(@"readyToEditVideoPath 水印图片");
    
    if (!urlStr) {
        return;
    }
        NSURL *sampleURL = [NSURL fileURLWithPath:urlStr];
    
//    NSString *videoURL = [[NSBundle mainBundle] pathForResource:@"faceDemo" ofType:@"m4v"];
//    NSURL *sampleURL = [NSURL fileURLWithPath:videoURL];
    
    UIImage *image = [[UIImage alloc] init];
    NSMutableString *pathToMovie = [self createPathToMovie];
    NSString *strUrl = [NSString stringWithFormat:@"%@",sampleURL];
    NSString *appendStr = [strUrl lastPathComponent];
    [pathToMovie appendString:appendStr];
    unlink([pathToMovie UTF8String]); //如果视频存在，删掉！
    
    UIImage *image0 = [UIImage imageNamed:@"sample02"];
    UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    imv.hidden = NO;
    [imv setImage:image0];
    AVAsset *fileas = [AVAsset assetWithURL:sampleURL];
    CGSize movieSize = fileas.naturalSize;
    CGPoint center = CGPointMake(0.15*movieSize.width, 0.15*movieSize.height);
    
    //1.
    __weak CZDownloadViewController *weakSelf = self;
    [image addWaterPictureToEditVideoUrl:sampleURL outToPath:pathToMovie waterPicture:imv imageViewCenter:center finish:^(BOOL isFinish) {
        
        if (isFinish) {
          
            [weakSelf createAlbumPathName:@"视频剪辑大湿" patnMovie:pathToMovie];
        }
    }];
    
    //2.
//    __weak CZDownloadViewController *weakSelf = self;
//    //CGRectMake(10, 0.9*movieSize.height, 100, 40);
//    CGRect pictureFrame = CGRectMake(10, 0.9*movieSize.height, 100, 40);
//    [self addWaterPictureByPath:sampleURL andSavePath:pathToMovie waterPictureName:@"sample02" waterPictureFrame:pictureFrame finish:^(BOOL isFinish) {
//        if (isFinish) {
//
//            [weakSelf createAlbumPathName:@"视频剪辑大湿" patnMovie:pathToMovie];
//        }
//    }];
    
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
    NSURL *outPutUrl = [NSURL fileURLWithPath:savePath];
    [avAssetExportSession setOutputURL:outPutUrl];
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

- (void)readyFilter:(CGSize)movieSize urlStr:(NSString *)urlStr{
    
    UIImage *image = [UIImage imageNamed:@"sample02"];
    UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    imv.hidden = NO;
    [imv setImage:image];
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, movieSize.width, movieSize.height)];
    imv.center = CGPointMake(0.1*vi.bounds.size.width, 0.1*vi.bounds.size.height);
    [vi addSubview:imv];
    
    _landBlendFilter = [[GPUImageAlphaBlendFilter alloc] init];
    //mix即为叠加后的透明度,这里就直接写1.0了
    _landBlendFilter.mix = 0.5f;
    _landInput = [[GPUImageUIElement alloc] initWithView:vi];
    _landTransformFilter = [[GPUImageTransformFilter alloc] init];
    
    __unsafe_unretained GPUImageUIElement *weakLandInput = _landInput;
    
    [_filter setFrameProcessingCompletionBlock:^(GPUImageOutput * filter, CMTime time){
        XMGLog(@"setFrameProcessingCompletionBlock time.value:%lld time.timescale:%d  %lld",time.value,time.timescale,time.value/time.timescale);
        
        [weakLandInput update];
    }];
    
    NSMutableString *pathToMovie = [self createPathToMovie];
    NSString *appendStr = [urlStr lastPathComponent];
    [pathToMovie appendString:appendStr];
    unlink([pathToMovie UTF8String]); //如果视频存在，删掉！
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(640.0, 480.0)];
    _movieWriter.transform = CGAffineTransformMakeScale(0.3, 0.3);
    
    //    _brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    //    _brightnessFilter.brightness = 0.0f;
    
    if (_movieFile) {
        [_movieFile removeAllTargets];
    }
    [_movieFile addTarget:_filter];
    
    if (_filter) {
        [_filter removeAllTargets];
    }
    [_filter addTarget:_landBlendFilter];
    
    if (_landInput) {
        [_landInput removeAllTargets];
    }
    [_landInput addTarget:_landBlendFilter];
    
    if (_landBlendFilter) {
        [_landBlendFilter removeAllTargets];
    }
    
    
    [_landInput addTarget:_landTransformFilter];
    [_landTransformFilter addTarget:_landBlendFilter];
    XMGLog(@"readyFilter _landBlendFilter %@",_landBlendFilter);
    [_landBlendFilter addTarget:_movieWriter];
    
    
    
    
    
    [self exportVideoWriterToAlbum:pathToMovie];
}

/** 导出视频写入相册 */
- (void)exportVideoWriterToAlbum:(NSString *)pathToMovie{
    
    __weak CZDownloadViewController *weakSelf = self;
    _movieWriter.shouldPassthroughAudio = YES;
    _movieFile.audioEncodingTarget = _movieWriter;
    [_movieFile enableSynchronizedEncodingUsingMovieWriter:_movieWriter];
    
    [_movieWriter startRecording];
    [_movieFile startProcessing];
    
    [_movieWriter setCompletionBlock:^{
        [weakSelf.filter removeTarget:weakSelf.movieWriter];
        [weakSelf.movieWriter finishRecording];
        [weakSelf createAlbumPathName:@"视频剪辑大湿" patnMovie:pathToMovie];
        
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
                            if (_isWaterPicture) {
                                _isWaterPicture = NO;
                                XMGLog(@"-水印图片--finished!!!!!");
                                
                            }else if(_isWaterCharacter){
                                _isWaterCharacter = NO;
                                XMGLog(@"-水印文字--finished!!!!!");
                            }else if (_isCaijianVideo){
                                
                                _isCaijianVideo = NO;
                                XMGLog(@"-视频裁剪--finished!!!!!");
                            }else if (_isBGMusicToVideo){
                                
                                _isBGMusicToVideo = NO;
                                XMGLog(@"-添加背景乐--finished!!!!!");
                            }
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
                                if (_isWaterPicture) {
                                    _isWaterPicture = NO;
                                    XMGLog(@"-水印图片--finished!!!!!");
                                    
                                }else if(_isWaterCharacter){
                                    _isWaterCharacter = NO;
                                    XMGLog(@"-水印文字--finished!!!!!");
                                }else if (_isCaijianVideo){
                                    
                                    _isCaijianVideo = NO;
                                    XMGLog(@"-视频裁剪--finished!!!!!");
                                }else if (_isBGMusicToVideo){
                                    
                                    _isBGMusicToVideo = NO;
                                    XMGLog(@"-添加背景乐--finished!!!!!");
                                }
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

- (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    if (!videoURL) {
        return [UIImage imageNamed:@"file"];
    }
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

- (void)readVideoAndPngFile{
    
    NSString *extension = @"mp4";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    NSEnumerator *enumerator = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [enumerator nextObject])) {
        if ([[filename pathExtension] isEqualToString:extension]) {
            //            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:nil];
            [self.mp4Paths addObject:[documentsDirectory stringByAppendingPathComponent:filename]];
        }
    }
    
}

- (void)initData {
    [DownloadManager startLoad];
    NSMutableArray *downladed = DownloadManager.finishedlist;
    NSMutableArray *downloading = DownloadManager.downinglist;
    self.downloadObjectArr = @[].mutableCopy;
    [self.downloadObjectArr addObject:downladed];
    [self.downloadObjectArr addObject:downloading];
    [self.tableView reloadData];
}

/** 全部开始 */
- (void)startAll:(UIBarButtonItem *)sender {
    [DownloadManager startAllDownloads];
}

/** 全部暂停 */
- (void)pauseAll:(UIBarButtonItem *)sender {
    [DownloadManager pauseAllDownloads];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArray = self.downloadObjectArr[section];
    XMGLog(@"numberOfRowsInSection: %@",sectionArray);
    return sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CZDownloadedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"downloadedCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"CZDownloadedCell" owner:self options:nil].firstObject;
        }
        
        ZFFileModel *fileInfo = self.downloadObjectArr[indexPath.section][indexPath.row];
        cell.fileInfo = fileInfo;
        
        self.downloadedCell = cell;
        [self.downloadedCells addObject:cell];
        
        NSURL *strUrl = [NSURL fileURLWithPath:FILE_PATH(fileInfo.fileName)];
        UIImage *tempImage = [self thumbnailImageForVideo:strUrl atTime:0];
        cell.fileIconImage.image = tempImage;
        
        return cell;
    } else if (indexPath.section == 1) {
        CZDownloadingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"downloadingCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"CZDownloadingCell" owner:self options:nil].firstObject;
        }
        ZFHttpRequest *request = self.downloadObjectArr[indexPath.section][indexPath.row];
        if (request == nil) { return nil; }
        ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
        
        __weak typeof(self) weakSelf = self;
        // 下载按钮点击时候的要刷新列表
        cell.btnClickBlock = ^{
            [weakSelf initData];
        };
        // 下载模型赋值
        cell.fileInfo = fileInfo;
        // 下载的request
        cell.request = request;
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZFFileModel *fileInfo = self.downloadObjectArr[indexPath.section][indexPath.row];
        [DownloadManager deleteFinishFile:fileInfo];
    }else if (indexPath.section == 1) {
        ZFHttpRequest *request = self.downloadObjectArr[indexPath.section][indexPath.row];
        [DownloadManager deleteRequest:request];
    }
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @[@"下载完成",@"下载中"][section];
}

#pragma mark - ZFDownloadDelegate

// 开始下载
- (void)startDownload:(ZFHttpRequest *)request {
    NSLog(@"开始下载!");
}

// 下载中
- (void)updateCellProgress:(ZFHttpRequest *)request {
    ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    [self performSelectorOnMainThread:@selector(updateCellOnMainThread:) withObject:fileInfo waitUntilDone:YES];
}

// 下载完成
- (void)finishedDownload:(ZFHttpRequest *)request {
    [self initData];
}

// 更新下载进度
- (void)updateCellOnMainThread:(ZFFileModel *)fileInfo {
    NSArray *cellArr = [self.tableView visibleCells];
    for (id obj in cellArr) {
        if([obj isKindOfClass:[CZDownloadingCell class]]) {
            CZDownloadingCell *cell = (CZDownloadingCell *)obj;
            if([cell.fileInfo.fileURL isEqualToString:fileInfo.fileURL]) {
                cell.fileInfo = fileInfo;
                XMGLog(@"updateCellOnMainThread cell.fileInfo.fileURL %@",cell.fileInfo.fileURL);
            }
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UITableViewCell *cell            = (UITableViewCell *)sender;
    NSIndexPath *indexPath           = [self.tableView indexPathForCell:cell];
    ZFFileModel *model                 = self.downloadObjectArr[indexPath.section][indexPath.row];
    // 文件存放路径
    NSString *path                   = FILE_PATH(model.fileName);
    NSURL *videoURL                  = [NSURL fileURLWithPath:path];
    
//    MoviePlayerViewController *movie = (MoviePlayerViewController *)segue.destinationViewController;
//    movie.videoURL                   = videoURL;
}


@end
