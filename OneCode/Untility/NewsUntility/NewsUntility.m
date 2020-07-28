//
//  NewsUntility.m
//  bihucj
//
//  Created by humengfan on 2018/7/29.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "NewsUntility.h"
#import <AFNetworking.h>
@implementation NewsUntility
+ (void)GetFlashspageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize tTitleLike:(NSString *)tTitleLike callback:(void (^)(FastNewListResponseModel *, FGError *))block{
    NSString * url =  [bihucjUrl stringByAppendingString:@"api/bihucj/flash/getFlashs"];
    NSLog(@"%@",url);
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
    NSLog(@"%@",dict);
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        FastNewListModels* success = [FastNewListModels mj_objectWithKeyValues:responseObject];
        if (success.code == 200) {
            block(success.data.response,nil);
        }else{
            block(nil,[FGError  ErrorCode:success.code DescribeStr:[success.messages[0]message]]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil,[FGError  ErrorCode:error.code DescribeStr:@"获取新闻错误"]);
    }];
    
}
@end
