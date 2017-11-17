//
//  XMGVideoViewController.m
//  Cloud Player
//
//  Created by jiyi on 2017/11/17.
//  Copyright © 2017年 ichano. All rights reserved.
//

#import "XMGVideoViewController.h"

@interface XMGVideoViewController ()

@end

@implementation XMGVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

+ (instancetype)videoViewController{
    
    return [[XMGVideoViewController alloc] initWithNibName:@"XMGVideoViewController" bundle:nil];
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
