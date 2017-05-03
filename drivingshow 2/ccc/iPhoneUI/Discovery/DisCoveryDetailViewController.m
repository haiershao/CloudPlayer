//
//  DisCoveryDetailViewController.m
//  HuaWo
//
//  Created by circlely on 2/29/16.
//  Copyright © 2016 circlely. All rights reserved.
//

#import "DisCoveryDetailViewController.h"
#import "ASIHTTPRequest.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import "MBProgressHUD.h"
#import "LoginViewController.h"
#import <CCString/CCString.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

#import "NSString+encrypto.h"
#import "HWTextAlertView.h"
#import "NSString+encrypto.h"
#import "MemberData.h"
#import "NSString+Helper.h"
#import "HWCommentView.h"
#import "HWUserInstanceInfo.h"
#import "MBProgressHUD+MG.h"
#define kUid [[MemberData memberData] getMemberAccount]
#define kNickName [[MemberData memberData] getMemberNickName]

typedef void (^CompletionBlock)(void);
typedef void (^FailureBlock)(NSError *error);


@interface DisCoveryDetailViewController ()<UIWebViewDelegate,UIActionSheetDelegate, UITextViewDelegate, HWCommentViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) NSString *videoUrl;
/**
 *  面板
 */
@property (nonatomic, strong) UIView *panelView;
/**
 *  加载视图
 */
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@property (strong, nonatomic) MBProgressHUD *hud;
@property (nonatomic, strong) HWTextAlertView *textAlertView;
@property (nonatomic, copy) NSString *alarmId;
@property (strong, nonatomic) UIAlertController *alertCommentVc;
@property (strong, nonatomic) UIAlertView *alertBindQuery;
@property (nonatomic, strong) HWCommentView *commentView;

@end

@implementation DisCoveryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = kBackgroundColor;
    [self setUpWebView];
    
    [self setUpNav];

    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height/2, self.view.bounds.size.width, 2)];
}

- (void)setUpNav {

    self.navigationController.navigationBar.barTintColor = kNavigation7Color;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    //注册键盘出现的通知
    [DZNotificationCenter addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失的通知
    [DZNotificationCenter addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *)note {

    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat screenh = screenH;
    self.commentView.y = screenh - (self.commentView.frame.size.height + frame.size.height);
    
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded]; 
    }];
}

- (void)keyboardWillBeHidden:(NSNotification *)note{
    
    CGFloat screenh = screenH;
    self.commentView.y = screenh + self.commentView.frame.size.height;
    
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)dealloc{

    [DZNotificationCenter removeObserver:self];
}

- (void)setUpWebView{

    self.webView.backgroundColor = kBackgroundColor;
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    self.webView.opaque = NO;
    self.webView.scrollView.decelerationRate = 0.1;
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.scrollEnabled = YES;
    self.webView.autoresizingMask = UIViewAutoresizingNone;
    
    self.webView.allowsInlineMediaPlayback = YES;
    self.webView.mediaPlaybackRequiresUserAction = NO;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.requestUrl];
    [self.webView loadRequest:request];
}

- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)addRightBarButton {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_more"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPressed)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
}

- (void)rightBarButtonItemPressed {
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"callRightMenu()"];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"quit_btn", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"collection_lable", nil),NSLocalizedString(@"save_btn", nil),NSLocalizedString(@"remove_btn", nil), nil];
    
    [actionSheet showInView:self.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    HWLog(@"requestUrl[%@]",request.URL);
    
    return [self AnalysisURL:request.URL];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.titleView = titleLabel;
}

- (BOOL)AnalysisURL:(NSURL*)url {
    
    NSString *categoryUrl = @"category.html";
    NSString *requestUrl = [NSString stringWithFormat:@"%@",url];
    requestUrl = [requestUrl decodeFromPercentEscapeString:requestUrl];
    NSRange foundObject = [requestUrl rangeOfString:categoryUrl];
    
    if (foundObject.location == NSNotFound) {
        
        [self addRightBarButton];
    }
    
    NSString* info = url.absoluteString;
    HWLog(@"url[%@]",url);
    HWLog(@"info[%@]",info);
    
    APP_LOG_INF(@"start Analysis url [%@]", info);
    
#define K_READY_GET_INFO @"iosgetinfo:"
#define K_IOSALERT @"iosalert:"
#define K_IOS_SHARE @"iosshare:"
#define K_IOS_NOLOGIN @"iosnologin:"
#define K_IOS_COMMENT @"ioscomment:"
    NSArray* schemes = [NSArray arrayWithObjects:K_READY_GET_INFO, K_IOSALERT, K_IOS_SHARE,K_IOS_NOLOGIN, K_IOS_COMMENT,nil];

    //解码
    NSString* packageinfo = [info stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    HWLog(@"-------------packageinfo------------------%@",packageinfo);
    NSString* curScheme = nil;
    
    for (NSString* scheme in schemes) {
        HWLog(@"---substring---%@",[packageinfo substringToIndex:scheme.length]);
        if (packageinfo.length >= scheme.length && [[packageinfo substringToIndex:scheme.length] isEqualToString:scheme]) {
            
            curScheme = scheme;
            break;
        }
    }
    
    
    if (!curScheme) {
        
        return YES;
    }
    
    NSError *error = nil;
    
    id infoobj = [NSJSONSerialization JSONObjectWithData:[[packageinfo substringFromIndex:curScheme.length] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    HWLog(@"----------infoobj-----------%@",infoobj);
    HWLog(@"----------infoobj[@""]-----------%@",infoobj[@"videoid"]);
    self.alarmId = infoobj[@"videoid"];
    if (error) {
        
        return YES;
    }
    
    
    if([curScheme isEqualToString:K_READY_GET_INFO]){
        
        self.videoUrl = [infoobj objectForKey:@"videoUrl"];
        
        return NO;
    }
//    else if ([curScheme isEqualToString:K_IOS_NOLOGIN]){
//        
//        [self noLoginAlert];
//        return NO;
//    }
    else if([curScheme isEqualToString:K_IOS_SHARE]){

        [self share:infoobj[@"href"]];
        return NO;
    }
    
    else if ([curScheme isEqualToString:K_IOSALERT]) {
        
        if ([[infoobj objectForKey:@"result"] isEqualToString:@"success"]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES configBlock:^(MBProgressHUD *HUD) {
                
                HUD.removeFromSuperViewOnHide = YES;
                HUD.mode = MBProgressHUDModeText;
                HUD.detailsLabelText = @"操作成功";
                [HUD hide:YES afterDelay:2];
            }];
        }else{
            
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES configBlock:^(MBProgressHUD *HUD) {
                
                HUD.removeFromSuperViewOnHide = YES;
                HUD.mode = MBProgressHUDModeText;
                HUD.detailsLabelText = @"操作失败";
                [HUD hide:YES afterDelay:2];
            }];
            
        }
        
        return NO;
    }else if ([curScheme isEqualToString:K_IOS_COMMENT]){
    
        HWLog(@"--------------comment-------------------------------------");
        [self popTextAlertView];
    }
    
    return YES;
    
}

- (void)popTextAlertView {
    
    self.commentView = [HWCommentView commentView];
    self.commentView.delegate = self;
    [self.commentView.commentTextField becomeFirstResponder];
    CGFloat screenh = screenH;
    CGFloat screenw = screenW;
    self.commentView.frame = CGRectMake(0, screenh, screenw, self.commentView.frame.size.height);
    [self.view addSubview:self.commentView];
}

- (void)commentView:(HWCommentView *)commentView commentText:(UITextField *)commentTextField{

    HWLog(@"---%@",commentTextField.text);
    [self composeContent:commentTextField.text];
}

- (void)alertViewBtnClick{
    HWLog(@"----------------------------------");
    HWLog(@"-----%@",self.textAlertView.textview.text);
    [self.textAlertView.commentTextField endEditing:YES];
}



- (void)composeContent:(NSString *)comment{
__typeof(self) __weak safeSelf = self;
//    [self.textAlertView.commentTextField endEditing:YES];
//    [self.textAlertView closeTextAlertView];
    
    HWUserInstanceInfo *instanceInfo = [HWUserInstanceInfo shareUser];
    NSDictionary *dict = @{
                           @"content":comment,
                           @"videoid":self.alarmId,
                           @"nickname":instanceInfo.nickname
                           };
    
    APIRequest *request = [[APIRequest alloc] initWithApiPath:@"/ControlCenter/v3/restapi/doaction" method:APIRequestMethodPost];
    request.urlQueryParameters = @{
                                   @"action":@"add_remark",
                                   @"para":dict,
                                   @"token":instanceInfo.token
                                   };
    NSLog(@"request---%@",request);
    [[APIRequestOperationManager sharedRequestOperationManager] requestAPI:request completion:^(id result, NSError *error) {
        if (result[@"result"]&&!result[@"data"]) {
           
            [MBProgressHUD showSuccess:@"评论成功"];
                            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:safeSelf.requestUrl];
            
                            [self.webView loadRequest:request];
                        }
                        else{
                            
                        [MBProgressHUD showError:@"评论失败"];
                        }
                    }];
    
        }
        
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    HWLog(@"----%ld",(long)buttonIndex);
}

- (void)cancelBtnClick {

    [self.textAlertView.commentTextField endEditing:YES];
}

// 3.18 add start --- by mj
- (void)share:(NSString *)urlStr{
    
    HWLog(@"==%@",urlStr);
    //http://find.hwawo.com:28080/find/share.html?alarmId=8a209626576a517701577b80cf570024%22%7D
    //http://find.hwawo.com:28080/find/share.html?alarmId=8a209626576a517701577b80cf570024
    HWLog(@"%@",[NSURL URLWithString:urlStr]);
    NSString *nickName = deviceNickName;
//    NSString *nickName = @"";
    NSString *str = [urlStr componentsSeparatedByString:@"title="].lastObject;
    NSString *strUrl = [urlStr componentsSeparatedByString:@"title"].firstObject;
    NSString *String = [NSString stringWithFormat:@"%@%@",str,strUrl];
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    __weak DisCoveryDetailViewController *theController = self;
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"AppIcon120.png"]];
    [shareParams SSDKSetupShareParamsByText:String
                                     images:imageArray
                                        url:[NSURL URLWithString:[urlStr componentsSeparatedByString:@"title"].firstObject]
                                      title:nickName
                                       type:SSDKContentTypeAuto];
    
    HWLog(@"--------------------%@",[NSURL URLWithString:urlStr]);
    //1.2、自定义分享平台（非必要）
    NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:[ShareSDK activePlatforms]];
    //添加一个自定义的平台（非必要）
    SSUIShareActionSheetCustomItem *item = [SSUIShareActionSheetCustomItem itemWithIcon:[UIImage imageNamed:@"Icon.png"]
                                                                                  label:@"自定义"
                                                                                onClick:^{
                                                                                    
                                                                                    //自定义item被点击的处理逻辑
                                                                                    HWLog(@"=== 自定义item被点击 ===");
                                                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"自定义item被点击"
                                                                                                                                        message:nil
                                                                                                                                       delegate:nil
                                                                                                                              cancelButtonTitle:@"确定"
                                                                                                                              otherButtonTitles:nil];
                                                                                    [alertView show];
                                                                                }];
    [activePlatforms addObject:item];
    
    //2、分享
    [ShareSDK showShareActionSheet:self.view
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
                           [theController showLoadingView:YES];
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           //Facebook Messenger、WhatsApp等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
                           if (platformType == SSDKPlatformTypeFacebookMessenger)
                           {
                               break;
                           }
                           
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信。"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用；"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       default:
                           break;
                   }
                   
                   if (state != SSDKResponseStateBegin)
                   {
                       [theController showLoadingView:NO];
                       
                   }
                   
               }];
    
}

/**
 *  显示加载动画
 *
 *  @param flag YES 显示，NO 不显示
 */
- (void)showLoadingView:(BOOL)flag{
    if (flag)
    {
        [self.view addSubview:self.panelView];
        [self.loadingView startAnimating];
    }
    else
    {
        [self.panelView removeFromSuperview];
    }
}

//3.18 add end --- by mj
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        [self.webView stringByEvaluatingJavaScriptFromString:@"addFavorite()"];
    }
    
    else if (buttonIndex == 1) {
        
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES configBlock:^(MBProgressHUD *HUD) {
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.removeFromSuperViewOnHide = YES;
            //HUD.customView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            //[((UIActivityIndicatorView *)HUD.customView) startAnimating];
            HUD.customView = self.progressView;
            
        }];

        [self saveToLocalAlbumWithCompletionBlock:^{
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
            hud.detailsLabelText = NSLocalizedString(@"warnning_save_successfully", nil);
            [hud hide:YES afterDelay:2];
            
        } failureBlock:^(NSError *error) {
            
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warning"]];
            hud.detailsLabelText = NSLocalizedString(@"warnning_save_photo_failed", nil);
            [hud hide:YES afterDelay:2];
            
        }];

        
        
    }
    
    else if (buttonIndex == 2) {
        
        [self.webView stringByEvaluatingJavaScriptFromString:@"deleteFavorite()"];
    }
    
}

- (void)saveToLocalAlbumWithCompletionBlock:(CompletionBlock)aCompletionBlock
                               failureBlock:(FailureBlock)aFailureBlock{
    
    NSString *videoUrl = self.videoUrl;
    
    NSString *moviePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[videoUrl lastPathComponent]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:videoUrl]];
    [request setDownloadDestinationPath:moviePath];
    
    [request startAsynchronous];
    [request setDownloadProgressDelegate:self.progressView];
    [request setFailedBlock:^{
        
        if (aFailureBlock) {
            aFailureBlock(nil);
        }
        
    }];
    
    [request setCompletionBlock:^{
        
        //        __block NSString *tempAlbumName = @"HuaWoVideo";
        
        ALAssetsLibrary* assetLib = [[ALAssetsLibrary alloc] init];
        
        [assetLib writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:moviePath] completionBlock:^(NSURL *assetURL, NSError *error) {
            
            if (error) {
                
                
                HWLog(@"writeVideoAtPathToSavedPhotosAlbum error[%@]", [error description]);
                
                if (aFailureBlock) {
                    aFailureBlock(error);
                }
                
                return;
            }
            
            __block BOOL isAthomeGroupFound = NO;
            
            
            //遍历所有分组
            [assetLib enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                
                //找到tempAlbumName
                if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"HuaWoVideo0"]) {
                    
                    
                    isAthomeGroupFound = YES;
                    *stop = YES;
                    
                    
                    [assetLib assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        
                        [group addAsset:asset];
                        
                        //dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (aCompletionBlock) {
                            
                            aCompletionBlock();
                        }
                        
                        
                        // });
                        
                        
                        
                    }
                             failureBlock:^(NSError *error) {
                                 
                                 //dispatch_async(dispatch_get_main_queue(), ^{
                                 
                                 if (aFailureBlock) {
                                     aFailureBlock(error);
                                 }
                                 
                                 //});
                                 
                                 
                             }];
                    
                    return;
                    
                }
                
                
                //如果没有找到tempAlbumName,就需要先创建tempAlbumName
                if (!group && !isAthomeGroupFound){
                    
                    [assetLib addAssetsGroupAlbumWithName:@"HuaWoVideo0" resultBlock:^(ALAssetsGroup *group) {
                        
                        
                        [assetLib assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                            
                            [group addAsset:asset];
                            
                            //dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (aCompletionBlock) {
                                
                                aCompletionBlock();
                            }
                            
                            
                            //});
                            
                        }
                                 failureBlock:^(NSError *error) {
                                     //dispatch_async(dispatch_get_main_queue(), ^{
                                     
                                     if (aFailureBlock) {
                                         aFailureBlock(error);
                                     }
                                     
                                     //});
                                 }];
                        
                    }
                                             failureBlock:^(NSError *error) {
                                                 
                                                 //dispatch_async(dispatch_get_main_queue(), ^{
                                                 
                                                 if (aFailureBlock) {
                                                     aFailureBlock(error);
                                                 }
                                                 
                                                 //});
                                                 
                                             }];
                }
                
                
            }
                                  failureBlock:^(NSError *error) {
                                      //dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      if (aFailureBlock) {
                                          aFailureBlock(error);
                                      }
                                      
                                      //});
                                  }];
        }];
        
    }];
    
}


- (void)noLoginAlert {
    
    
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    [[RDVTabBarController shareTabBar] setTabBarHidden:YES animated:NO];
    
    [self.navigationController pushViewController:loginViewController animated:YES];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请先登录后再执行下面的操作" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    
//    [alert show];
}




/**
 * 让当前控制器对应的状态栏是白色
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
