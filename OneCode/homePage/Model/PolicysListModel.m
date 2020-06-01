//
//  PolicysListModel.m
//  bihucj
//
//  Created by humengfan on 2018/7/29.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "PolicysListModel.h"

@implementation PolicysListModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}

@end



@implementation PolicysListResponseModel

+ (NSDictionary *)objectClassInArray{
    return @{
             @"rows" : @"PolicysListModel",
             
             };
    
}

@end


@implementation PolicysListdataModel

@end


@implementation PolicysListModels

+ (NSDictionary *)objectClassInArray{
    return @{
             @"messages" : @"MessageModel",
             
             };
    
}
@end


