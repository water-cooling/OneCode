//
//  AttriModelHeightModel.h
//  bihucj
//
//  Created by humengfan on 2018/8/3.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttriModelHeightModel : NSObject

-(void)UpdateSpaceLabelAttriStr:(NSString *)Str HeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width CacheIndexPath:(NSIndexPath *)Index;


-(CGFloat)getSpaceLabelAttriCacheIndexPath:(NSIndexPath *)Index;


-(void)resume;
@end
