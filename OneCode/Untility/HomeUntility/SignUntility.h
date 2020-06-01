//
//  SignUntility.h
//  bihucj
//
//  Created by humengfan on 2018/8/23.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignModel.h"
#import "SignListModel.h"
#import "SucceedModel.h"
#import "FGError.h"
#import "ownShowModel.h"
#import "OwnCountModel.h"
@interface SignUntility : NSObject


+ (void)GetSignTimescallback:(void (^)(SignResponseModel * response, FGError * error))block;


+ (void)GetSignListcallback:(void (^)(SignListdataModel * data, FGError * error))block;


+(void)SignClickcallback:(void (^)(SucceedModel * response, FGError * error))block;

+(void)shareArticlecallback:(void (^)(SucceedModel * response, FGError * error))block;


+(void)shareLinkcallback:(void (^)(SucceedModel * response, FGError * error))block;


+(void)ReadArticlecallback:(void (^)(SucceedModel * response, FGError * error))block;

+ (void)getOwnListArristoday:(BOOL)today pageSize:(NSInteger)size pageCount:(NSInteger)count callback:(void (^)(ownShowResponseModel *response, FGError *error))block;

//我的页面显示
+(void)getowncountcallBack:(void (^)(OwnCountModel * response, FGError * error))block;


+(void)GetRecommandLinkcallback:(void(^)(SucceedModel * success,FGError *error))block;

@end
