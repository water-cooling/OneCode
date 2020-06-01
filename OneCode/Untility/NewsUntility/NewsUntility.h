//
//  NewsUntility.h
//  bihucj
//
//  Created by humengfan on 2018/7/29.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"
#import "SucceedModel.h"
#import "FGError.h"
#import "FastNewListModel.h"
@interface NewsUntility : NSObject


+(void)GetFlashspageNo:(NSInteger )pageNo pageSize:(NSInteger )pageSize tTitleLike:(NSString *)tTitleLike callback:(void(^)(FastNewListResponseModel * Response ,FGError *error))block;


@end
