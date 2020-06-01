//
//  MoneyMarketUntility.m
//  bihucj
//
//  Created by humengfan on 2018/9/13.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "MoneyMarketUntility.h"
#import <AFNetworking.h>
#import <MJExtension.h>
@implementation MoneyMarketUntility


+ (void)GetdigiccyTitlecallback:(void (^)(NSMutableArray *, FGError *))block
{
    
    NSString * url = [bihucjUrl stringByAppendingString:@"api/bihucj/digiccy/init"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //网络请求超时时间
    
    manager.requestSerializer.timeoutInterval = 10;
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        digiccyTitleModel* success = [digiccyTitleModel mj_objectWithKeyValues:responseObject];
        
        if (success.code == 200) {
            
            
            
            block(success.data.response,nil);
            
            
        }else
        {
            
            block(nil,[FGError  ErrorCode:success.code DescribeStr:[success.messages[0]message]]);
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        block(nil,[FGError  ErrorCode:error.code DescribeStr:@"网络错误"]);
        
    }];
    
    
}

+ (void)GetdigiccyDetialPageSize:(NSInteger)PageSize pageNo:(NSInteger)pageNo base:(NSString *)base callback:(void (^)(moneyDetailResponseModel *, FGError *))block{
    
    NSString * url = [bihucjUrl stringByAppendingString:@"api/bihucj/digiccy/getTickerDetails"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //网络请求超时时间
    
    manager.requestSerializer.timeoutInterval = 10;
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary * dict = @{@"base":base,@"pageNo":@(pageNo),@"pageSize":@(PageSize),@"appId":APPid};
    
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        moneyDetailModels* success = [moneyDetailModels mj_objectWithKeyValues:responseObject];
        
        if (success.code == 200) {
            
            block(success.data.response,nil);
            
            
        }else
        {
            
            block(nil,[FGError  ErrorCode:success.code DescribeStr:[success.messages[0]message]]);
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        block(nil,[FGError  ErrorCode:error.code DescribeStr:@"网络错误"]);
        
    }];
    
    
}
@end
