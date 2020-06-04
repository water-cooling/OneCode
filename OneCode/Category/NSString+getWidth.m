//
//  NSString+getWidth.m
//  FungusProject
//
//  Created by humengfan on 2018/5/9.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "NSString+getWidth.h"

@implementation NSString (getWidth)

-(CGFloat)getLabel:(UIFont *)font LabHeight:(CGFloat)height{
    
    CGSize size = CGSizeMake(9000, height);
    
    NSDictionary *  dic =  @{NSFontAttributeName:font};
    
    return  [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.width;
    
    
}

-(CGFloat)getLabel:(UIFont *)font LabWdith:(CGFloat)wdith{
    
    CGSize size = CGSizeMake(wdith, 90000);
    
    NSDictionary *  dic =  @{NSFontAttributeName:font};
    
    return  [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height;
    
    
    
}





@end
