//
//  AboutUntility.m
//  bihucj
//
//  Created by humengfan on 2018/7/29.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "AboutUntility.h"
#import <MJExtension.h>
#import <AFNetworking.h>
@implementation AboutUntility

+ (void)GetAboutcallback:(void (^)(AboutModel *, FGError *))block{
    
    
    NSString * url = [bihucjUrl stringByAppendingString:@"api/bihucj/other/about"];

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //网络请求超时时间
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //不需要进行请求头可以不设置
    
    NSDictionary * dict = @{@"appId":APPid};
    

    
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        AboutModels* success = [AboutModels mj_objectWithKeyValues:responseObject];
        
        if (success.code == 200) {
            
            
            block(success.data.response,nil);
            
            
        }else
        {
            
            block(nil,[FGError  ErrorCode:success.code DescribeStr:[success.messages[0]message]]);
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        block(nil,[FGError  ErrorCode:error.code DescribeStr:@"获取新闻错误"]);
        
    }];
    
    
}

+ (void)GetRecommandcallback:(void (^)(RecommandModel *, FGError *))block
{

    NSString * url = [bihucjUrl stringByAppendingString:@"api/bihucj/other/getShareUrl"];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //网络请求超时时间
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //不需要进行请求头可以不设置
    
    
    NSString * key = [[NSUserDefaults standardUserDefaults]objectForKey:@"sessionKey"];
    
    NSDictionary * dict = @{@"appId":APPid,@"sessionKey":key};
    
    
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        RecommandModels* success = [RecommandModels mj_objectWithKeyValues:responseObject];
        
        if (success.code == 200) {
            
            
            block(success.data.response,nil);
            
            
        }else
        {
            
            block(nil,[FGError  ErrorCode:success.code DescribeStr:[success.messages[0]message]]);
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        block(nil,[FGError  ErrorCode:error.code DescribeStr:@"获取新闻错误"]);
        
    }];
    
    

}



@end
