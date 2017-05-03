//
//  XMGLoginRegisterViewController.m
//  百思不得姐
//
//  Created by hwawo on 16/7/6.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGLoginRegisterViewController.h"

@interface XMGLoginRegisterViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMargin;
@end

@implementation XMGLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

+ (instancetype)loginRegisterViewController{

    return [[XMGLoginRegisterViewController alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleLightContent;
}
- (IBAction)showLoginorRegister:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.loginViewLeftMargin.constant == 0) {
        self.loginViewLeftMargin.constant = - self.view.lh_Width;
        sender.selected = YES;
    }else{
        self.loginViewLeftMargin.constant = 0;
        sender.selected = NO;
    }
    
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
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
