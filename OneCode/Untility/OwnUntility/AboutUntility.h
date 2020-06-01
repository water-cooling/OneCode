//
//  AboutUntility.h
//  bihucj
//
//  Created by humengfan on 2018/7/29.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AboutModel.h"
#import "FGError.h"
#import "RecommandModel.h"
@interface AboutUntility : NSObject

+(void)GetAboutcallback:(void(^)(AboutModel * about,FGError *error))block;

+(void)GetRecommandcallback:(void(^)(RecommandModel * recommand,FGError *error))block;

@end
