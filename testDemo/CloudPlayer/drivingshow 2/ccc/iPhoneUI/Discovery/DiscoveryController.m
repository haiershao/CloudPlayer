//
//  DiscoveryController.m
//  HuaWo
//
//  Created by circlely on 1/20/16.
//  Copyright © 2016 circlely. All rights reserved.
//

#import "DiscoveryController.h"
#import "DisCoveryDetailViewController.h"
#import "MemberData.h"
#import <CCString/CCString.h>
#import "LoginViewController.h"
#import "NSString+encrypto.h"
#import "NSString+Helper.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

#define isLogin [[MemberData memberData] isMemberLogin]
#define kUid [[MemberData memberData] getMemberAccount]
#define kNickName [[MemberData memberData] getMemberNickName]
@interface DiscoveryController()<UIWebViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *request;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGestureRecognizerUp;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGestureRecognizerDown;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
/**
 *  面板
 */
@property (nonatomic, strong) UIView *panelView;
@end

@implementation DiscoveryController

- (void)webViewDidStartLoad:(UIWebView *)webView{
    HWLog(@"WebViewRequest*%@*",webView.request);
    
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = kBackgroundColor;
    
    
    [self setUpWebView];
    
    //判断是否已登陆
    [self Login];
    
    
    //添加监听
    [self addNotification];

    [self setUpActivityIndicatorView];
    
}

- (void)Login{

//    if ([[MemberData memberData] isMemberLogin]) {
//        
//        _request = [NSString stringWithFormat:@"%@?uid=%@",kDiscoveryPageUrl,[[MemberData memberData] getMemberAccount]];
//        HWLog(@"---%@",kDiscoveryPageUrl);
//        NSMutableURLRequest *requesturl = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_request]];
//        
//        HWLog(@"-------%@",requesturl);
//        [self.webView loadRequest:requesturl];
//    }else{
    
        _request = kDiscoveryPageUrl;
        
        NSMutableURLRequest *requesturl = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_request]];
        
        [self.webView loadRequest:requesturl];
//        
//    }
}

- (void)addNotification{

    [DZNotificationCenter addObserver:self selector:@selector(loginSuccess) name:KLoginSucceed object:nil];
    
    [DZNotificationCenter addObserver:self selector:@selector(logoutSuccess) name:KLoginOutMsg object:nil];
}

- (void)setUpWebView{

    self.webView.backgroundColor = kBackgroundColor;
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    self.webView.opaque = NO;
    self.webView.scrollView.decelerationRate = 0.1;
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.autoresizingMask = UIViewAutoresizingNone;
    
    self.webView.allowsInlineMediaPlayback = YES;
    self.webView.mediaPlaybackRequiresUserAction = NO;
}

- (void)setUpActivityIndicatorView{
    CGFloat screenw = screenW;
    CGFloat screenh = screenH;
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.42*screenw, 0.1*screenh, 50, 50)];
    self.activityIndicator.layer.cornerRadius = 5;
    self.activityIndicator.layer.masksToBounds = YES;
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:self.activityIndicator];
}

- (void)logoutSuccess {
    
    _request = kDiscoveryPageUrl;
    
    NSMutableURLRequest *requesturl = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_request]];
    
    [self.webView loadRequest:requesturl];
}

- (void)loginSuccess {
    
    _request = [NSString stringWithFormat:@"%@?uid=%@",kDiscoveryPageUrl,[[MemberData memberData] getMemberAccount]];
    
    NSMutableURLRequest *requesturl = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_request]];
    
    [self.webView loadRequest:requesturl];

}

- (void)viewWillAppear:(BOOL)animated {
    [[RDVTabBarController shareTabBar] setTabBarHidden:NO animated:NO];
    self.navigationController.navigationBarHidden = YES;
}

#pragma - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    HWLog(@"WebViewRequest[%@]--%@",webView.request, request.URL);
    NSString *requestUrl = [NSString stringWithFormat:@"%@",request.URL];
    
//        if (isLogin) {
      requestUrl = [NSString stringWithFormat:@"%@",request.URL];
    
        if (webView.request.URL && ![requestUrl isEqualToString:_request]) {
            
            if ([requestUrl rangeOfString:@"iosshare:"].location == !NSNotFound) {
                
                DisCoveryDetailViewController *detail = [[DisCoveryDetailViewController alloc] initWithNibName:@"DisCoveryDetailViewController" bundle:nil];
                
                NSString *str = [[requestUrl componentsSeparatedByString:@"="] lastObject];
                
                //                NSString *urlString = [NSString stringWithFormat:@"%@:28080/find/share.html?alarmId=%@",kUrlHead,str];
                NSString *urlString = [NSString stringWithFormat:@"%@",str];
                
                urlString = [urlString decodeFromPercentEscapeString:requestUrl];
                urlString = [urlString componentsSeparatedByString:@"http"].lastObject;
                urlString = [NSString stringWithFormat:@"http%@",urlString];
                urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                urlString = [urlString substringToIndex:urlString.length - 2];
                
                HWLog(@"----%@",urlString);
                
                [detail share:urlString];
                //                [self share:requestUrl];
            }else{
            
                DisCoveryDetailViewController *detail = [[DisCoveryDetailViewController alloc] initWithNibName:@"DisCoveryDetailViewController" bundle:nil];
                [[RDVTabBarController shareTabBar] setTabBarHidden:YES animated:NO];
                detail.requestUrl = [NSURL URLWithString:requestUrl];
                [self.navigationController pushViewController:detail animated:YES];
                //[[RDVTabBarController shareTabBar] setTabBarHidden:NO animated:YES];
            }
            
            
            
            

            return NO;
            
        }
//    }else{
//        requestUrl = [NSString stringWithFormat:@"%@",request.URL];
//        if (webView.request.URL && ![requestUrl isEqualToString:_request]) {
//    
//            [[RDVTabBarController shareTabBar] setTabBarHidden:YES animated:NO];
//            LoginViewController *loginVc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//            
//            [self.navigationController pushViewController:loginVc animated:YES];
//            return NO;
//        }
//    }
    
    return YES;
}

/**
 * 让当前控制器对应的状态栏是白色
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleLightContent;
}

//- (void)share:(NSString *)urlStr{
//    
//    NSString *str = [[urlStr componentsSeparatedByString:@"="] lastObject];
//    NSString *urlString = [NSString stringWithFormat:@"%@/find/share.html?alarmId=%@",kUrlHead,str];
//    NSString *nickName = kNickName;
//    /**
//     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
//     **/
//    __weak DiscoveryController *theController = self;
//    
//    //1、创建分享参数（必要）
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//    NSArray* imageArray = @[[UIImage imageNamed:@"appIcon120.png"]];
//    [shareParams SSDKSetupShareParamsByText:@"啥也不想说，先看视频吧！！！"
//                                     images:imageArray
//                                        url:[NSURL URLWithString:urlString]
//                                      title:nickName
//                                       type:SSDKContentTypeAuto];
//    HWLog(@"--------------------%@",[NSURL URLWithString:urlStr]);
//    //1.2、自定义分享平台（非必要）
//    NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:[ShareSDK activePlatforms]];
//    //添加一个自定义的平台（非必要）
//    SSUIShareActionSheetCustomItem *item = [SSUIShareActionSheetCustomItem itemWithIcon:[UIImage imageNamed:@"Icon.png"]
//                                                                                  label:@"自定义"
//                                                                                onClick:^{
//                                                                                    
//                                                                                    //自定义item被点击的处理逻辑
//                                                                                    HWLog(@"=== 自定义item被点击 ===");
//                                                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"自定义item被点击"
//                                                                                                                                        message:nil
//                                                                                                                                       delegate:nil
//                                                                                                                              cancelButtonTitle:@"确定"
//                                                                                                                              otherButtonTitles:nil];
//                                                                                    [alertView show];
//                                                                                }];
//    [activePlatforms addObject:item];
//    
//    //2、分享
//    
//    [ShareSDK showShareActionSheet:self.view
//                             items:nil
//                       shareParams:shareParams
//               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                   
//                   switch (state) {
//                           
//                       case SSDKResponseStateBegin:
//                       {
//                           [theController showLoadingView:YES];
//                           break;
//                       }
//                       case SSDKResponseStateSuccess:
//                       {
//                           //Facebook Messenger、WhatsApp等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
//                           if (platformType == SSDKPlatformTypeFacebookMessenger)
//                           {
//                               break;
//                           }
//                           
//                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                               message:nil
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"确定"
//                                                                     otherButtonTitles:nil];
//                           [alertView show];
//                           break;
//                       }
//                       case SSDKResponseStateFail:
//                       {
//                           if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
//                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:@"失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信。"
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
//                               break;
//                           }
//                           else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
//                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:@"失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用；"
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
//                               break;
//                           }
//                           else
//                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:[NSString stringWithFormat:@"%@",error]
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
//                               break;
//                           }
//                           break;
//                       }
//                       case SSDKResponseStateCancel:
//                       {
//                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
//                                                                               message:nil
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"确定"
//                                                                     otherButtonTitles:nil];
//                           [alertView show];
//                           break;
//                       }
//                       default:
//                           break;
//                   }
//                   
//                   if (state != SSDKResponseStateBegin)
//                   {
//                       [theController showLoadingView:NO];
//                       
//                   }
//                   
//               }];
//    
//}
//
///**
// *  显示加载动画
// *
// *  @param flag YES 显示，NO 不显示
// */
//- (void)showLoadingView:(BOOL)flag{
//    if (flag)
//    {
//        [self.view addSubview:self.panelView];
//        [self.loadingView startAnimating];
//    }
//    else
//    {
//        [self.panelView removeFromSuperview];
//    }
//}
@end
