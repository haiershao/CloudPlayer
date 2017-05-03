//
//  ChangeNickNameViewController.m
//  HuaWo
//
//  Created by circlely on 2/24/16.
//  Copyright © 2016 circlely. All rights reserved.
//

#import "ChangeNickNameViewController.h"
#import "MBProgressHUD.h"
#import "MemberData.h"
#import "HWUserInstanceInfo.h"
#import "MBProgressHUD+MG.h"
@interface ChangeNickNameViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *customBackView;
@property (weak, nonatomic) IBOutlet UIButton *confrimButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) UIAlertView *alertPersionInfo;
@property (strong, nonatomic) MBProgressHUD *hud;
@end

@implementation ChangeNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpNav];
    
    [self setUpTextField];
    
    [self createConfirmButton];
    
}

- (void)createConfirmButton{

    self.confrimButton.layer.masksToBounds = YES;
    self.confrimButton.layer.cornerRadius = 5;
    [self.confrimButton setTitle:NSLocalizedString(@"save_btn", nil) forState:UIControlStateNormal];
}

- (void)setUpTextField{

    self.textField.text = [HWUserInstanceInfo shareUser].nickname;
    self.textField.backgroundColor = kTableViewCellColor;
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"user_info_change_nickname_hint", nil) attributes:@{NSForegroundColorAttributeName : [UIColor grayColor]}];
    self.textField.textColor = [UIColor whiteColor];
    self.textField.textAlignment = NSTextAlignmentLeft;
    self.textField.delegate = self;
    
}

- (void)setUpNav{

    self.customBackView.backgroundColor = kTableViewCellColor;
    self.view.backgroundColor = kBackgroundColor;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction)];
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setHidesBackButton:YES];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"user_info_change_nickname", nil);
    self.navigationItem.titleView = titleLabel;
}

- (IBAction)saveButtonPressed:(id)sender {
    HWUserInstanceInfo* InstanceInfo = [HWUserInstanceInfo shareUser];
    if (!self.textField.text.length) {
        [self.textField becomeFirstResponder];
        return;
    }
    __weak typeof(self) weakself = self;
    NSDictionary *dict = @{
                           @"nickname":self.textField.text,
                              };
    
    APIRequest *request = [[APIRequest alloc] initWithApiPath:@"/ControlCenter/v3/restapi/doaction" method:APIRequestMethodPost];
    request.urlQueryParameters = @{
                                   @"action":@"user_modifyinfo",
                                   @"para":dict,
                                   @"token":InstanceInfo.token
                                   };
    NSLog(@"request---%@",request);
    [[APIRequestOperationManager sharedRequestOperationManager] requestAPI:request completion:^(id result, NSError *error) {
       
            [MBProgressHUD showSuccess:@"修改成功"];
        
        [weakself UserNickNameRegisterGet];
        
    }];

    
    
    
    
//    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES configBlock:^(MBProgressHUD *HUD) {
//        HUD.removeFromSuperViewOnHide = YES;
//    }];
//    NSString *urlStr = [NSString stringWithFormat:@"http://112.124.22.101:8190/user/updateNickname?deviceid=%@&nickname=%@",identifierForVendor,self.textField.text];
////    NSString *urlStr = [NSString stringWithFormat:@"http://192.168.0.29:8080/user/updateNickname?deviceid=%@&nickname=%@",identifierForVendor,self.textField.text];
//    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url = [NSURL URLWithString:urlStr];
//    
//    // 2. 请求
//   // NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:1 timeoutInterval:2.0f];
//    
//    // 3. 连接
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//    self.alertPersionInfo = alert;
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        
//        // 反序列化
//        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//        
//        NSLog(@"result---%@--%@", result,result[@"code"]);
//        NSString *str0 = [NSString stringWithFormat:@"%@",result[@"code"]];
//        
//        if ([str0 isEqualToString:@"1"]) {
//            [self.hud hide:YES];
//            
//            self.alertPersionInfo.message = @"昵称修改成功";
//            self.alertPersionInfo.title = @"✅";
//            [self.alertPersionInfo show];
//            
//        }else{
//            HWLog(@"===================");
//            [self.hud hide:YES];
//            self.alertPersionInfo.message = @"修改失败";
//            self.alertPersionInfo.title = @"❌";
//            [self.alertPersionInfo show];
//        }
//    }];
    
    
}
- (void)UserNickNameRegisterGet {
    HWUserInstanceInfo* InstanceInfo = [HWUserInstanceInfo shareUser];
    APIRequest *request = [[APIRequest alloc] initWithApiPath:@"/ControlCenter/v3/restapi/doaction" method:APIRequestMethodPost];
    request.urlQueryParameters = @{
                                   @"action":@"dev_getstatus",
                                   @"token":InstanceInfo.token
                                   };
    NSLog(@"request---%@",request);
    [[APIRequestOperationManager sharedRequestOperationManager] requestAPI:request completion:^(id result, NSError *error) {
        // NSDictionary *dict = result[@"data"][@"nickname"];
        HWUserInstanceInfo *account = [HWUserInstanceInfo accountWithDict:result];
        [self backMyUi];
        NSLog(@"------接口结果%@-----%@",result,error);
    }];
    
}
- (void)backMyUi{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftBarButtonItemAction {
    
   // [self.navigationController popViewControllerAnimated:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
    
}

/**
 * 让当前控制器对应的状态栏是白色
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
