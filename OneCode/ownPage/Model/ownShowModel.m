//
//  ownShowModel.m
//  bihucj
//
//  Created by humengfan on 2018/8/30.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "ownShowModel.h"

@implementation ownShowModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end

@implementation ownShowResponseModel

+ (NSDictionary *)objectClassInArray{
    return @{
             @"rows" : @"ownShowModel",
             
             };
    
}

@end


@implementation ownShowDataModel

@end


@implementation ownShowModels

+ (NSDictionary *)objectClassInArray{
    return @{
             @"messages" : @"MessageModel",
             
             };
    
}

@end




