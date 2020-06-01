//
//  FastNewLisModel.m
//  bihucj
//
//  Created by humengfan on 2018/7/29.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "FastNewListModel.h"

@implementation FastNewListModel



@end

@implementation FastNewListResponseModel

+ (NSDictionary *)objectClassInArray{
    return @{
             @"rows" : @"FastNewListModel",
             
             };
    
}


@end

@implementation FastNewListDataModel

@end

@implementation FastNewListModels

+ (NSDictionary *)objectClassInArray{
    return @{
             @"messages" : @"MessageModel",
             
             };
    
}


@end
