//
//  HomeNewsModel.m
//  bihucj
//
//  Created by humengfan on 2018/7/29.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "HomeNewsModel.h"

@implementation HomeNewsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}

@end


@implementation BannerModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}

@end

@implementation HomeNewsResponseModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"rows" : @"HomeNewsModel",
             @"advRows" : @"BannerModel",

             };
    
}

@end


@implementation HomeNewsdataModel

@end


@implementation HomeNewsModels

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"messages" : @"MessageModel",
             
             };
    
}

@end
