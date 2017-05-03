//
//  XMGPostPictureViewController.m
//  Cloud Player
//
//  Created by hwawo on 17/3/31.
//  Copyright © 2017年 ichano. All rights reserved.
//

#import "XMGPostPictureViewController.h"
#import "TZImagePickerController.h"
#import "TZPhotoPreviewController.h"
#import "XMGPictureCollectionCell.h"
#import "LxGridViewFlowLayout.h"
#import "XMGPictureCollectionCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#define MaxPictureCount 9
#define ColumnNumber    3

@interface XMGPostPictureViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate> {
    
    
}

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation XMGPostPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
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
