//
//  SignUntility.m
//  bihucj
//
//  Created by humengfan on 2018/8/23.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "SignUntility.h"
#import <AFNetworking.h>
#import <MJExtension.h>

@implementation SignUntility

+ (void)GetSignTimescallback:(void (^)(SignResponseModel *, FGError *))block
{
    NSString * url =  [bihucjUrl stringByAppendingString:@"api/bihucj/signIn/getSignedInNum"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //网络请求超时时间
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //不需要进行请求头可以不设置
    
    NSString * key = [[NSUserDefaults standardUserDefaults]objectForKey:@"sessionKey"];
    
    NSDictionary * dict = @{@"appId":APPid,@"sessionKey":key};

    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        SignModel* success = [SignModel mj_objectWithKeyValues:responseObject];
        
        if (success.code == 200) {
            
            block(success.data.response,nil);
            
        }else
        {
            block(nil,[FGError  ErrorCode:success.code DescribeStr:[success.messages[0]message]]);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        block(nil,[FGError  ErrorCode:error.code DescribeStr:@"获取错误"]);
        
    }];
    
    
}

+ (void)GetSignListcallback:(void (^)(SignListdataModel *, FGError *))block{
    
    NSString * url =  [bihucjUrl stringByAppendingString:@"api/bihucj/signIn/getSignInBase"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //网络请求超时时间
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //不需要进行请求头可以不设置
    
    NSDictionary * dict = @{@"appId":APPid,@"sessionKey":@""};
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        SignListModels* success = [SignListModels mj_objectWithKeyValues:responseObject];
        
        if (success.code == 200) {
            
            block(success.data,nil);
            
        }else
        {
            block(nil,[FGError  ErrorCode:success.code DescribeStr:[success.messages[0]message]]);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        block(nil,[FGError  ErrorCode:error.code DescribeStr:@"获取列表错误"]);
        
    }];
    
    
    
}

+ (void)SignClickcallback:(void (^)(SucceedModel *, FGError *))block
{
    NSString * url =  [bihucjUrl stringByAppendingString:@"api/bihucj/signIn/qiandao"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //网络请求超时时间
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //不需要进行请求头可以不设置
    
    NSString * key = [[NSUserDefaults standardUserDefaults]objectForKey:@"sessionKey"];
    
    NSDictionary * dict = @{@"appId":APPid,@"sessionKey":key};
    
    
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        SucceedModels* success = [SucceedModels mj_objectWithKeyValues:responseObject];
        
        if (success.code == 200) {
            
            block(success.data.response,nil);
            
        }else
        {
            
            block(nil,[FGError  ErrorCode:success.code DescribeStr:[success.messages[0]message]]);
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        block(nil,[FGError  ErrorCode:error.code DescribeStr:@"获取错误"]);
        
    }];
    
    
}

+ (void)shareArticlecallback:(void (^)(SucceedModel *, FGError *))block{
    
    NSString * url =  [bihucjUrl stringByAppendingString:@"api/bihucj/pearl/getPearlByShareFlash"];

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //网络请求超时时间
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //不需要进行请求头可以不设置
    
    NSString * key = [[NSUserDefaults standardUserDefaults]objectForKey:@"sessionKey"];
    
    NSDictionary * dict = @{@"appId":APPid,@"sessionKey":key};
    
    
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        SucceedModels* success = [SucceedModels mj_objectWithKeyValues:responseObject];
        
        if (success.code == 200) {
            
            block(success.data.response,nil);
            
        }else
        {
            
            block(nil,[FGError  ErrorCode:success.code DescribeStr:[success.messages[0]message]]);
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        block(nil,[FGError  ErrorCode:error.code DescribeStr:@"获取错误"]);
        
    }];
    
    
}

+(void)shareLinkcallback:(void (^)(SucceedModel *, FGError *))block
{
    
    NSString * url =  [bihucjUrl stringByAppendingString:@"api/bihucj/pearl/getPearlByShareArticle"];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //网络请求超时时间
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //不需要进行请求头可以不设置
    
    NSString * key = [[NSUserDefaults standardUserDefaults]objectForKey:@"sessionKey"];
    
    NSDictionary * dict = @{@"appId":APPid,@"sessionKey":key};
    
    
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        SucceedModels* success = [SucceedModels mj_objectWithKeyValues:responseObject];
        
        if (success.code == 200) {
            
            block(success.data.response,nil);
            
        }else
        {
            
            block(nil,[FGError  ErrorCode:success.code DescribeStr:[success.messages[0]message]]);
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        block(nil,[FGError  ErrorCode:error.code DescribeStr:@"获取错误"]);
        
    }];
    
    
}


+(void)ReadArticlecallback:(void (^)(SucceedModel *, FGError *))block
{
    
    NSString * url =  [bihucjUrl stringByAppendingString:@"api/bihucj/pearl/getPearlByReadArticle"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //网络请求超时时间
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //不需要进行请求头可以不设置
    
    NSString * key = [[NSUserDefaults standardUserDefaults]objectForKey:@"sessionKey"];
    
    NSDictionary * dict = @{@"appId":APPid,@"sessionKey":key};
    
    
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        SucceedModels* success = [SucceedModels mj_objectWithKeyValues:responseObject];
        
        if (success.code == 200) {
            
            block(success.data.response,nil);
            
        }else
        {
            
            block(nil,[FGError  ErrorCode:success.code DescribeStr:[success.messages[0]message]]);
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        block(nil,[FGError  ErrorCode:error.code DescribeStr:@"获取错误"]);
        
    }];
    
    
}

+ (void)getOwnListArristoday:(BOOL)today pageSize:(NSInteger)size pageCount:(NSInteger)count callback:(void (^)(ownShowResponseModel *, FGError *))block{
    
    NSString * url =  [bihucjUrl stringByAppendingString:@"api/bihucj/pearl/getPearls"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //网络请求超时时间
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //不需要进行请求头可以不设置
    
    NSString * key = [[NSUserDefaults standardUserDefaults]objectForKey:@"sessionKey"];
    
    NSDictionary * dict = @{@"appId":APPid,@"isToday":@(today),@"pageNo":@(count),@"pageSize":@(size),@"sessionKey":key};
    
    
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        ownShowModels* success = [ownShowModels mj_objectWithKeyValues:responseObject];
        
        if (success.code == 200) {
            
            block(success.data.response,nil);
            
        }else
        {
            
            block(nil,[FGError  ErrorCode:success.code DescribeStr:[success.messages[0]message]]);
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        block(nil,[FGError  ErrorCode:error.code DescribeStr:@"获取错误"]);
        
    }];
    
    
}

+(void)getowncountcallBack:(void (^)(OwnCountModel *, FGError *))block
{
    
    NSString * url =  [bihucjUrl stringByAppendingString:@"api/bihucj/pearl/getMyPearl"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //网络请求超时时间
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //不需要进行请求头可以不设置
    
    NSString * key = [[NSUserDefaults standardUserDefaults]objectForKey:@"sessionKey"];
    
    NSDictionary * dict = @{@"appId":APPid,@"sessionKey":key};
    
    
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        OwnCountModels* success = [OwnCountModels mj_objectWithKeyValues:responseObject];
        
        if (success.code == 200) {
            
            block(success.data.response,nil);
            
        }else
        {
            
            block(nil,[FGError  ErrorCode:success.code DescribeStr:[success.messages[0]message]]);
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        block(nil,[FGError  ErrorCode:error.code DescribeStr:@"获取错误"]);
        
    }];
    
}

+ (void)GetRecommandLinkcallback:(void (^)(SucceedModel *, FGError *))block
{
    
    NSString * url = [bihucjUrl stringByAppendingString:@"api/bihucj/other/invateUser"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //网络请求超时时间
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //不需要进行请求头可以不设置
    
    NSString * key = [[NSUserDefaults standardUserDefaults]objectForKey:@"sessionKey"];
    
    NSDictionary * dict = @{@"appId":APPid,@"sessionKey":key};
    
    
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        SucceedModels* success = [SucceedModels mj_objectWithKeyValues:responseObject];
        
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
