//
//  HWlllegalReportViewController.m
//  HuaWo
//
//  Created by hwawo on 16/6/7.
//  Copyright © 2016年 HW. All rights reserved.
//

#import "HWlllegalReportViewController.h"
#import "AHCNetworkChangeDetector.h"
#import "NSString+encrypto.h"
#import "MemberData.h"
#import "LoginViewController.h"

#define isLogin [[MemberData memberData] isMemberLogin]
#define kUid [[MemberData memberData] getMemberAccount]
@interface HWlllegalReportViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *reportWebView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@end

@implementation HWlllegalReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = kBackgroundColor;
    self.reportWebView.backgroundColor = kBackgroundColor;
    self.reportWebView.scalesPageToFit = YES;
    self.reportWebView.delegate = self;
    self.reportWebView.opaque = NO;
    [self setUpTitle];
    
    [self setUpLeftNavigationItem];
    
    [self isConnectionAvailable];
    
    [self setUpActivityIndicatorView];
}

- (void)setUpTitle{

    CGFloat screenw = screenW;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0.3*screenw, 12)];
    titleLabel.text = NSLocalizedString(@"violation_of_regulation_and_report", nil);
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
}

- (void)setUpActivityIndicatorView{
    CGFloat screenw = screenW;
    CGFloat screenh = screenH;
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.45*screenw, 0.45*screenh, 50, 50)];
    self.activityIndicator.layer.cornerRadius = 5;
    self.activityIndicator.layer.masksToBounds = YES;
    self.activityIndicator.backgroundColor = [UIColor lightGrayColor];
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:self.activityIndicator];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{

    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

    [self.activityIndicator stopAnimating];
}

- (void)isConnectionAvailable{

    if (![[AHCNetworkChangeDetector sharedNetworkChangeDetector] isNetworkConnected]) {
        
        UILabel *labelTip = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 30)];
        labelTip.text = NSLocalizedString(@"root_controller_network_error_label", nil);
        labelTip.textColor = [UIColor whiteColor];
        labelTip.backgroundColor = [UIColor lightGrayColor];
        labelTip.font = [UIFont systemFontOfSize:12];
        [self.view addSubview:labelTip];
        return ;
    }
    
    [self loadWebPage];
}

- (void)loadWebPage{

        NSString *uidStr = kUid;
        uidStr = [uidStr sha1];
    /*
     
     {"end_date":"2016-06-24","num":"20","order":"desc","order_by_col":"occur_time","page_no":"1","procstate":0,"start_date":"2016-04-24","uid":"30395808B61933E753AF16D9748C3466C2E128E"}
     
     */
        NSString *urlStr = [NSString stringWithFormat:@"%@?uid=%@",kKeyReportUrl,uidStr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
        HWLog(@"--------------%@",[NSURL URLWithString:urlStr]);
        [self.reportWebView loadRequest:request];

}

- (void)setUpLeftNavigationItem{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)leftBarButtonItemAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

+ (instancetype)lllegalReportViewController {

    return [[HWlllegalReportViewController alloc] initWithNibName:@"HWlllegalReportViewController" bundle:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * 让当前控制器对应的状态栏是白色
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
