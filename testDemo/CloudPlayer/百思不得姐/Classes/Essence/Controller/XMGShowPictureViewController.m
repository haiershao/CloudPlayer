//
//  XMGShowPictureViewController.m
//  百思不得姐
//
//  Created by hwawo on 16/7/9.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGShowPictureViewController.h"
#import "XMGTopic.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
#import "XMGProgressView.h"
@interface XMGShowPictureViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet XMGProgressView *progressView;
@end

@implementation XMGShowPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGFloat screenW = XMGScreenW;
    CGFloat screenH = XMGScreenH;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)]];
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;
    
    CGFloat pictureW = screenW;
    CGFloat pictureH = pictureW*self.topic.height/self.topic.width;
    if (pictureH>screenH) {
        imageView.frame = CGRectMake(0, 0, pictureW, pictureH);
        self.scrollView.contentSize = CGSizeMake(0, pictureH);
    }else{
        
        imageView.lh_Size = CGSizeMake(pictureW, pictureH);
        imageView.lh_CenterY = 0.5 * screenH;
    }
    
    // 立马显示最新的进度值(防止因为网速慢, 导致显示的是其他图片的下载进度)
    [self.progressView setProgress:self.topic.pictureProgress animated:NO];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        [self.progressView setProgress:1.0*receivedSize/expectedSize animated:NO];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
    }];
}

+ (instancetype)showPictureViewController{

    return [[XMGShowPictureViewController alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (IBAction)back:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)save:(UIButton *)sender {
    if (self.imageView.image == nil) {
        [SVProgressHUD showErrorWithStatus:@"图片未下载完毕!"];
        return;
    }
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{

    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败!"];
    }else{
    
        [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
    }
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
