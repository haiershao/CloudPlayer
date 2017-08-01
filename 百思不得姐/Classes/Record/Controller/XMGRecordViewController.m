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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_recordEngine == nil) {
        [self.recordEngine previewLayer].frame = self.view.bounds;
        [self.view.layer insertSublayer:[self.recordEngine previewLayer] atIndex:0];
        
    }
    [self.recordEngine startUp];
    
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpSubViews];
}

- (void)setUpSubViews{

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
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if ( UIDeviceOrientationIsPortrait( deviceOrientation ) || UIDeviceOrientationIsLandscape( deviceOrientation ) ) {
//        AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.previewView.layer;
//        previewLayer.connection.videoOrientation = (AVCaptureVideoOrientation)deviceOrientation;
        [self adjustSubViewsConstraint:deviceOrientation];
    }
}

- (void)adjustSubViewsConstraint:(UIDeviceOrientation )orientation{
    
    if (orientation ==UIDeviceOrientationPortrait) {
        
        NSLog(@"UIInterfaceOrientationPortrait");
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
        
    }else if (orientation ==UIDeviceOrientationLandscapeRight ){
        
        NSLog(@"UIDeviceOrientationLandscapeRight:%f -- %f ",XMGScreenW, XMGScreenH);
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
        
        NSLog(@"UIDeviceOrientationLandscapeLeft:%f -- %f ",XMGScreenW, XMGScreenH);
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
