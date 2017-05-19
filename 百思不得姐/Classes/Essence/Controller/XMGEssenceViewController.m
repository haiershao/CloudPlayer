//
//  XMGEssenceViewController.m
//  百思不得姐
//
//  Created by hwawo on 16/6/29.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGEssenceViewController.h"
#import "XMGRecommendTagsViewController.h"
#import "XMGTopicViewController.h"
@interface XMGEssenceViewController ()<UIScrollViewDelegate>

/** 标签栏底部的红色指示器 */
@property (nonatomic, weak) UIView *indicatorView;
@property (nonatomic, strong) UIButton *selectedButton;
/** 顶部的所有标签 */
@property (nonatomic, weak) UIView *titlesView;
/** 底部的所有内容 */
@property (nonatomic, weak) UIScrollView *contentView;

@end

@implementation XMGEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpNav];
    
    [self setUpChildVces];
    
    [self setUpTitleView];
    
    [self setUpContentView];
}

- (void)setUpChildVces{
    
    XMGTopicViewController *all = [[XMGTopicViewController alloc] init];
    all.title = @"全部";
    all.type = XMGTopicTypeAll;
    [self addChildViewController:all];
    
    XMGTopicViewController *video = [[XMGTopicViewController alloc] init];
    video.title = @"视频";
    video.type = XMGTopicTypeVideo;
    [self addChildViewController:video];
    
    XMGTopicViewController *voice = [[XMGTopicViewController alloc] init];
    voice.title = @"声音";
    voice.type = XMGTopicTypeVoice;
    [self addChildViewController:voice];
    
    XMGTopicViewController *picture = [[XMGTopicViewController alloc] init];
    picture.title = @"图片";
    picture.type = XMGTopicTypePicture;
    [self addChildViewController:picture];
    
    XMGTopicViewController *word = [[XMGTopicViewController alloc] init];
    word.title = @"段子";
    word.type = XMGTopicTypeWord;
    [self addChildViewController:word];

}

- (void)setUpTitleView{

    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    titleView.lh_Width = self.view.lh_Width;
    titleView.lh_Height = XMGTitilesViewH;
    titleView.lh_Y = XMGTitilesViewY;
    [self.view addSubview:titleView];
    self.titlesView = titleView;
    
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.lh_Height = 2;
    indicatorView.lh_Y = titleView.lh_Height - indicatorView.lh_Height;
    
    self.indicatorView = indicatorView;
    
    CGFloat buttonW = self.view.lh_Width/self.childViewControllers.count;
    CGFloat buttonH = titleView.lh_Height;
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        button.lh_X = i*buttonW;
        button.lh_Y = 0;
        button.lh_Width = buttonW;
        button.lh_Height = buttonH;
        
        UIViewController *vc = self.childViewControllers[i];
        [button setTitle:vc.title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:button];
        
        if (i==0) {
            button.enabled = NO;
            self.selectedButton = button;
            
            [button.titleLabel sizeToFit];
            self.indicatorView.lh_Width = button.titleLabel.lh_Width;
            self.indicatorView.lh_CenterX = button.lh_CenterX;
            
        }
    }
    
    [titleView addSubview:indicatorView];
}

- (void)titleClick:(UIButton *)button{

    self.selectedButton.enabled = YES;
    self.selectedButton = button;
    self.selectedButton.enabled = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.indicatorView.lh_Width = button.titleLabel.lh_Width;
        self.indicatorView.lh_CenterX = button.lh_CenterX;
    }];
    
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag*self.contentView.lh_Width;
    [self.contentView setContentOffset:offset animated:YES];
}

- (void)setUpContentView{

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.delegate = self;
    contentView.frame = self.view.bounds;
    contentView.pagingEnabled = YES;
    contentView.contentSize = CGSizeMake(contentView.lh_Width*self.childViewControllers.count, 0);
    [self.view insertSubview:contentView atIndex:0];
    self.contentView = contentView;
    
    [self scrollViewDidEndScrollingAnimation:contentView];
}

- (void)setUpNav{
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagButtonClick)];
    
    self.view.backgroundColor = XMGGlobalBg;
}

- (void)tagButtonClick{
    
    XMGRecommendTagsViewController *recommendTagsVc = [[XMGRecommendTagsViewController alloc] init];
    [self.navigationController pushViewController:recommendTagsVc animated:YES];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{

    NSInteger index = scrollView.contentOffset.x/scrollView.lh_Width;
    
    UITableViewController *vc = self.childViewControllers[index];
    vc.view.lh_X = scrollView.contentOffset.x;
    vc.view.lh_Height = scrollView.lh_Height;
    vc.view.lh_Y = 0;
    
    [scrollView addSubview:vc.view];
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    NSInteger index = scrollView.contentOffset.x/scrollView.lh_Width;
    
    [self titleClick:self.titlesView.subviews[index]];
}


@end
