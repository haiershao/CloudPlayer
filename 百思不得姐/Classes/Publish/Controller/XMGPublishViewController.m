//
//  XMGPublishViewController.m
//  百思不得姐
//
//  Created by hwawo on 16/7/11.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGPublishViewController.h"
#import "XMGVerticalButton.h"
#import <pop.h>
#import "CZDownloadViewController.h"
#import "XMGNavigationController.h"
#import "XMGPostWordViewController.h"
#import "XMGPostPictureViewController.h"
#import "TZImagePickerController.h"
#import "LHImagePickerController.h"
#import "HX_AlbumViewController.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#define MaxPictureCount 9
#define ColumnNumber    3

static CGFloat const XMGAnimationDelay = 0.1;
static CGFloat const XMGSpringFactor = 10;
@interface XMGPublishViewController ()<TZImagePickerControllerDelegate>

@end

@implementation XMGPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = NO;
    
    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    int maxCols = 3;
    CGFloat screenH = XMGScreenH;
    CGFloat screenW = XMGScreenW;
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 30;
    CGFloat buttonStartY = (screenH - 2*buttonH)/2;
    CGFloat buttonStartX = 20;
    CGFloat margin = (screenW - 2*buttonStartX - maxCols*buttonW)/(maxCols - 1);
    for (int i = 0; i < titles.count; i++) {
        XMGVerticalButton *button = [[XMGVerticalButton alloc] init];
        [self.view addSubview:button];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        int row = i / maxCols;
        int col = i % maxCols;

        CGFloat buttonX = buttonStartX + col*(margin + buttonW);
        CGFloat buttonEndY = buttonStartY + row*buttonH;
        CGFloat buttonBegainY = buttonEndY - XMGScreenH;
        
        
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonBegainY, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonEndY, buttonW, buttonH)];
        anim.springSpeed = XMGSpringFactor;
        anim.springBounciness = XMGSpringFactor;
        anim.beginTime = CACurrentMediaTime() + XMGAnimationDelay * i;
        [button pop_addAnimation:anim forKey:nil];
        
    }
    
    
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    [self.view addSubview:sloganView];
    
    CGFloat centerX = 0.5 * XMGScreenW;
    CGFloat centerEndY = 0.2*XMGScreenH;
    CGFloat centerBegainY = centerEndY - XMGScreenH;
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerBegainY)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerEndY)];
    anim.beginTime = CACurrentMediaTime() + images.count*XMGAnimationDelay;
    anim.springBounciness = XMGSpringFactor;
    anim.springSpeed = XMGSpringFactor;
    
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        self.view.userInteractionEnabled = YES;
    }];
    [sloganView pop_addAnimation:anim forKey:nil];
    
}

- (void)buttonClick:(UIButton *)button{

    [self cancelWithComplentionBlock:^{
        if (button.tag == 0) {
             XMGLog(@"发视频");
            
            [self pushImagePickerController:NO video:YES];
        }else if (button.tag == 1) {
        
            XMGLog(@"发图片");
            
            [self presentLHImagePickerController];
        }else if (button.tag == 2) {
            
            XMGLog(@"发段子");
            XMGPostWordViewController *postWordVc = [[XMGPostWordViewController alloc] init];
            XMGNavigationController *nav = [[XMGNavigationController alloc] initWithRootViewController:postWordVc];
            
            UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
            [root presentViewController:nav animated:YES completion:nil];
        }else if (button.tag == 3) {
            
            XMGLog(@"发声音");
        
        }else if (button.tag == 4) {
            
            XMGLog(@"审帖");
        }else if (button.tag == 5) {
            
            XMGLog(@"离线下载");
            CZDownloadViewController *downloadVc = [CZDownloadViewController downloadViewController];
            UITabBarController *tabBarVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *navVc = (UINavigationController *)tabBarVc.selectedViewController;
            [navVc pushViewController:downloadVc animated:YES];
        }
    }];
}

#pragma mark - LHImagePickerController
- (void)presentLHImagePickerController{

    HX_AlbumViewController *pickerVc = [[HX_AlbumViewController alloc] init];
    pickerVc.maxNum = MaxPictureCount;
    pickerVc.ifVideo = NO;
    
//    LHImagePickerController *pickerVc = [[LHImagePickerController alloc] init];
    UITabBarController *tabbarVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *selectedVc = (UIViewController *)tabbarVc.selectedViewController;
    [selectedVc presentViewController:pickerVc animated:YES completion:nil];
}


#pragma mark - TZImagePickerController

- (void)pushImagePickerController:(BOOL)isPicture video:(BOOL)isVideo{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:MaxPictureCount columnNumber:ColumnNumber delegate:self pushPhotoPickerVc:YES];
    
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = YES;
    
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = isVideo;
    imagePickerVc.allowPickingImage = isPicture;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = NO;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    imagePickerVc.circleCropRadius = 100;
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    UITabBarController *tabBarVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    XMGNavigationController *navVc = (XMGNavigationController *)tabBarVc.selectedViewController;
    [navVc presentViewController:imagePickerVc animated:YES completion:nil];
    
    
}

- (void)cancelWithComplentionBlock:(void (^)())completionBlock{

    self.view.userInteractionEnabled = NO;
    
    int begainIndex = 2;
    for (int i = begainIndex; i < self.view.subviews.count; i++) {
        UIView *subview = self.view.subviews[i];
        
        CGFloat centerY = subview.lh_CenterY + XMGScreenH;
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(subview.lh_CenterX, centerY)];
        anim.beginTime = CACurrentMediaTime() + (i- begainIndex)*XMGAnimationDelay;
        [subview pop_addAnimation:anim forKey:nil];
        
        if (i == self.view.subviews.count - 1) {
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
                [self dismissViewControllerAnimated:nil completion:nil];
                !completionBlock ? : completionBlock();
            }];
        }
        
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self cancelWithComplentionBlock:nil];
}

+ (instancetype)publishViewController{

    return [[XMGPublishViewController alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (IBAction)cancel {
    
    [self cancelWithComplentionBlock:nil];
}

@end
