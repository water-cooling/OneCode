//
//  MoneyMarketUntility.h
//  bihucj
//
//  Created by humengfan on 2018/9/13.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FGError.h"
#import "digiccyTitleModel.h"
#import "moneyDetailModel.h"

@interface MoneyMarketUntility : NSObject

+(void)GetdigiccyTitlecallback:(void(^)(NSMutableArray * response,FGError *error))block;


+(void)GetdigiccyDetialPageSize:(NSInteger)PageSize pageNo:(NSInteger)pageNo base:(NSString *)base callback:(void(^)(moneyDetailResponseModel * response,FGError *error))block;


@end
