//
//  XMGRecordViewController.m
//  Cloud Player
//
//  Created by XMG on 2017/8/1.
//  Copyright © 2017年 ichano. All rights reserved.
//

#import "XMGRecordViewController.h"
#import "XMGRecordEngine.h"

#define TopViewHeight 60
@interface XMGRecordViewController ()
@property (weak, nonatomic) IBOutlet UIView   *topView;
@property (weak, nonatomic) IBOutlet UIView   *bottomView;
@property (strong, nonatomic) XMGRecordEngine *recordEngine;
@property (weak, nonatomic) UIButton  *photoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *testImageView;
@end

@implementation XMGRecordViewController
- (void)dealloc {
    _recordEngine = nil;
    
}

- (XMGRecordEngine *)recordEngine {
    if (_recordEngine == nil) {
        _recordEngine = [[XMGRecordEngine alloc] init];
    }
    return _recordEngine;
}

//支持旋转
-(BOOL)shouldAutorotate{
    
    return YES;
    
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAll;
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    [self.recordEngine startUp];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    if (_recordEngine == nil) {
        self.recordEngine.recordView = self.view;
        self.recordEngine.previewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    }
    
    [self setUpSubViews];
}

- (void)setUpSubViews{
    self.topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.bottomView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(XMGScreenW));
        make.height.equalTo(@(TopViewHeight));
        make.top.equalTo(self.topView.superview).with.offset(0);
        make.left.equalTo(self.topView.superview).with.offset(0);
    }];
    
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(XMGScreenW));
        make.height.equalTo(@(TopViewHeight));
        make.bottom.equalTo(self.bottomView.superview).with.offset(0);
        make.left.equalTo(self.bottomView.superview).with.offset(0);
    }];
    
    UIButton *photoBtn = [[UIButton alloc] init];
    self.photoBtn = photoBtn;
    photoBtn.backgroundColor = [UIColor greenColor];
    photoBtn.lh_Width = 60;
    photoBtn.lh_Height = photoBtn.lh_Width;
    photoBtn.lh_X = 0.5*(XMGScreenW-photoBtn.lh_Width);
    photoBtn.lh_Y = 0;
    [photoBtn addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:photoBtn];
    
    UIButton *albumBtn = [[UIButton alloc] init];
    albumBtn.backgroundColor = [UIColor grayColor];
    albumBtn.lh_Width = 40;
    albumBtn.lh_Height = albumBtn.lh_Width;
    albumBtn.lh_X = 10;
    albumBtn.lh_Y = 10;
    [albumBtn addTarget:self action:@selector(albumBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:albumBtn];
}

- (void)albumBtnClick:(UIButton *)sender{
    
}

- (void)photoBtnClick:(UIButton *)sender{
    blockSelf(self);
    [self.recordEngine snapStillImage:^(NSData *imageData) {
        UIImage *img = [[UIImage alloc] initWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.testImageView.image = img;
        });
    }];
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if ( UIDeviceOrientationIsPortrait( deviceOrientation ) || UIDeviceOrientationIsLandscape( deviceOrientation ) ) {
        self.recordEngine.previewLayer.connection.videoOrientation = (AVCaptureVideoOrientation)deviceOrientation;
        [self adjustSubViewsConstraint:deviceOrientation];
    }
}

- (void)adjustSubViewsConstraint:(UIDeviceOrientation )orientation{

    if (orientation == UIDeviceOrientationPortrait) {
        
        NSLog(@"UIDeviceOrientationPortrait %@ -- %@",NSStringFromCGRect(self.view.frame),NSStringFromCGRect(self.recordEngine.previewLayer.frame));
        
        [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(XMGScreenW));
            make.height.equalTo(@(TopViewHeight));
            make.top.equalTo(self.topView.superview).with.offset(0);
            make.left.equalTo(self.topView.superview).with.offset(0);
        }];
        
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(XMGScreenW));
            make.height.equalTo(@(TopViewHeight));
            make.bottom.equalTo(self.bottomView.superview).with.offset(0);
            make.left.equalTo(self.bottomView.superview).with.offset(0);
        }];
        
        
    }else if (orientation == UIDeviceOrientationLandscapeRight ){

        NSLog(@"UIDeviceOrientationLandscapeRight %@ -- %@",NSStringFromCGRect(self.view.frame),NSStringFromCGRect(self.recordEngine.previewLayer.frame));
        
        [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(TopViewHeight));
            make.height.equalTo(@(XMGScreenW));
            make.top.equalTo(self.topView.superview).with.offset(0);
            make.right.equalTo(self.topView.superview).with.offset(0);
        }];
        
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(TopViewHeight));
            make.height.equalTo(@(XMGScreenW));
            make.bottom.equalTo(self.bottomView.superview).with.offset(0);
            make.left.equalTo(self.bottomView.superview).with.offset(0);
        }];
        
    }else if(orientation ==UIDeviceOrientationLandscapeLeft){
      
        NSLog(@"UIDeviceOrientationLandscapeLeft %@ -- %@",NSStringFromCGRect(self.view.frame),NSStringFromCGRect(self.recordEngine.previewLayer.frame));
        
        [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(TopViewHeight));
            make.height.equalTo(@(XMGScreenW));
            make.top.equalTo(self.topView.superview).with.offset(0);
            make.right.equalTo(self.topView.superview).with.offset(0);
        }];
        
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(TopViewHeight));
            make.height.equalTo(@(XMGScreenW));
            make.bottom.equalTo(self.bottomView.superview).with.offset(0);
            make.left.equalTo(self.bottomView.superview).with.offset(0);
        }];
        
    }else if (orientation == UIDeviceOrientationFaceUp){
        
        
    }
    
}


+ (instancetype)recordViewController{

    return [[XMGRecordViewController alloc] initWithNibName:@"XMGRecordViewController" bundle:nil];
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
