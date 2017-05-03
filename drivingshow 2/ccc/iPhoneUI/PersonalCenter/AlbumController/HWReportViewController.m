//
//  HWReportViewController.m
//  HuaWo
//
//  Created by yjc on 2017/4/13.
//  Copyright © 2017年 HW. All rights reserved.
//

#import "HWReportViewController.h"
#import "HWReportCell.h"
@interface HWReportViewController ()
@property (strong, nonatomic) IBOutlet UIView *tableView;

@end

@implementation HWReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
     //[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWReportCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HWReportCell class])];
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
