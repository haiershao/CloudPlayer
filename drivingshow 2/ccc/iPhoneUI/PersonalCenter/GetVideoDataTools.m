//
//  GetVideoDataTools.m
//  ioshuanwu
//
//  Created by 幻音 on 15/12/28.
//  Copyright © 2015年 幻音. All rights reserved.
//

#import "GetVideoDataTools.h"
#import "VideoSid.h"
#import "Video.h"
#import "MJExtension.h"
#import "HWUserInstanceInfo.h"
@implementation GetVideoDataTools

+ (instancetype)shareDataTools
{
    static GetVideoDataTools *gd = nil;
    static dispatch_once_t token;
    if (gd == nil) {
        dispatch_once(&token, ^{
            gd = [[GetVideoDataTools alloc] init];
        });
    }
    return gd;
}

- (void)getHeardDataWithURL:(NSString *)URL HeardValue:(HeardValue)heardValue
{
    NSMutableArray *heardArray = [NSMutableArray array];
    HWUserInstanceInfo* InstanceInfo = [HWUserInstanceInfo shareUser];
    NSString *nowTime = [self timeOfNow];
    NSDictionary *dict = @{
                           @"sdate": @"20150810",
                           @"edate":nowTime,
                           @"num": @"3",
                           @"pno": @"1",
                           @"uid":@"-1",
                           @"vtype":@"1",
                           @"orderby":@"gentime",
                           @"order":@"desc",
                           @"option":@"1"
                           };
    APIRequest *request = [[APIRequest alloc] initWithApiPath:@"/ControlCenter/v3/restapi/doaction" method:APIRequestMethodPost];
    request.urlQueryParameters = @{
                                   @"action":@"qry_videolist",
                                   @"para":dict,
                                   @"token":InstanceInfo.token
                                   };
    NSLog(@"request---%@",request);
    [[APIRequestOperationManager sharedRequestOperationManager] requestAPI:request completion:^(id result, NSError *error) {
       
        
        
        NSMutableArray *videoSidList = [Video mj_objectArrayWithKeyValuesArray:result[@"data"][@"datalist"]];
       
         [self.dataArray addObjectsFromArray:videoSidList];
        heardValue(heardArray,videoSidList);
        
    }];

    
//    dispatch_queue_t global_t = dispatch_get_global_queue(0, 0);
//    dispatch_async(global_t, ^{
//        NSURL *url = [NSURL URLWithString:URL];
//        NSMutableArray *heardArray = [NSMutableArray array];
//        NSMutableArray *videoArray = [NSMutableArray array];
//        
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//        request.HTTPMethod = @"POST";
//        
//        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        NSString *nowTime = [self timeOfNow];
//        NSString *nickName = deviceNickName;
//        NSString *cidStr = identifierForVendor;
//
//        NSDictionary *dict = @{
//                            
//                               @"start_date": @"20150810",
//                               @"end_date":nowTime,
//                               @"num": @"3",
//                               @"pno": @"1",
//                               @"icenseid":@"1",
//                               @"option":@"1",
//                               };
//        
//        HWLog(@"---dict*%@*",dict);
//        
//        if ([NSJSONSerialization isValidJSONObject:dict])
//        {
//            
//            NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
//            request.HTTPBody = data;
//            
//            __typeof(self) __weak safeSelf = self;
//            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                
//                if (!connectionError) {
//                    HWLog(@"datalength:%lu",(unsigned long)data.length);
//                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                    HWLog(@"dict[%@]",dict);
//                    
//                    HWLog(@"min_gen_time-----%@",dict[@"min_gen_time"]);
//                    HWLog(@"max_gen_time-----%@",dict[@"max_gen_time"]);
//                    HWLog(@"alarm_list-----%@",dict[@"alarm_list"]);
//                    
//                    NSArray *videoSidList = [Video mj_objectArrayWithKeyValuesArray:[dict objectForKey:@"alarm_list"]];
//                    Video * v = [[Video alloc] init];
////                    HWLog(@"video==%@--%@--%@--%@",v,v.alarm_info,v.alarm_info.video_url,v.title);
//                    [self.dataArray addObjectsFromArray:videoSidList];
//                  
//                    heardValue(heardArray,videoSidList);
//                }
//                else{
//                    HWLog(@"GetVideoDataTools==error:%@",connectionError);
//                    
//                }
//            }];
//        }
//        else
//        {
//            HWLog(@"数据有误");
//        }
// 
//    });
//
}

- (void)getListDataWithURL:(NSString *)URL ListID:(NSString *)ID ListValue:(ListValue) listValue{
    dispatch_queue_t global_t = dispatch_get_global_queue(0, 0);
    dispatch_async(global_t, ^{
        NSURL *url = [NSURL URLWithString:URL];
        NSMutableArray *listArray = [NSMutableArray array];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData *  data, NSError *  connectionError) {
            if (data == nil) {
                NSLog(@"错误%@",connectionError);
                return ;
            }
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *videoList = [dict objectForKey:ID];
            for (NSDictionary * video in videoList) {
                Video * v = [[Video alloc] init];
                [v setValuesForKeysWithDictionary:video];
                [listArray addObject:v];
            }
            listValue(listArray);
        }];
        
    });

}

// 懒加载初始数组
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (Video *)getModelWithIndex:(NSInteger)index
{
    return self.dataArray[index];
}

-(NSString *)timeOfNow{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

@end
