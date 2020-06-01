//
//  AttriModelHeightModel.m
//  bihucj
//
//  Created by humengfan on 2018/8/3.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "AttriModelHeightModel.h"

@interface AttriModelHeightModel()


@property(nonatomic,strong)NSMutableDictionary * Cachedict;

@end

@implementation AttriModelHeightModel


-(void)UpdateSpaceLabelAttriStr:(NSString *)Str HeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width CacheIndexPath:(NSIndexPath *)Index{
  
    if ([Str isEqualToString: @""]) {
     
        [self.Cachedict removeObjectForKey:Index];

        return;
    }
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    /** 行高 */
    paraStyle.lineSpacing = lineSpeace;
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    CGSize size = [Str boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    NSLog(@"计算出的高度是%f",size.height);
    [self.Cachedict  setObject:@(size.height) forKey:Index];
    
    NSLog(@"%ld-----%ld",(long)Index.row,Index.section);
    
}


-(CGFloat)getSpaceLabelAttriCacheIndexPath:(NSIndexPath *)Index{
    
    if ([self.Cachedict objectForKey:Index]) {
        
        return [[self.Cachedict objectForKey:Index]doubleValue];
        
    }else
        
    {
        
        return 45;
    }
    
    
    
}


-(void)resume{
    
    
    [self.Cachedict removeAllObjects];
    
}


-(NSMutableDictionary *)Cachedict
{
    
    if (!_Cachedict) {
        
        _Cachedict = [NSMutableDictionary dictionary];

    }
    
    return _Cachedict;
    
    
}
@end
