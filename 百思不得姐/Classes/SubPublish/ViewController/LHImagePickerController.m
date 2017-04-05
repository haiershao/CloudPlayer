//
//  LHImagePickerController.m
//  Cloud Player
//
//  Created by hwawo on 17/4/1.
//  Copyright © 2017年 ichano. All rights reserved.
//

#import "LHImagePickerController.h"
#import "TZPhotoPickerController.h"
#import "TZPhotoPreviewController.h"
#import "TZAssetModel.h"
#import "TZAssetCell.h"
#import "UIView+Layout.h"
#import "TZImageManager.h"
#import <AVFoundation/AVFoundation.h>
#import "HX_AddPhotoView.h"
#import "HX_AlbumViewController.h"


@interface LHImagePickerController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate, HX_AddPhotoViewDelegate>

@end

@implementation LHImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpVc];
    
    [self setUpTool];
    
    [self setUpPickerView];
}

- (void)setUpPickerView{
    
    

//    HX_AddPhotoView *addPhotoView = [[HX_AddPhotoView alloc] initWithMaxPhotoNum:9 WithSelectType:SelectPhoto];
//    
//    // 每行最大个数   不设置默认为4
//    addPhotoView.lineNum = 3;
//    
//    // collectionView 距离顶部的距离  底部与顶部一样  不设置,默认为0
//    addPhotoView.margin_Top = 5;
//    
//    // 距离左边的距离  右边与左边一样  不设置,默认为0
//    addPhotoView.margin_Left = 10;
//    
//    // 每个item间隔的距离  如果最小不能小于5   不设置,默认为5
//    addPhotoView.lineSpacing = 5;
//    
//    // 录制视频时最大秒数   默认为60;
//    addPhotoView.videoMaximumDuration = 60.f;
//    
//    addPhotoView.delegate = self;
//    addPhotoView.backgroundColor = [UIColor whiteColor];
//    addPhotoView.frame = CGRectMake(0, 150, XMGScreenW - 0, 0);
//    [self.view addSubview:addPhotoView];
}

- (void)setUpTool{

    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor orangeColor];
    topView.lh_X = 0;
    topView.lh_Y = 0;
    topView.lh_Width = XMGScreenW;
    topView.lh_Height = 40;
    [self.view addSubview:topView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.lh_X = 0;
    cancelBtn.lh_Y = 0;
    cancelBtn.lh_Width = 60;
    cancelBtn.lh_Height = 40;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:XMGWordColor forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancelBtn];
    
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor orangeColor];
    bottomView.lh_X = 0;
    bottomView.lh_Y =  XMGScreenH - 40;
    bottomView.lh_Width = XMGScreenW;
    bottomView.lh_Height = 40;
    [self.view addSubview:bottomView];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.lh_X = XMGScreenW - 60;
    nextBtn.lh_Y = 0;
    nextBtn.lh_Width = 60;
    nextBtn.lh_Height = 40;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [nextBtn setTitleColor:XMGWordColor forState:UIControlStateHighlighted];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:nextBtn];
    
}

- (void)nextBtnClick{

    
}

- (void)cancelBtnClick{

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setUpVc{

    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.view.backgroundColor = [UIColor whiteColor];
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
