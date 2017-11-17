//
//  XMGAlbumViewController.m
//  Cloud Player
//
//  Created by jiyi on 2017/11/17.
//  Copyright © 2017年 ichano. All rights reserved.
//

#import "XMGAlbumViewController.h"
#import "XMGPhotoViewController.h"
#import "XMGVideoViewController.h"
@interface XMGAlbumViewController ()<UIScrollViewDelegate, UINavigationBarDelegate>{
    
    CGFloat endContentOffsetX;
    CGFloat startContentOffsetX;
    CGFloat willEndContentOffsetX;
    BOOL isScroll;
}
@property (nonatomic, weak) XMGPhotoViewController *phoroVc;
@property (nonatomic, weak) XMGVideoViewController *videoVc;
@property (nonatomic, weak) UIView *titlesView;
@property (nonatomic, weak) UIView *indicatorView;
@property (nonatomic, weak) UIScrollView *contentView;
@property (nonatomic, weak) UIButton *backButton;
@property (nonatomic, weak) UIButton *editButton;
@property (nonatomic, weak) UIButton *selectedButton;

@end

@implementation XMGAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isScroll = NO;
    [self setupChildVces];
    [self setUpTitleView];
}

- (void)setUpTitleView{
    
    
    
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = GlobalBgColor;
    titleView.lh_Width = XMGScreenW;
    titleView.lh_Height = 44;
    titleView.lh_X = 0;
    titleView.lh_Y = 44;
    
    self.titlesView = titleView;
    
    UIView *coverView = [[UIView alloc] init];
    coverView.backgroundColor = [UIColor clearColor];
    coverView.lh_Width = XMGScreenW;
    coverView.lh_Height = 44;
    coverView.lh_X = 0;
    coverView.lh_Y = 20;
    [coverView addSubview:titleView];
    [self.view addSubview:coverView];
    
    UIButton *backButton = [[UIButton alloc] init];
    backButton.lh_X = 5;
    backButton.lh_Y = titleView.lh_Y;
    backButton.lh_Width = 50;
    backButton.lh_Height = titleView.lh_Height;
    [backButton setImage:[UIImage imageNamed:@"backChevron"] forState:UIControlStateNormal];
    //    [backButton setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateDisabled];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backCameraVcAction:) forControlEvents:UIControlEventTouchUpInside];
    [coverView addSubview:backButton];
    [backButton bringSubviewToFront:coverView];
    self.backButton = backButton;
    
    UIButton *editButton = [[UIButton alloc] init];
    editButton.lh_Width = 50;
    editButton.lh_Height = titleView.lh_Height;
    editButton.lh_X = XMGScreenW - editButton.lh_Width;
    editButton.lh_Y = titleView.lh_Y;
    
    [editButton setTitle:XMGEdit forState:UIControlStateNormal];
    editButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [coverView addSubview:editButton];
    [editButton bringSubviewToFront:coverView];
    self.editButton = editButton;
    
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.lh_Height = 2;
    indicatorView.tag = -1;
    indicatorView.lh_Y = self.titlesView.lh_Height - self.indicatorView.lh_Height - 2;
    [self.titlesView addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    NSArray *titles = @[@"照片",@"视频"];
    CGFloat width = self.titlesView.lh_Width/titles.count;
    CGFloat height = self.titlesView.lh_Height;
    
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        NSLog(@"setUpTitleView %ld",(long)btn.tag);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.lh_Width = width;
        btn.lh_Height = height;
        btn.lh_X = i*btn.lh_Width;
        
        
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titlesView addSubview:btn];
        
        
        if (i == 0) {
            btn.enabled = NO;
            self.selectedButton = btn;
            [btn.titleLabel sizeToFit];
            btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -0.2*XMGScreenW);
            btn.titleLabel.textAlignment = NSTextAlignmentRight;
            
            self.indicatorView.lh_Width = btn.titleLabel.lh_Width + 20;
            self.indicatorView.lh_CenterX = btn.lh_CenterX + 0.1*XMGScreenW;
        }else{
            
            [btn.titleLabel sizeToFit];
            btn.contentEdgeInsets = UIEdgeInsetsMake(0, -0.2*XMGScreenW, 0, 0);
            btn.titleLabel.textAlignment = NSTextAlignmentRight;
            self.indicatorView.lh_Width = btn.titleLabel.lh_Width + 20;
        }
        if (kiPhone5) {
            btn.titleLabel.font = [UIFont systemFontOfSize:17];
        }
    }
    
    
}

- (void)setupChildVces{
    
    XMGPhotoViewController *pictureVc = [XMGPhotoViewController photoViewController];
    [self addChildViewController:pictureVc];
    self.phoroVc = pictureVc;

    
    XMGVideoViewController *videoVc = [XMGVideoViewController videoViewController];
    [self addChildViewController:videoVc];
    self.videoVc = videoVc;
}

- (void)setUpContentView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = CGRectMake(0, 0, XMGScreenW, XMGScreenH);
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.lh_Width * self.childViewControllers.count, 0);
    self.contentView = contentView;
    
    NSInteger index = contentView.contentOffset.x / contentView.lh_Width;
//    self.vcIndex = index;
    
    [self scrollViewDidEndScrollingAnimation:contentView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{    //拖动前的起始坐标
    startContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    willEndContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x / scrollView.lh_Width;
    
    UICollectionViewController *vc = self.childViewControllers[index];
    vc.view.lh_X = scrollView.contentOffset.x;
    [scrollView addSubview:vc.view];
//    self.editDelegate = vc;
    //    if (index) {
    //        UICollectionViewController *currentVc = self.childViewControllers[index-1];
    //        self.delegate = self.pictureVc;
    //
    //    }else{
    //
    //        UICollectionViewController *currentVc = self.childViewControllers[index];
    //        self.delegate = self.videoVc;
    //    }
//    self.pictureDelegate = self.pictureVc;
//    self.videoDelegate = self.videoVc;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    isScroll = YES;
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.lh_Width;
    [self titleClick:self.titlesView.subviews[index+1]];
    
}

- (void)titleClick:(UIButton *)btn{
    NSLog(@"titleClick %ld",(long)btn.tag);
    endContentOffsetX = self.contentView.contentOffset.x;
    self.selectedButton.enabled = YES;
    btn.enabled = NO;
    self.selectedButton = btn;
    [UIView animateWithDuration:0.25 animations:^{
        //        HWLog(@"self.indicatorView.width%f--%f",self.indicatorView.width, btn.titleLabel.width);
        //        self.indicatorView.width = btn.titleLabel.width;
        if (btn.tag == 1) {
            self.indicatorView.lh_CenterX = btn.lh_CenterX - 0.1*XMGScreenW;
        }else{
            
            self.indicatorView.lh_CenterX = btn.lh_CenterX + 0.1*XMGScreenW;
        }
        
        
    }];
    
    CGPoint offset = self.contentView.contentOffset;
    offset.x = btn.tag * self.contentView.lh_Width;
    NSLog(@"titleClick offset %f",offset.x);
    
    if (!isScroll) {
        self.backButton.selected = NO;
        [self.editButton setTitle:XMGEdit forState:UIControlStateNormal];
//        self.pictureVc.editing = NO;
//        self.videoVc.editing = NO;
    }
    
    if (btn.tag == 1) {
        if (offset.x!=0) {
            if (endContentOffsetX > willEndContentOffsetX && willEndContentOffsetX > startContentOffsetX) {
                self.backButton.enabled = YES;
                [self.editButton setTitle:XMGEdit forState:UIControlStateNormal];
//                self.pictureVc.editing = NO;
                self.videoVc.editing = NO;
                isScroll = NO;
            }
            
//            if ([self.pictureDelegate respondsToSelector:@selector(cancelEditingSelectVc:ForTag: editButton:removeBtn:)]) {
//                [self.pictureDelegate cancelEditingSelectVc:self.pictureVc ForTag:btn.tag editButton:self.editButton removeBtn:self.backButton];
//            }
        }
    }else{
        
        if (offset.x==0) {
            
            if (endContentOffsetX < willEndContentOffsetX && willEndContentOffsetX < startContentOffsetX) {
                self.backButton.enabled = YES;
                [self.editButton setTitle:XMGEdit forState:UIControlStateNormal];
//                self.pictureVc.editing = NO;
//                self.videoVc.editing = NO;
                isScroll = NO;
            }
            
//            if ([self.videoDelegate respondsToSelector:@selector(cancelEditingSelectVc:ForTag: editButton:removeBtn:)]) {
//                [self.videoDelegate cancelEditingSelectVc:self.videoVc ForTag:btn.tag editButton:self.editButton removeBtn:self.backButton];
//            }
        }
    }
    
    [self.contentView setContentOffset:offset animated:YES];
    
}

- (BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController
{
    return (viewController.isViewLoaded && viewController.view.window);
}

+ (instancetype)albumViewController{
    
    return [[XMGAlbumViewController alloc] initWithNibName:@"XMGAlbumViewController" bundle:nil];
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
