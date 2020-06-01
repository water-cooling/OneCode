//
//  HomeUntility.h
//  bihucj
//
//  Created by humengfan on 2018/7/29.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"
#import "SucceedModel.h"
#import "FGError.h"
#import "HomeNewsModel.h"
#import "PolicysListModel.h"
@interface HomeUntility : NSObject


+ (void)GetHomeNewshasAdv:(BOOL)hasAdv  pageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize tTitleLike:(NSString *)tTitleLike SelectIndex:(NSInteger)index callback:(void (^)(HomeNewsResponseModel * response, FGError * error))block;

+(void)GetHomegetPolicyspageNo:(NSInteger )pageNo pageSize:(NSInteger )pageSize tTitleLike:(NSString *)tTitleLike callback:(void(^)(PolicysListResponseModel * Response ,FGError *error))block;


+(void)NewsLick:(NSInteger)newsId callback:(void(^)(SucceedModel * success ,FGError *error))block;


@end
