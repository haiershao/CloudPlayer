//
//  HWGetUserInfo.m
//  HuaWo
//
//  Created by hwawo on 16/12/13.
//  Copyright © 2016年 HW. All rights reserved.
//

#import "HWGetUserInfo.h"
#import "Reachability.h"
@interface HWGetUserInfo ()
@property (copy, nonatomic) NSString *nickname;
@property (strong, nonatomic) HWGetUserInfo *getUserInfo;
@end
static HWGetUserInfo *getUserInfo = nil;
@implementation HWGetUserInfo

+ (HWGetUserInfo *)getUserInfo{

    if (!getUserInfo) {
        getUserInfo = [[HWGetUserInfo alloc] init];
    }
    return getUserInfo;
}

-(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //HWLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //HWLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //HWLog(@"3G");
            break;
    }
    
    if (!isExistenceNetwork) {
        //<span style="font-family: Arial, Helvetica, sans-serif;">MBProgressHUD为第三方库，不需要可以省略或使用AlertView</span>
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES configBlock:nil];
//        hud.removeFromSuperViewOnHide =YES;
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"当前网络不可用，请检查网络连接";  //提示的内容
//        hud.minSize = CGSizeMake(132.f, 108.0f);
//        [hud hide:YES afterDelay:3];
        return NO;
    }
    
    return isExistenceNetwork;
}

//自动注册
- (NSString *)requestDeviceNickName{
    
    if (![self isConnectionAvailable]) {
        return @"";
    }
    
    //    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    //http://112.124.22.101:38080/illegalreport/restapi/cidbinduser
    //    NSString *identityno = self.identityCardText;
    //    NSString *name = self.userRealNameText;
    //    NSString *phonenumber = self.plateNumberText;
    //    NSString *licenseno = self.emailAddressText;
    //    NSString *email = self.zhifuAccountText;
    
    NSString *urlStr = [NSString stringWithFormat:@"http://112.124.22.101:8190/user/registerDeviceInfo?deviceid=%@",identifierForVendor];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2. 请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:1 timeoutInterval:2.0f];
    __typeof(self) __weak safeSelf = self;
    // 3. 连接
    __block BOOL isReceviedSucess = YES;
    __block NSString *nickName = nil;
    HWLog(@"--------------------------------------------------------------------");
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (!connectionError) {
            // 反序列化
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            
            NSLog(@"result---%@--%@", result,result[@"desc"]);
            NSString *str0 = [NSString stringWithFormat:@"%@",result[@"desc"]];
            if ([str0 isEqualToString:@"success"]) {
                
                nickName = result[@"nickname"];
                HWLog(@"===getNickName============%@",nickName);
                isReceviedSucess = NO;
                
            }else{
                
                HWLog(@"===getNickName============");
            }
        }
        
    }];
    
    HWLog(@"===getNickName============**%d",isReceviedSucess);
    
        while(isReceviedSucess){
            HWLog(@"[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]");
            
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            
        }
    
    HWLog(@"===getNickName============88%@",nickName);
    
   return nickName;
}

+ (NSString *)getDeviceNickname{

    HWLog(@"=======%@",[[HWGetUserInfo getUserInfo] requestDeviceNickName]);
    
    return [[self alloc] requestDeviceNickName];
}
@end
