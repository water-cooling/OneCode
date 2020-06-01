//
//  HomeUntility.m
//  bihucj
//
//  Created by humengfan on 2018/7/29.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "HomeUntility.h"
#import <MJExtension.h>
#import <AFNetworking.h>
@implementation HomeUntility

+ (void)GetHomeNewshasAdv:(BOOL)hasAdv  pageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize tTitleLike:(NSString *)tTitleLike SelectIndex:(NSInteger)index callback:(void (^)(HomeNewsResponseModel *, FGError *))block
{
    
    NSString * AppendStr ;
    
    
    switch (index) {
        case 0:
            
            AppendStr = @"api/bihucj/index/getNews";
            break;
            
        case 1:
            
            AppendStr = @"api/bihucj/extra/getExtraIds";
            
            break;
            
        case 2:
            
            AppendStr = @"api/bihucj/Quotation/getQuotations";
            
            break;
            
        case 3 :
            
            AppendStr = @"api/bihucj/column/getColumns";

            break;
            
        case 4 :
            
            AppendStr = @"api/bihucj/policy/getPolicys";

            break;
        default:
            break;
    }
    
    NSString * url =  [bihucjUrl stringByAppendingString:AppendStr];

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //网络请求超时时间
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //不需要进行请求头可以不设置
    
    NSMutableDictionary * dict = @{@"appId":APPid,@"hasAdv":@(hasAdv),@"pageNo":@(pageNo),@"pageSize":@(pageSize),@"tTitleLike":tTitleLike}.mutableCopy;
    
    
    if ([tTitleLike isEqualToString:@""]) {
        
        [dict removeObjectForKey:@"tTitleLike"];
    }
    
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HomeNewsModels* success = [HomeNewsModels mj_objectWithKeyValues:responseObject];
        
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


+ (void)GetHomegetPolicyspageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize tTitleLike:(NSString *)tTitleLike callback:(void (^)(PolicysListResponseModel *, FGError *))block
{
    
    NSString * url =  [bihucjUrl stringByAppendingString:@"api/bihucj/policy/getPolicys"];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //网络请求超时时间
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //不需要进行请求头可以不设置
    
    NSMutableDictionary * dict = @{@"appId":APPid,@"pageNo":@(pageNo),@"pageSize":@(pageSize),@"tTitleLike":tTitleLike}.mutableCopy;
    
    
    if ([tTitleLike isEqualToString:@""]) {
        
        [dict removeObjectForKey:@"tTitleLike"];
    }
    
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        PolicysListModels* success = [PolicysListModels mj_objectWithKeyValues:responseObject];
        
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

+ (void)NewsLick:(NSInteger)newsId callback:(void (^)(SucceedModel *, FGError *))block
{
    
    NSString * url =  [bihucjUrl stringByAppendingString:@"api/bihucj/other/addNum"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //网络请求超时时间
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //不需要进行请求头可以不设置
    
    NSDictionary * dict = @{@"id":@(newsId),@"appId":APPid};
    
    
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SucceedModels* success = [SucceedModels mj_objectWithKeyValues:responseObject];
        
        if (success.code == 200) {
            
            block(success.data.response,nil);
            
            
        }else
        {
            
            block(nil,[FGError  ErrorCode:success.code DescribeStr:[success.messages[0]message]]);
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        block(nil,[FGError  ErrorCode:error.code DescribeStr:@"点击错误"]);
        
    }];
    
    
}

@end
