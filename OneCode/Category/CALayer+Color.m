//
//  CALayer+Color.m
//  FungusProject
//
//  Created by humengfan on 2018/5/14.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "CALayer+Color.h"

@implementation CALayer (Color)

- (void)setBorderColorWithUIColor:(UIColor *)color
{
    
    self.borderColor = color.CGColor;
}
@end
