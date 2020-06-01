//
//  UserUtility.h
//  bihucj
//
//  Created by humengfan on 2018/7/29.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"
#import "SucceedModel.h"
#import "ImageModel.h"
#import "FGError.h"
#import "UserModel.h"

@interface UserUtility : NSObject

//登录
+(void)usernameSignIn:(NSString *)username password:(NSString * )pwd callback:(void(^)(UserModel * user,FGError *error))block;
//退出
+(void)usernameSignOutcallback:(void(^)(SucceedModel * cancel,FGError *error))block;

//获取图片验证
+(void)GetImageCodecallback:(void(^)(ImageModel * Image,FGError *error))block;
//图片验证正确
+(void)verifyImageCodeID:(NSString *)ID CodeValue:(NSString *)code callback:(void(^)(SucceedModel * succeed,FGError *error))block;
//获取短信验证

+(void)SendCodeID:(NSString *)code imgValue:(NSString *)imgValue type:(NSString *)type  mobile:(NSString *)mobile callback:(void(^)(SucceedModel * succeed,FGError *error))block;


//修改密码验证
+(void)EditPasswordCodeValue:(NSString *)code mobile:(NSString *)mobile password:(NSString *)password callback:(void(^)(SucceedModel * succeed,FGError *error))block;

+(void)EditIphoneCodeValue:(NSString *)code mobile:(NSString *)mobile callback:(void(^)(SucceedModel * succeed,FGError *error))block;

+ (void)usernameRegiseIn:(NSString *)code mobile:(NSString *)username password:(NSString *)pwd callback:(void (^)(SucceedModel *user, FGError *error))block;

+(BOOL)hasLogin;

@end
