//
//  UserUtility.m
//  bihucj
//
//  Created by humengfan on 2018/7/29.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "UserUtility.h"
#import <AFNetworking.h>
#import <MJExtension.h>


@implementation UserUtility

+ (void)usernameSignIn:(NSString *)username password:(NSString *)pwd callback:(void (^)(UserModel *, FGError *))block
{
    
    NSString * url = [bihucjUrl stringByAppendingString:@"api/bihucj/uc/login"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //网络请求超时时间
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSDictionary * dict = @{@"appId":APPid, @"mobile":username,@"password":pwd};
    
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        LoginModel* login = [LoginModel mj_objectWithKeyValues:responseObject];
        
        if (login.code == 200) {
            
            [[NSUserDefaults standardUserDefaults]setObject:login.data.response.sessionKey forKey:@"sessionKey"];
            
            [[NSUserDefaults standardUserDefaults]setObject:@(5-login.data.response.readArticleNum) forKey:@"readArticleNum"];

            [[NSUserDefaults standardUserDefaults]setObject:username forKey:@"username"];

            block(login.data.response,nil);
            
        }else
        {
            
            block(nil,[FGError  ErrorCode:login.code DescribeStr:[login.messages[0]message]]);
            
        }
        NSLog(@"token222%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"token"]);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        block(nil,[FGError  ErrorCode:error.code DescribeStr:@"登录错误"]);
        
    }];
    
    
    
}




+ (void)usernameSignOutcallback:(void (^)(SucceedModel *, FGError *))block{
    
    NSString * url = [bihucjUrl stringByAppendingString:@"api/bihucj/uc/logout"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //网络请求超时时间
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSString * key = [[NSUserDefaults standardUserDefaults]objectForKey:@"sessionKey"];
    
    NSDictionary * dict = @{@"appId":APPid,@"sessionKey":key};
    
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        SucceedModels* success = [SucceedModels mj_objectWithKeyValues:responseObject];
        
        if (success.code == 200) {
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"sessionKey"];
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"readArticleNum"];

            block(success.data.response,nil);
            
            
        }else
        {
            
            block(nil,[FGError  ErrorCode:success.code DescribeStr:[success.messages[0]message]]);
            
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        block(nil,[FGError  ErrorCode:error.code DescribeStr:@"注销错误"]);
        
    }];
    
    
}


+ (void)GetImageCodecallback:(void (^)(ImageModel *, FGError *))block
{
    NSString * url = [bihucjUrl stringByAppendingString:@"api/otenda/uc/sendImageCode"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //网络请求超时时间
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    
    
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        CodeImageModel*  Imagemodel = [CodeImageModel mj_objectWithKeyValues:responseObject];
        
        if (Imagemodel.code == 200) {
            
            
            block(Imagemodel.data.response,nil);
            
        }else
        {
            block(nil,[FGError  ErrorCode:Imagemodel.code DescribeStr:[Imagemodel.messages[0]message]]);
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        block(nil,[FGError  ErrorCode:error.code DescribeStr:@"获取图片错误"]);
        
    }];
    
    
}

+ (void)SendCodeID:(NSString *)code imgValue:(NSString *)imgValue type:(NSString *)type mobile:(NSString *)mobile callback:(void (^)(SucceedModel *, FGError *))block{
    
    NSString * url = [bihucjUrl stringByAppendingString:@"api/otenda/uc/sendSmsCode"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //网络请求超时时间
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //不需要进行请求头可以不设置
    
    NSDictionary * dict = @{@"appId":APPid,@"imgId":code,@"imgValue":imgValue,@"type":type,@"mobile":mobile};
    
    
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SucceedModels* success = [SucceedModels mj_objectWithKeyValues:responseObject];
        
        if (success.code == 200) {
            
            
            
            block(success.data.response,nil);
            
            
        }else
        {
            
            block(nil,[FGError  ErrorCode:success.code DescribeStr:[success.messages[0]message]]);
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        block(nil,[FGError  ErrorCode:error.code DescribeStr:@"获取短信错误"]);
        
    }];
    
    
}

+ (void)verifyImageCodeID:(NSString *)ID CodeValue:(NSString *)code callback:(void (^)(SucceedModel *, FGError *))block{
    
    NSString * url = [bihucjUrl stringByAppendingString:@"api/otenda/uc/checkImageCode"];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //网络请求超时时间
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //不需要进行请求头可以不设置
    
    NSDictionary * dict = @{@"appId":APPid,@"imgId":ID,@"imgValue":code};
    
    
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SucceedModels* success = [SucceedModels mj_objectWithKeyValues:responseObject];
        
        if (success.code == 200) {
            
            
            
            block(success.data.response,nil);
            
            
        }else
        {
            
            block(nil,[FGError  ErrorCode:success.code DescribeStr:[success.messages[0]message]]);
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        block(nil,[FGError  ErrorCode:error.code DescribeStr:@"验证图片获取错误"]);
        
    }];
    
}


+ (void)EditPasswordCodeValue:(NSString *)code mobile:(NSString *)mobile password:(NSString *)password callback:(void (^)(SucceedModel *, FGError *))block{
    
    NSString * url = [bihucjUrl stringByAppendingString:@"api/bihucj/uc/findPwd"];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //网络请求超时时间
    
    manager.requestSerializer.timeoutInterval = 10;
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    
    NSDictionary * dict = @{@"appId":APPid, @"code":code,@"mobile":mobile,@"password":password};
    
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        SucceedModels* success = [SucceedModels mj_objectWithKeyValues:responseObject];
        
        if (success.code == 200) {
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"sessionKey"];
            
            block(success.data.response,nil);
            
            
        }else
        {
            
            block(nil,[FGError  ErrorCode:success.code DescribeStr:[success.messages[0]message]]);
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        block(nil,[FGError  ErrorCode:error.code DescribeStr:@"修改密码错误"]);
        
    }];
   
    
    
    
}

+ (void)EditIphoneCodeValue:(NSString *)code mobile:(NSString *)mobile callback:(void (^)(SucceedModel *, FGError *))block{
    
    NSString * url = [bihucjUrl stringByAppendingString:@"api/bihucj/uc/changeMobile"];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //网络请求超时时间
    
    manager.requestSerializer.timeoutInterval = 10;
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString * key = [[NSUserDefaults standardUserDefaults]objectForKey:@"sessionKey"];
    
    NSDictionary * dict = @{@"appId":APPid,@"sessionKey":key, @"code":code,@"mobile":mobile};
    
    
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        SucceedModels* success = [SucceedModels mj_objectWithKeyValues:responseObject];
        
        if (success.code == 200) {
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"sessionKey"];
            
            block(success.data.response,nil);
            
        }else
        {
            
            block(nil,[FGError  ErrorCode:success.code DescribeStr:[success.messages[0]message]]);
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        block(nil,[FGError  ErrorCode:error.code DescribeStr:@"修改手机号码错误"]);
        
    }];
    
    
    
}


+(void)usernameRegiseIn:(NSString *)code mobile:(NSString *)username password:(NSString *)pwd callback:(void (^)( SucceedModel *, FGError *))block{
    
    NSString * url = [bihucjUrl stringByAppendingString:@"api/bihucj/uc/reg"];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //网络请求超时时间
    
    manager.requestSerializer.timeoutInterval = 10;
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    
    NSDictionary * dict = @{@"appId":APPid, @"code":code,@"mobile":username,@"password":pwd};
    
    
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        SucceedModels* success = [SucceedModels mj_objectWithKeyValues:responseObject];
        
        if (success.code == 200) {
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"sessionKey"];
            
            
            block(success.data.response,nil);
            
            
        }else
        {
            
            block(nil,[FGError  ErrorCode:success.code DescribeStr:[success.messages[0]message]]);
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        block(nil,[FGError  ErrorCode:error.code DescribeStr:@"修改手机号码错误"]);
        
    }];
    
    
}

+ (BOOL)hasLogin
{
    if ([self getAccessToken] == nil) {
        
        return NO;
    }else
    {
        
        return YES;
        
    }
    
}

+ (NSString *)getAccessToken
{
    
    return  [[NSUserDefaults standardUserDefaults]objectForKey:@"sessionKey"];
    
}
@end
