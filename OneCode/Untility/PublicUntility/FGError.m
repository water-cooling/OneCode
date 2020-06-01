//
//  FGError.m
//  FungusProject
//
//  Created by humengfan on 2018/5/22.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "FGError.h"

@implementation FGError

+(FGError *)ErrorCode:(NSInteger )code DescribeStr:(NSString * )str
{
    
    FGError * error =[FGError new];
    
    error.code = code;
    error.descriptionStr = str;
    return error;
    
}
@end
