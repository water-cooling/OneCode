//
//  FastNewLisModel.m
//  bihucj
//
//  Created by humengfan on 2018/7/29.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "FastNewListModel.h"

@implementation FastNewListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Format": @"dateFormat"};
}

@end

@implementation FastNewListResponseModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"rows":@"FastNewListModel",// 或者
             };
}

@end

@implementation FastNewListDataModel

@end

@implementation FastNewListModels

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"messages" : @"MessageModel",
             };
}



@end
