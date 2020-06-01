//
//  FGError.h
//  FungusProject
//
//  Created by humengfan on 2018/5/22.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGError : NSObject

@property(nonatomic,assign)NSInteger code;
@property(nonatomic,copy)NSString * descriptionStr;

+(FGError *)ErrorCode:(NSInteger )code DescribeStr:(NSString * )str;
@end
