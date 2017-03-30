//
//  XMGAddTagToolbar.m
//  百思不得姐
//
//  Created by hwawo on 16/7/22.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGAddTagToolbar.h"
#import "XMGAddTagViewController.h"
@interface XMGAddTagToolbar ()

/** 顶部控件 */
@property (weak, nonatomic) IBOutlet UIView *topView;
@end
@implementation XMGAddTagToolbar

- (void)awakeFromNib{

    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [addButton setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    addButton.lh_X = XMGTopicCellMargin;
    addButton.lh_Size = addButton.currentImage.size;
    [self.topView addSubview:addButton];
}

- (void)addButtonClick{

    XMGLogFunc;
    XMGAddTagViewController *addTagVc = [[XMGAddTagViewController alloc] init];
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController *)rootVc.presentedViewController;
    [nav pushViewController:addTagVc animated:YES];
}

@end
